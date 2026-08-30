import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/services/media_scanner/media_scanner.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/storage/domain/delete_track_file.dart';

import '../../../helpers/fake_favorite_repository.dart';
import '../../../helpers/fake_playlist_repository.dart';

class _FakeMediaScanner implements MediaScanner {
  final List<String> notifiedPaths = [];

  @override
  Future<List<ScannedAudioFile>> scan({
    List<String> includedFolders = const [],
    List<String> excludedFolders = const [],
    Duration minimumDuration = Duration.zero,
  }) async => const [];

  @override
  Future<void> notifyFileRemoved(String path) async {
    notifiedPaths.add(path);
  }
}

class _FakeLibraryLocalDataSource implements LibraryLocalDataSource {
  @override
  Future<T> runInTransaction<T>(Future<T> Function() action) => action();

  final List<String> deletedTrackIds = [];

  @override
  Future<void> deleteTrack(String id) async {
    deletedTrackIds.add(id);
  }

  @override
  Future<Artist?> findArtistBySourceId(String sourceId) async => null;

  @override
  Future<void> upsertArtist(Artist artist) async {}

  @override
  Future<Album?> findAlbumBySourceId(String sourceId) async => null;

  @override
  Future<void> upsertAlbum(Album album) async {}

  @override
  Future<Map<String, String>> findTrackIdsBySourceId() async => const {};

  @override
  Future<Track?> findTrackById(String id) async => null;

  @override
  Future<List<Track>> findAllTracks() async => const [];

  @override
  Future<void> upsertTrack(Track track) async {}

  @override
  Stream<List<Track>> watchTracks() => const Stream.empty();

  @override
  Stream<List<Album>> watchAlbums() => const Stream.empty();

  @override
  Stream<List<Artist>> watchArtists() => const Stream.empty();

  @override
  Future<void> clearAlbumArtworkPaths() async {}
}

Track _track(String id, {required String filePath}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: filePath,
    title: 'Track $id',
    artistId: 'artist-1',
    albumId: 'album-1',
    duration: const Duration(minutes: 3),
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
  );
}

void main() {
  late Directory tempDir;
  late _FakeMediaScanner mediaScanner;
  late _FakeLibraryLocalDataSource dataSource;
  late FakePlaylistRepository playlistRepository;
  late FakeFavoriteRepository favoriteRepository;
  late DeleteTrackFile deleteTrackFile;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('delete_track_file_test');
    mediaScanner = _FakeMediaScanner();
    dataSource = _FakeLibraryLocalDataSource();
    playlistRepository = FakePlaylistRepository();
    favoriteRepository = FakeFavoriteRepository();
    deleteTrackFile = DeleteTrackFile(
      dataSource: dataSource,
      mediaScanner: mediaScanner,
      playlistRepository: playlistRepository,
      favoriteRepository: favoriteRepository,
    );
  });

  tearDown(() => tempDir.delete(recursive: true));

  test('deletes the file, notifies the media store and the index', () async {
    final file = File('${tempDir.path}/track.mp3')..writeAsStringSync('data');
    final track = _track('track-1', filePath: file.path);

    await deleteTrackFile(track);

    expect(file.existsSync(), isFalse);
    expect(mediaScanner.notifiedPaths, [file.path]);
    expect(dataSource.deletedTrackIds, ['track-1']);
  });

  test('removes the track from every playlist and favorites', () async {
    final file = File('${tempDir.path}/track.mp3')..writeAsStringSync('data');
    final track = _track('track-1', filePath: file.path);
    final playlistId = await playlistRepository.createPlaylist('Road Trip');
    await playlistRepository.setPlaylistTracks(playlistId, [
      'track-1',
      'track-2',
    ]);
    await favoriteRepository.setFavorite('track-1', isFavorite: true);

    await deleteTrackFile(track);

    expect(
      await playlistRepository.watchPlaylistTrackIds(playlistId).first,
      ['track-2'],
    );
    expect(
      await favoriteRepository.watchIsFavorite('track-1').first,
      isFalse,
    );
  });

  test('is a no-op on disk when the file is already gone', () async {
    final track = _track(
      'track-1',
      filePath: '${tempDir.path}/already-gone.mp3',
    );

    await deleteTrackFile(track);

    expect(mediaScanner.notifiedPaths, [track.filePath]);
    expect(dataSource.deletedTrackIds, ['track-1']);
  });
}
