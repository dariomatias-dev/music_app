import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/services/artwork_cache/artwork_cache.dart';
import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:music_app/src/core/services/media_scanner/media_scanner.dart';
import 'package:music_app/src/core/services/metadata_reader/metadata_reader.dart';
import 'package:music_app/src/core/services/metadata_reader/metadata_writer.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/repositories/library_repository_impl.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/reconcile_library.dart';

import '../../../../helpers/fake_excluded_folder_repository.dart';

class _FakeMediaScanner implements MediaScanner {
  List<String>? lastExcludedFolders;

  @override
  Future<List<ScannedAudioFile>> scan({
    List<String> includedFolders = const [],
    List<String> excludedFolders = const [],
    Duration minimumDuration = Duration.zero,
  }) async {
    lastExcludedFolders = excludedFolders;
    return const [];
  }

  @override
  Future<void> notifyFileRemoved(String path) async {}
}

class _FakeMetadataReader implements MetadataReader {
  @override
  Future<TrackMetadata> read(String filePath) async => const TrackMetadata();
}

class _FakeMetadataWriter implements MetadataWriter {
  final Map<String, ({String title, String artist, String album})> written = {};

  @override
  Future<void> writeTags(
    String filePath, {
    required String title,
    required String artist,
    required String album,
  }) async {
    written[filePath] = (title: title, artist: artist, album: album);
  }
}

class _FakeArtworkCache implements ArtworkCache {
  bool cleared = false;

  @override
  Future<String> save({
    required String id,
    required Uint8List data,
    required String mimeType,
  }) async => '/cache/$id.jpg';

  @override
  Future<String?> pathFor(String id) async => null;

  @override
  Future<void> delete(String id) async {}

  @override
  Future<void> clear() async {
    cleared = true;
  }
}

class _FakeIdGenerator implements IdGenerator {
  var _counter = 0;

  @override
  String generate() => 'id-${_counter++}';
}

class _FakeLibraryLocalDataSource implements LibraryLocalDataSource {
  final Map<String, Artist> artists = {};
  final Map<String, Album> albums = {};
  final Map<String, Track> tracks = {};
  List<String> deletedTrackIds = [];

  @override
  Future<Artist?> findArtistBySourceId(String sourceId) async =>
      artists[sourceId];

  @override
  Future<void> upsertArtist(Artist artist) async {
    artists[artist.sourceId] = artist;
  }

  @override
  Future<Album?> findAlbumBySourceId(String sourceId) async => albums[sourceId];

  @override
  Future<void> upsertAlbum(Album album) async {
    albums[album.sourceId] = album;
  }

  @override
  Future<Track?> findTrackBySourceId(String sourceId) async {
    for (final track in tracks.values) {
      if (track.sourceId == sourceId) return track;
    }
    return null;
  }

  @override
  Future<Track?> findTrackById(String id) async => tracks[id];

  @override
  Future<List<Track>> findAllTracks() async => tracks.values.toList();

  @override
  Future<void> upsertTrack(Track track) async {
    tracks[track.id] = track;
  }

  @override
  Future<void> deleteTrack(String id) async {
    tracks.remove(id);
    deletedTrackIds.add(id);
  }

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks.values.toList());

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(albums.values.toList());

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(artists.values.toList());

  @override
  Future<void> clearAlbumArtworkPaths() async {
    for (final entry in albums.entries.toList()) {
      albums[entry.key] = entry.value.copyWith(artworkPath: null);
    }
  }
}

void main() {
  late _FakeLibraryLocalDataSource dataSource;
  late _FakeMediaScanner mediaScanner;
  late _FakeArtworkCache artworkCache;
  late FakeExcludedFolderRepository excludedFolderRepository;
  late _FakeMetadataWriter metadataWriter;
  late LibraryRepositoryImpl repository;

  setUp(() {
    dataSource = _FakeLibraryLocalDataSource();
    mediaScanner = _FakeMediaScanner();
    metadataWriter = _FakeMetadataWriter();
    artworkCache = _FakeArtworkCache();
    excludedFolderRepository = FakeExcludedFolderRepository();
    final indexer = LibraryIndexer(
      mediaScanner: mediaScanner,
      metadataReader: _FakeMetadataReader(),
      artworkCache: artworkCache,
      dataSource: dataSource,
      idGenerator: _FakeIdGenerator(),
    );
    final reconcile = ReconcileLibrary(
      indexer: indexer,
      dataSource: dataSource,
    );
    repository = LibraryRepositoryImpl(
      dataSource: dataSource,
      reconcileLibrary: reconcile,
      artworkCache: artworkCache,
      excludedFolderRepository: excludedFolderRepository,
      metadataWriter: metadataWriter,
    );
  });

  test('watchTracks reflects the data source', () async {
    final track = Track(
      id: 'track-1',
      sourceId: '1',
      filePath: '/music/a.mp3',
      title: 'A',
      artistId: 'artist-1',
      albumId: 'album-1',
      duration: const Duration(minutes: 3),
      format: 'mp3',
      fileSize: 1000,
      hasEmbeddedArtwork: false,
      dateAdded: DateTime(2026),
      dateModified: DateTime(2026),
    );
    dataSource.tracks['track-1'] = track;

    expect(await repository.watchTracks().first, [track]);
  });

  test('watchAlbums reflects the data source', () async {
    const album = Album(
      id: 'album-1',
      sourceId: 'charcoal::chill vibes',
      title: 'Chill Vibes',
      artistId: 'artist-1',
      trackCount: 1,
      totalDuration: Duration(minutes: 3),
    );
    dataSource.albums[album.sourceId] = album;

    expect(await repository.watchAlbums().first, [album]);
  });

  test('watchArtists reflects the data source', () async {
    const artist = Artist(
      id: 'artist-1',
      sourceId: 'charcoal',
      name: 'Charcoal',
      albumCount: 1,
      trackCount: 1,
    );
    dataSource.artists[artist.sourceId] = artist;

    expect(await repository.watchArtists().first, [artist]);
  });

  test('reindex runs without producing progress for an empty scan', () async {
    final progress = await repository.reindex().toList();
    expect(progress, isEmpty);
  });

  test(
    'reindex passes the currently excluded folders to the scanner',
    () async {
      await excludedFolderRepository.exclude('/music/skip');

      await repository.reindex().toList();

      expect(mediaScanner.lastExcludedFolders, ['/music/skip']);
    },
  );

  test('clearArtworkCache clears the cache and every stored path', () async {
    const album = Album(
      id: 'album-1',
      sourceId: 'charcoal::chill vibes',
      title: 'Chill Vibes',
      artistId: 'artist-1',
      trackCount: 1,
      totalDuration: Duration(minutes: 3),
      artworkPath: '/cache/album-1.jpg',
    );
    dataSource.albums[album.sourceId] = album;

    await repository.clearArtworkCache();

    expect(artworkCache.cleared, isTrue);
    expect(dataSource.albums[album.sourceId]?.artworkPath, isNull);
  });

  test('purgeMissingTracks delegates to the reconciliation use case', () async {
    final track = Track(
      id: 'track-1',
      sourceId: '1',
      filePath: '/music/a.mp3',
      title: 'A',
      artistId: 'artist-1',
      albumId: 'album-1',
      duration: const Duration(minutes: 3),
      format: 'mp3',
      fileSize: 1000,
      hasEmbeddedArtwork: false,
      dateAdded: DateTime(2026),
      dateModified: DateTime(2026),
      isMissing: true,
    );
    dataSource.tracks['track-1'] = track;

    await repository.purgeMissingTracks();

    expect(dataSource.deletedTrackIds, ['track-1']);
  });

  test('updateTrackTags writes the new tags to the track file', () async {
    final track = Track(
      id: 'track-1',
      sourceId: '1',
      filePath: '/music/a.mp3',
      title: 'A',
      artistId: 'artist-1',
      albumId: 'album-1',
      duration: const Duration(minutes: 3),
      format: 'mp3',
      fileSize: 1000,
      hasEmbeddedArtwork: false,
      dateAdded: DateTime(2026),
      dateModified: DateTime(2026),
    );
    dataSource.tracks['track-1'] = track;

    await repository.updateTrackTags(
      'track-1',
      title: 'New title',
      artist: 'New artist',
      album: 'New album',
    );

    expect(metadataWriter.written['/music/a.mp3'], (
      title: 'New title',
      artist: 'New artist',
      album: 'New album',
    ));
  });

  test('updateTrackTags throws for an unknown track id', () async {
    await expectLater(
      () => repository.updateTrackTags(
        'missing',
        title: 'Title',
        artist: 'Artist',
        album: 'Album',
      ),
      throwsStateError,
    );
  });
}
