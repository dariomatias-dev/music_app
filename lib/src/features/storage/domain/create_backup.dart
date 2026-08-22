import 'package:music_app/src/core/constants/preference_keys.dart';
import 'package:music_app/src/core/storage/key_value_storage.dart';
import 'package:music_app/src/features/library/domain/repositories/favorite_repository.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/playlist/domain/repositories/playlist_repository.dart';
import 'package:music_app/src/features/search/domain/repositories/search_history_repository.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_playlist.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_settings.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_snapshot.dart';
import 'package:music_app/src/features/storage/domain/repositories/excluded_folder_repository.dart';

/// The [BackupSnapshot] format version this build writes.
const backupFormatVersion = 1;

/// Builds a portable [BackupSnapshot] of every user-created piece of data,
/// so it can be restored after a reinstall or on a different device.
class CreateBackup {
  /// Creates a [CreateBackup].
  const CreateBackup({
    required PlaylistRepository playlistRepository,
    required FavoriteRepository favoriteRepository,
    required SearchHistoryRepository searchHistoryRepository,
    required ExcludedFolderRepository excludedFolderRepository,
    required LibraryRepository libraryRepository,
    required KeyValueStorage keyValueStorage,
  }) : _playlistRepository = playlistRepository,
       _favoriteRepository = favoriteRepository,
       _searchHistoryRepository = searchHistoryRepository,
       _excludedFolderRepository = excludedFolderRepository,
       _libraryRepository = libraryRepository,
       _keyValueStorage = keyValueStorage;

  final PlaylistRepository _playlistRepository;
  final FavoriteRepository _favoriteRepository;
  final SearchHistoryRepository _searchHistoryRepository;
  final ExcludedFolderRepository _excludedFolderRepository;
  final LibraryRepository _libraryRepository;
  final KeyValueStorage _keyValueStorage;

  /// Builds the snapshot.
  Future<BackupSnapshot> call() async {
    final tracks = await _libraryRepository.watchTracks().first;
    final sourceIdByTrackId = {
      for (final track in tracks) track.id: track.sourceId,
    };

    final playlists = await _playlistRepository.watchPlaylists().first;
    final backupPlaylists = <BackupPlaylist>[];
    for (final playlist in playlists) {
      final trackIds = await _playlistRepository
          .watchPlaylistTrackIds(playlist.id)
          .first;
      backupPlaylists.add(
        BackupPlaylist(
          name: playlist.name,
          description: playlist.description,
          isFavorite: playlist.isFavorite,
          trackSourceIds: [
            for (final trackId in trackIds) ?sourceIdByTrackId[trackId],
          ],
        ),
      );
    }

    final favoriteTrackIds = await _favoriteRepository
        .watchFavoriteTrackIds()
        .first;
    final favoriteSourceIds = [
      for (final trackId in favoriteTrackIds) ?sourceIdByTrackId[trackId],
    ];

    final excludedFolders = await _excludedFolderRepository
        .watchExcludedFolders()
        .first;
    final searchHistoryTerms = await _searchHistoryRepository
        .watchRecentTerms(limit: 200)
        .first;

    final storage = _keyValueStorage;
    final settings = BackupSettings(
      locale: await storage.getString(PreferenceKeys.locale),
      themeMode: await storage.getString(PreferenceKeys.themeMode),
      userDisplayName: await storage.getString(
        PreferenceKeys.userDisplayName,
      ),
      gaplessEnabled:
          await storage.getBool(PreferenceKeys.gaplessEnabled) ?? true,
      crossfadeDurationSeconds:
          await storage.getInt(PreferenceKeys.crossfadeDurationSeconds) ?? 0,
      defaultPlaybackSpeed:
          await storage.getDouble(PreferenceKeys.defaultPlaybackSpeed) ?? 1.0,
      hapticsEnabled:
          await storage.getBool(PreferenceKeys.hapticsEnabled) ?? true,
    );

    return BackupSnapshot(
      formatVersion: backupFormatVersion,
      createdAt: DateTime.now(),
      playlists: backupPlaylists,
      favoriteTrackSourceIds: favoriteSourceIds,
      excludedFolders: excludedFolders,
      searchHistoryTerms: searchHistoryTerms,
      settings: settings,
    );
  }
}
