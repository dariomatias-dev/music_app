import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/services/artwork_cache/artwork_cache.dart';
import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:music_app/src/core/services/media_scanner/media_scanner.dart';
import 'package:music_app/src/core/services/metadata_reader/metadata_reader.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/repositories/library_repository_impl.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/reconcile_library.dart';

class _FakeMediaScanner implements MediaScanner {
  @override
  Future<List<ScannedAudioFile>> scan({
    List<String> includedFolders = const [],
    List<String> excludedFolders = const [],
    Duration minimumDuration = Duration.zero,
  }) async => const [];
}

class _FakeMetadataReader implements MetadataReader {
  @override
  Future<TrackMetadata> read(String filePath) async => const TrackMetadata();
}

class _FakeArtworkCache implements ArtworkCache {
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
  Future<void> clear() async {}
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
}

void main() {
  late _FakeLibraryLocalDataSource dataSource;
  late LibraryRepositoryImpl repository;

  setUp(() {
    dataSource = _FakeLibraryLocalDataSource();
    final indexer = LibraryIndexer(
      mediaScanner: _FakeMediaScanner(),
      metadataReader: _FakeMetadataReader(),
      artworkCache: _FakeArtworkCache(),
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
}
