import 'dart:math' as math;

import 'package:music_app/src/core/services/artwork_cache/artwork_cache.dart';
import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:music_app/src/core/services/media_scanner/media_scanner.dart';
import 'package:music_app/src/core/services/metadata_reader/metadata_reader.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';

const _unknownArtist = 'Unknown Artist';
const _unknownAlbum = 'Unknown Album';

/// How many files each transaction covers.
///
/// Every commit costs a disk sync, so batching is what makes a large scan
/// fast; the size is a balance against progress, which can only be
/// reported once a batch has committed and so advances in steps this
/// wide.
const _commitBatchSize = 25;

/// Progress of an in-flight [LibraryIndexer.indexLibrary] run.
class IndexingProgress {
  /// Creates an [IndexingProgress].
  const IndexingProgress({
    required this.processed,
    required this.total,
    required this.trackSourceId,
  });

  /// Number of files processed so far.
  final int processed;

  /// Total number of files to process.
  final int total;

  /// Source id of the file that was just indexed.
  final String trackSourceId;
}

/// Scans the device, reads each file's metadata and writes the resulting
/// tracks, albums and artists to the local library, grouping tracks by
/// artist and album.
///
/// Each run is treated as a full picture of the device: tracks, albums and
/// artists already known by their `sourceId` keep their identifiers and have
/// their aggregates (track/album counts, total duration) recomputed from
/// scratch, so re-scans don't double count previously indexed files.
class LibraryIndexer {
  /// Creates a [LibraryIndexer].
  const LibraryIndexer({
    required MediaScanner mediaScanner,
    required MetadataReader metadataReader,
    required ArtworkCache artworkCache,
    required LibraryLocalDataSource dataSource,
    required IdGenerator idGenerator,
  }) : _mediaScanner = mediaScanner,
       _metadataReader = metadataReader,
       _artworkCache = artworkCache,
       _dataSource = dataSource,
       _idGenerator = idGenerator;

  final MediaScanner _mediaScanner;
  final MetadataReader _metadataReader;
  final ArtworkCache _artworkCache;
  final LibraryLocalDataSource _dataSource;
  final IdGenerator _idGenerator;

  /// Scans the device and indexes every supported audio file found,
  /// yielding progress as files are processed.
  ///
  /// Files under any of [excludedFolders] are skipped.
  Stream<IndexingProgress> indexLibrary({
    List<String> excludedFolders = const [],
  }) async* {
    final files = await _mediaScanner.scan(excludedFolders: excludedFolders);
    final artistsBySourceId = <String, Artist>{};
    final albumsBySourceId = <String, Album>{};
    final writtenArtists = <String>{};
    // Read once for the whole run: every file needs to know whether it is
    // already indexed, and asking per file is one query per file on a table
    // as large as the library.
    final trackIdsBySourceId = await _dataSource.findTrackIdsBySourceId();

    var processed = 0;
    for (var start = 0; start < files.length; start += _commitBatchSize) {
      final end = math.min(start + _commitBatchSize, files.length);
      final batch = files.sublist(start, end);
      final batchProgress = <IndexingProgress>[];

      await _dataSource.runInTransaction(() async {
        for (final file in batch) {
          final metadata = await _metadataReader.read(file.filePath);

          var artist = await _resolveArtist(
            name: metadata.artist ?? file.artist ?? _unknownArtist,
            cache: artistsBySourceId,
          );

          final albumResolution = await _resolveAlbum(
            title: metadata.album ?? file.album ?? _unknownAlbum,
            artist: artist,
            cache: albumsBySourceId,
          );
          var album = albumResolution.album;

          final artwork = metadata.artwork;
          if (artwork != null && album.artworkPath == null) {
            final artworkPath = await _artworkCache.save(
              id: album.id,
              data: artwork.data,
              mimeType: artwork.mimeType,
            );
            album = album.copyWith(artworkPath: artworkPath);
          }

          final duration = metadata.duration ?? file.duration;
          album = album.copyWith(
            trackCount: album.trackCount + 1,
            totalDuration: album.totalDuration + duration,
          );
          albumsBySourceId[album.sourceId] = album;

          artist = artist.copyWith(
            trackCount: artist.trackCount + 1,
            albumCount: artist.albumCount + (albumResolution.isNew ? 1 : 0),
          );
          artistsBySourceId[artist.sourceId] = artist;

          // Only the first file of each artist and album writes a row here,
          // because the track inserted below references both by id and they
          // have to exist for it. Their running totals are flushed once after
          // the loop instead of rewritten per file, which on a large library
          // is thousands of writes that each also invalidate every query
          // stream watching these tables.
          if (writtenArtists.add(artist.sourceId)) {
            await _dataSource.upsertArtist(artist);
          }
          if (albumResolution.isNew) {
            await _dataSource.upsertAlbum(album);
          }

          final trackSourceId = file.mediaStoreId.toString();
          final track = Track(
            id: trackIdsBySourceId[trackSourceId] ?? _idGenerator.generate(),
            sourceId: trackSourceId,
            filePath: file.filePath,
            title: metadata.title ?? file.title,
            artistId: artist.id,
            albumId: album.id,
            duration: duration,
            format: file.fileExtension,
            fileSize: file.fileSize,
            hasEmbeddedArtwork: artwork != null,
            dateAdded: file.dateAdded,
            dateModified: file.dateModified,
            trackNumber: metadata.trackNumber,
            discNumber: metadata.discNumber,
            year: metadata.year,
            genre: metadata.genre,
          );
          await _dataSource.upsertTrack(track);

          processed++;
          batchProgress.add(
            IndexingProgress(
              processed: processed,
              total: files.length,
              trackSourceId: trackSourceId,
            ),
          );
        }
      });

      yield* Stream.fromIterable(batchProgress);
    }

    await _dataSource.runInTransaction(() async {
      for (final artist in artistsBySourceId.values) {
        await _dataSource.upsertArtist(artist);
      }
      for (final album in albumsBySourceId.values) {
        await _dataSource.upsertAlbum(album);
      }
    });
  }

  Future<Artist> _resolveArtist({
    required String name,
    required Map<String, Artist> cache,
  }) async {
    final sourceId = _normalize(name);

    final cached = cache[sourceId];
    if (cached != null) return cached;

    final existing = await _dataSource.findArtistBySourceId(sourceId);
    if (existing != null) {
      // This run recomputes aggregates from scratch as files are seen.
      final reset = existing.copyWith(albumCount: 0, trackCount: 0);
      cache[sourceId] = reset;
      return reset;
    }

    final artist = Artist(
      id: _idGenerator.generate(),
      sourceId: sourceId,
      name: name,
      albumCount: 0,
      trackCount: 0,
    );
    cache[sourceId] = artist;
    return artist;
  }

  Future<_AlbumResolution> _resolveAlbum({
    required String title,
    required Artist artist,
    required Map<String, Album> cache,
  }) async {
    final sourceId = '${artist.sourceId}::${_normalize(title)}';

    final cached = cache[sourceId];
    if (cached != null) return _AlbumResolution(cached, isNew: false);

    final existing = await _dataSource.findAlbumBySourceId(sourceId);
    if (existing != null) {
      // This run recomputes aggregates from scratch as files are seen.
      // isNew here means "first time seen in this run", so the owning
      // artist's albumCount still counts it, even though the album itself
      // already existed in the database.
      final reset = existing.copyWith(
        trackCount: 0,
        totalDuration: Duration.zero,
      );
      cache[sourceId] = reset;
      return _AlbumResolution(reset, isNew: true);
    }

    final album = Album(
      id: _idGenerator.generate(),
      sourceId: sourceId,
      title: title,
      artistId: artist.id,
      trackCount: 0,
      totalDuration: Duration.zero,
    );
    cache[sourceId] = album;
    return _AlbumResolution(album, isNew: true);
  }

  String _normalize(String value) => value.trim().toLowerCase();
}

class _AlbumResolution {
  const _AlbumResolution(this.album, {required this.isNew});

  final Album album;
  final bool isNew;
}
