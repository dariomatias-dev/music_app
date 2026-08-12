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

/// Progress of an in-flight [LibraryIndexer.indexLibrary] run.
class IndexingProgress {
  /// Creates an [IndexingProgress].
  const IndexingProgress({required this.processed, required this.total});

  /// Number of files processed so far.
  final int processed;

  /// Total number of files to process.
  final int total;
}

/// Scans the device, reads each file's metadata and writes the resulting
/// tracks, albums and artists to the local library, grouping tracks by
/// artist and album.
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
  Stream<IndexingProgress> indexLibrary() async* {
    final files = await _mediaScanner.scan();
    final artistsBySourceId = <String, Artist>{};
    final albumsBySourceId = <String, Album>{};

    var processed = 0;
    for (final file in files) {
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
      await _dataSource.upsertAlbum(album);

      artist = artist.copyWith(
        trackCount: artist.trackCount + 1,
        albumCount: artist.albumCount + (albumResolution.isNew ? 1 : 0),
      );
      artistsBySourceId[artist.sourceId] = artist;
      await _dataSource.upsertArtist(artist);

      final track = Track(
        id: _idGenerator.generate(),
        sourceId: file.mediaStoreId.toString(),
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
      yield IndexingProgress(processed: processed, total: files.length);
    }
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
      cache[sourceId] = existing;
      return existing;
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
      cache[sourceId] = existing;
      return _AlbumResolution(existing, isNew: false);
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
