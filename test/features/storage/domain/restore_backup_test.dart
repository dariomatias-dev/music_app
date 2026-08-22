import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/constants/preference_keys.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/storage/domain/create_backup.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_playlist.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_settings.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_snapshot.dart';
import 'package:music_app/src/features/storage/domain/restore_backup.dart';

import '../../../helpers/fake_excluded_folder_repository.dart';
import '../../../helpers/fake_favorite_repository.dart';
import '../../../helpers/fake_key_value_storage.dart';
import '../../../helpers/fake_library_repository.dart';
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

BackupSettings _settings({
  bool gaplessEnabled = true,
  int crossfadeDurationSeconds = 0,
  double defaultPlaybackSpeed = 1,
  bool hapticsEnabled = true,
  String? locale,
  String? themeMode,
  String? userDisplayName,
}) => BackupSettings(
  gaplessEnabled: gaplessEnabled,
  crossfadeDurationSeconds: crossfadeDurationSeconds,
  defaultPlaybackSpeed: defaultPlaybackSpeed,
  hapticsEnabled: hapticsEnabled,
  locale: locale,
  themeMode: themeMode,
  userDisplayName: userDisplayName,
);

BackupSnapshot _snapshot({
  List<BackupPlaylist> playlists = const [],
  List<String> favoriteTrackSourceIds = const [],
  List<String> excludedFolders = const [],
  List<String> searchHistoryTerms = const [],
  BackupSettings? settings,
}) => BackupSnapshot(
  formatVersion: backupFormatVersion,
  createdAt: DateTime(2026),
  playlists: playlists,
  favoriteTrackSourceIds: favoriteTrackSourceIds,
  excludedFolders: excludedFolders,
  searchHistoryTerms: searchHistoryTerms,
  settings: settings ?? _settings(),
);

void main() {
  late FakePlaylistRepository playlistRepository;
  late FakeFavoriteRepository favoriteRepository;
  late FakeSearchHistoryRepository searchHistoryRepository;
  late FakeExcludedFolderRepository excludedFolderRepository;
  late FakeKeyValueStorage keyValueStorage;
  late RestoreBackup restoreBackup;

  setUp(() {
    playlistRepository = FakePlaylistRepository();
    favoriteRepository = FakeFavoriteRepository();
    searchHistoryRepository = FakeSearchHistoryRepository();
    excludedFolderRepository = FakeExcludedFolderRepository();
    keyValueStorage = FakeKeyValueStorage();
    restoreBackup = RestoreBackup(
      playlistRepository: playlistRepository,
      favoriteRepository: favoriteRepository,
      searchHistoryRepository: searchHistoryRepository,
      excludedFolderRepository: excludedFolderRepository,
      libraryRepository: FakeLibraryRepository([
        _track('track-1', 'source-1'),
        _track('track-2', 'source-2'),
      ]),
      keyValueStorage: keyValueStorage,
    );
  });

  test(
    'recreates a playlist, resolving source ids to current track ids',
    () async {
      final result = await restoreBackup(
        _snapshot(
          playlists: [
            const BackupPlaylist(
              name: 'Road trip',
              description: 'For the drive',
              isFavorite: true,
              trackSourceIds: ['source-2', 'source-1'],
            ),
          ],
        ),
      );

      expect(result.restoredPlaylists, 1);
      expect(result.skippedTracks, 0);
      final playlists = await playlistRepository.watchPlaylists().first;
      expect(playlists.single.name, 'Road trip');
      expect(playlists.single.description, 'For the drive');
      expect(playlists.single.isFavorite, isTrue);
      final trackIds = await playlistRepository
          .watchPlaylistTrackIds(playlists.single.id)
          .first;
      expect(trackIds, ['track-2', 'track-1']);
    },
  );

  test('skips a track whose source id is not in the current library', () async {
    final result = await restoreBackup(
      _snapshot(
        playlists: [
          const BackupPlaylist(
            name: 'Road trip',
            isFavorite: false,
            trackSourceIds: ['source-1', 'source-missing'],
          ),
        ],
      ),
    );

    expect(result.skippedTracks, 1);
    final playlists = await playlistRepository.watchPlaylists().first;
    final trackIds = await playlistRepository
        .watchPlaylistTrackIds(playlists.single.id)
        .first;
    expect(trackIds, ['track-1']);
  });

  test('restores favorites resolved to current track ids', () async {
    final result = await restoreBackup(
      _snapshot(favoriteTrackSourceIds: const ['source-2']),
    );

    expect(result.restoredFavorites, 1);
    final favoriteIds = await favoriteRepository.watchFavoriteTrackIds().first;
    expect(favoriteIds, ['track-2']);
  });

  test('restores excluded folders and search history in order', () async {
    await restoreBackup(
      _snapshot(
        excludedFolders: const ['/music/skip'],
        searchHistoryTerms: const ['daft punk', 'boards of canada'],
      ),
    );

    final excluded = await excludedFolderRepository
        .watchExcludedFolders()
        .first;
    expect(excluded, ['/music/skip']);
    final terms = await searchHistoryRepository.watchRecentTerms().first;
    expect(terms, ['daft punk', 'boards of canada']);
  });

  test('restores preferences', () async {
    await restoreBackup(
      _snapshot(
        settings: _settings(
          locale: 'es',
          gaplessEnabled: false,
          defaultPlaybackSpeed: 1.25,
        ),
      ),
    );

    expect(await keyValueStorage.getString(PreferenceKeys.locale), 'es');
    expect(
      await keyValueStorage.getBool(PreferenceKeys.gaplessEnabled),
      isFalse,
    );
    expect(
      await keyValueStorage.getDouble(PreferenceKeys.defaultPlaybackSpeed),
      1.25,
    );
  });
}
