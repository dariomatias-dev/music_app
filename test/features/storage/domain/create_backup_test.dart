import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/constants/preference_keys.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/storage/domain/create_backup.dart';

import '../../../helpers/fake_excluded_folder_repository.dart';
import '../../../helpers/fake_favorite_repository.dart';
import '../../../helpers/fake_key_value_storage.dart';
import '../../../helpers/fake_library_repository.dart';
import '../../../helpers/fake_play_history_repository.dart';
import '../../../helpers/fake_playlist_repository.dart';
import '../../../helpers/fake_search_history_repository.dart';

Track _track(String id, String sourceId) {
  final now = DateTime(2026);
  return Track(
    id: id,
    sourceId: sourceId,
    filePath: '/music/$id.mp3',
    title: 'Track $id',
    artistId: 'artist-1',
    albumId: 'album-1',
    duration: const Duration(minutes: 3),
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    dateAdded: now,
    dateModified: now,
  );
}

void main() {
  late FakePlaylistRepository playlistRepository;
  late FakeFavoriteRepository favoriteRepository;
  late FakePlayHistoryRepository playHistoryRepository;
  late FakeSearchHistoryRepository searchHistoryRepository;
  late FakeExcludedFolderRepository excludedFolderRepository;
  late FakeKeyValueStorage keyValueStorage;
  late CreateBackup createBackup;

  setUp(() {
    playlistRepository = FakePlaylistRepository();
    favoriteRepository = FakeFavoriteRepository();
    playHistoryRepository = FakePlayHistoryRepository();
    searchHistoryRepository = FakeSearchHistoryRepository();
    excludedFolderRepository = FakeExcludedFolderRepository();
    keyValueStorage = FakeKeyValueStorage();
    createBackup = CreateBackup(
      playlistRepository: playlistRepository,
      favoriteRepository: favoriteRepository,
      playHistoryRepository: playHistoryRepository,
      searchHistoryRepository: searchHistoryRepository,
      excludedFolderRepository: excludedFolderRepository,
      libraryRepository: FakeLibraryRepository([
        _track('track-1', 'source-1'),
        _track('track-2', 'source-2'),
      ]),
      keyValueStorage: keyValueStorage,
    );
  });

  test('resolves playlist tracks to their stable source id', () async {
    final playlistId = await playlistRepository.createPlaylist('Road trip');
    await playlistRepository.setPlaylistTracks(playlistId, [
      'track-1',
      'track-2',
    ]);

    final snapshot = await createBackup();

    expect(snapshot.playlists, hasLength(1));
    expect(snapshot.playlists.single.name, 'Road trip');
    expect(snapshot.playlists.single.trackSourceIds, [
      'source-1',
      'source-2',
    ]);
  });

  test('drops a playlist track no longer in the library', () async {
    final playlistId = await playlistRepository.createPlaylist('Road trip');
    await playlistRepository.setPlaylistTracks(playlistId, [
      'track-1',
      'deleted-track',
    ]);

    final snapshot = await createBackup();

    expect(snapshot.playlists.single.trackSourceIds, ['source-1']);
  });

  test('resolves favorites to their stable source id', () async {
    await favoriteRepository.setFavorite('track-2', isFavorite: true);

    final snapshot = await createBackup();

    expect(snapshot.favoriteTrackSourceIds, ['source-2']);
  });

  test('resolves play history to stable source ids', () async {
    await playHistoryRepository.recordPlay(
      trackId: 'track-2',
      startedAt: DateTime(2026),
      playedDuration: const Duration(minutes: 2),
      completed: true,
    );

    final snapshot = await createBackup();

    expect(snapshot.playHistory, hasLength(1));
    expect(snapshot.playHistory.single.trackSourceId, 'source-2');
    expect(snapshot.playHistory.single.playedDurationMs, 120000);
    expect(snapshot.playHistory.single.completed, isTrue);
  });

  test('drops a history entry for a track no longer in the library', () async {
    await playHistoryRepository.recordPlay(
      trackId: 'deleted-track',
      startedAt: DateTime(2026),
      playedDuration: const Duration(minutes: 2),
      completed: true,
    );

    final snapshot = await createBackup();

    expect(snapshot.playHistory, isEmpty);
  });

  test('captures excluded folders and search history as-is', () async {
    await excludedFolderRepository.exclude('/music/skip');
    await searchHistoryRepository.record('daft punk');

    final snapshot = await createBackup();

    expect(snapshot.excludedFolders, ['/music/skip']);
    expect(snapshot.searchHistoryTerms, ['daft punk']);
  });

  test('captures preferences, defaulting the ones never set', () async {
    await keyValueStorage.setString(PreferenceKeys.locale, 'pt_BR');

    final snapshot = await createBackup();

    expect(snapshot.settings.locale, 'pt_BR');
    expect(snapshot.settings.gaplessEnabled, isTrue);
    expect(snapshot.settings.defaultPlaybackSpeed, 1.0);
  });
}
