import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/services/artwork_cache/artwork_cache.dart';
import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:music_app/src/core/services/media_scanner/media_scanner.dart';
import 'package:music_app/src/core/services/metadata_reader/metadata_reader.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/reconcile_library.dart';

class _FakeMediaScanner implements MediaScanner {
  _FakeMediaScanner(this.files);

  List<ScannedAudioFile> files;
  List<String>? lastExcludedFolders;

  @override
  Future<List<ScannedAudioFile>> scan({
    List<String> includedFolders = const [],
    List<String> excludedFolders = const [],
    Duration minimumDuration = Duration.zero,
  }) async {
    lastExcludedFolders = excludedFolders;
    return files;
  }

  @override
  Future<void> notifyFileRemoved(String path) async {}
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

class _FakeLibraryLocalDataSource implements LibraryLocalDataSource {
  var _transactionDepth = 0;

  /// Writes that happened with no transaction open.
  final List<String> writesOutsideTransaction = [];

  @override
  Future<T> runInTransaction<T>(Future<T> Function() action) async {
    _transactionDepth++;
    try {
      return await action();
    } finally {
      _transactionDepth--;
    }
  }

  final Map<String, Artist> artists = {};
  final Map<String, Album> albums = {};
  final Map<String, Track> tracks = {};

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
  Future<Map<String, String>> findTrackIdsBySourceId() async => {
    for (final track in tracks.values) track.sourceId: track.id,
  };

  @override
  Future<Track?> findTrackById(String id) async => tracks[id];

  @override
  Future<List<Track>> findAllTracks() async => tracks.values.toList();

  @override
  Future<void> upsertTrack(Track track) async {
    if (_transactionDepth == 0) {
      writesOutsideTransaction.add('upsert:${track.id}');
    }
    tracks[track.id] = track;
  }

  @override
  Future<void> deleteTrack(String id) async {
    if (_transactionDepth == 0) {
      writesOutsideTransaction.add('delete:$id');
    }
    tracks.remove(id);
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

class _FakeIdGenerator implements IdGenerator {
  var _counter = 0;

  @override
  String generate() => 'id-${_counter++}';
}

ScannedAudioFile _file(int mediaStoreId, String path) {
  return ScannedAudioFile(
    mediaStoreId: mediaStoreId,
    filePath: path,
    title: 'Track $mediaStoreId',
    duration: const Duration(minutes: 3),
    fileExtension: 'mp3',
    fileSize: 1000,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
    artist: 'Charcoal',
    album: 'Chill Vibes',
  );
}

void main() {
  test('marks a track missing when a re-scan no longer finds it', () async {
    final scanner = _FakeMediaScanner([
      _file(1, '/music/a.mp3'),
      _file(2, '/music/b.mp3'),
    ]);
    final dataSource = _FakeLibraryLocalDataSource();
    final indexer = LibraryIndexer(
      mediaScanner: scanner,
      metadataReader: _FakeMetadataReader(),
      artworkCache: _FakeArtworkCache(),
      dataSource: dataSource,
      idGenerator: _FakeIdGenerator(),
    );
    final reconcile = ReconcileLibrary(
      indexer: indexer,
      dataSource: dataSource,
    );

    await reconcile().toList();
    expect(dataSource.tracks.values.every((t) => !t.isMissing), isTrue);

    scanner.files = [_file(1, '/music/a.mp3')];
    await reconcile().toList();

    final trackTwo = dataSource.tracks.values.firstWhere(
      (t) => t.sourceId == '2',
    );
    expect(trackTwo.isMissing, isTrue);
    final trackOne = dataSource.tracks.values.firstWhere(
      (t) => t.sourceId == '1',
    );
    expect(trackOne.isMissing, isFalse);
  });

  test('un-marks a track that reappears in a later scan', () async {
    final scanner = _FakeMediaScanner([_file(1, '/music/a.mp3')]);
    final dataSource = _FakeLibraryLocalDataSource();
    final indexer = LibraryIndexer(
      mediaScanner: scanner,
      metadataReader: _FakeMetadataReader(),
      artworkCache: _FakeArtworkCache(),
      dataSource: dataSource,
      idGenerator: _FakeIdGenerator(),
    );
    final reconcile = ReconcileLibrary(
      indexer: indexer,
      dataSource: dataSource,
    );

    await reconcile().toList();
    scanner.files = [];
    await reconcile().toList();
    expect(dataSource.tracks.values.single.isMissing, isTrue);

    scanner.files = [_file(1, '/music/a.mp3')];
    await reconcile().toList();

    expect(dataSource.tracks.values.single.isMissing, isFalse);
  });

  test('keeps the same track id across re-scans', () async {
    final scanner = _FakeMediaScanner([_file(1, '/music/a.mp3')]);
    final dataSource = _FakeLibraryLocalDataSource();
    final indexer = LibraryIndexer(
      mediaScanner: scanner,
      metadataReader: _FakeMetadataReader(),
      artworkCache: _FakeArtworkCache(),
      dataSource: dataSource,
      idGenerator: _FakeIdGenerator(),
    );
    final reconcile = ReconcileLibrary(
      indexer: indexer,
      dataSource: dataSource,
    );

    await reconcile().toList();
    final firstId = dataSource.tracks.values.single.id;

    await reconcile().toList();
    final secondId = dataSource.tracks.values.single.id;

    expect(secondId, firstId);
    expect(dataSource.tracks, hasLength(1));
  });

  test('purgeMissingTracks deletes only missing tracks', () async {
    final scanner = _FakeMediaScanner([
      _file(1, '/music/a.mp3'),
      _file(2, '/music/b.mp3'),
    ]);
    final dataSource = _FakeLibraryLocalDataSource();
    final indexer = LibraryIndexer(
      mediaScanner: scanner,
      metadataReader: _FakeMetadataReader(),
      artworkCache: _FakeArtworkCache(),
      dataSource: dataSource,
      idGenerator: _FakeIdGenerator(),
    );
    final reconcile = ReconcileLibrary(
      indexer: indexer,
      dataSource: dataSource,
    );

    await reconcile().toList();
    scanner.files = [_file(1, '/music/a.mp3')];
    await reconcile().toList();

    await reconcile.purgeMissingTracks();

    expect(dataSource.tracks.values.single.sourceId, '1');
  });

  test('passes excludedFolders through to the scanner', () async {
    final scanner = _FakeMediaScanner([_file(1, '/music/a.mp3')]);
    final dataSource = _FakeLibraryLocalDataSource();
    final indexer = LibraryIndexer(
      mediaScanner: scanner,
      metadataReader: _FakeMetadataReader(),
      artworkCache: _FakeArtworkCache(),
      dataSource: dataSource,
      idGenerator: _FakeIdGenerator(),
    );
    final reconcile = ReconcileLibrary(
      indexer: indexer,
      dataSource: dataSource,
    );

    await reconcile(excludedFolders: ['/music/skip']).toList();

    expect(scanner.lastExcludedFolders, ['/music/skip']);
  });

  test('marks tracks missing and purges them inside a transaction', () async {
    final scanner = _FakeMediaScanner([
      _file(1, '/music/a.mp3'),
      _file(2, '/music/b.mp3'),
    ]);
    final dataSource = _FakeLibraryLocalDataSource();
    ReconcileLibrary buildReconcile() => ReconcileLibrary(
      indexer: LibraryIndexer(
        mediaScanner: scanner,
        metadataReader: _FakeMetadataReader(),
        artworkCache: _FakeArtworkCache(),
        dataSource: dataSource,
        idGenerator: _FakeIdGenerator(),
      ),
      dataSource: dataSource,
    );

    await buildReconcile()().toList();
    scanner.files = [];
    dataSource.writesOutsideTransaction.clear();

    await buildReconcile()().toList();

    expect(
      dataSource.tracks.values.every((t) => t.isMissing),
      isTrue,
      reason: 'a track no longer scanned should be marked missing',
    );
    expect(
      dataSource.writesOutsideTransaction,
      isEmpty,
      reason: 'marking tracks missing should not commit one row at a time',
    );

    dataSource.writesOutsideTransaction.clear();
    await buildReconcile().purgeMissingTracks();

    expect(dataSource.tracks, isEmpty);
    expect(
      dataSource.writesOutsideTransaction,
      isEmpty,
      reason: 'purging should not commit one row at a time',
    );
  });
}
