import 'package:music_app/src/core/constants/preference_keys.dart';
import 'package:music_app/src/core/storage/key_value_storage.dart';
import 'package:music_app/src/features/library/domain/repositories/favorite_repository.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/playlist/domain/repositories/playlist_repository.dart';
import 'package:music_app/src/features/search/domain/repositories/search_history_repository.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_settings.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_snapshot.dart';
import 'package:music_app/src/features/storage/domain/repositories/excluded_folder_repository.dart';

/// How many entries a [RestoreBackup] call restored or had to skip.
typedef RestoreBackupResult = ({
  int restoredPlaylists,
  int restoredFavorites,
  int skippedTracks,
});

/// Restores a [BackupSnapshot] into the current install.
///
/// Merges into whatever is already there rather than replacing it: it
/// creates playlists, adds favorites, excluded folders and search terms,
/// and overwrites preferences, but never deletes existing data. A track
/// referenced by [BackupSnapshot.playlists] or
/// [BackupSnapshot.favoriteTrackSourceIds] that the current library
/// doesn't have (not yet re-scanned, or no longer on disk) is skipped
/// rather than failing the whole restore.
class RestoreBackup {
  /// Creates a [RestoreBackup].
  const RestoreBackup({
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

  /// Restores [snapshot].
  Future<RestoreBackupResult> call(BackupSnapshot snapshot) async {
    final tracks = await _libraryRepository.watchTracks().first;
    final trackIdBySourceId = {
      for (final track in tracks) track.sourceId: track.id,
    };

    var skippedTracks = 0;

    for (final playlist in snapshot.playlists) {
      final trackIds = <String>[];
      for (final sourceId in playlist.trackSourceIds) {
        final trackId = trackIdBySourceId[sourceId];
        if (trackId == null) {
          skippedTracks++;
        } else {
          trackIds.add(trackId);
        }
      }

      final playlistId = await _playlistRepository.createPlaylist(
        playlist.name,
      );
      final description = playlist.description;
      if (description != null) {
        await _playlistRepository.updatePlaylistDescription(
          playlistId,
          description,
        );
      }
      if (playlist.isFavorite) {
        await _playlistRepository.setPlaylistFavorite(
          playlistId,
          isFavorite: true,
        );
      }
      if (trackIds.isNotEmpty) {
        await _playlistRepository.setPlaylistTracks(playlistId, trackIds);
      }
    }

    var restoredFavorites = 0;
    for (final sourceId in snapshot.favoriteTrackSourceIds) {
      final trackId = trackIdBySourceId[sourceId];
      if (trackId == null) {
        skippedTracks++;
      } else {
        await _favoriteRepository.setFavorite(trackId, isFavorite: true);
        restoredFavorites++;
      }
    }

    for (final path in snapshot.excludedFolders) {
      await _excludedFolderRepository.exclude(path);
    }

    // record() moves a term to the front, so replaying oldest-first
    // reproduces the original most-recent-first order.
    for (final term in snapshot.searchHistoryTerms.reversed) {
      await _searchHistoryRepository.record(term);
    }

    await _restoreSettings(snapshot.settings);

    return (
      restoredPlaylists: snapshot.playlists.length,
      restoredFavorites: restoredFavorites,
      skippedTracks: skippedTracks,
    );
  }

  Future<void> _restoreSettings(BackupSettings settings) async {
    final storage = _keyValueStorage;

    final locale = settings.locale;
    if (locale != null) {
      await storage.setString(PreferenceKeys.locale, locale);
    }
    final themeMode = settings.themeMode;
    if (themeMode != null) {
      await storage.setString(PreferenceKeys.themeMode, themeMode);
    }
    final userDisplayName = settings.userDisplayName;
    if (userDisplayName != null) {
      await storage.setString(
        PreferenceKeys.userDisplayName,
        userDisplayName,
      );
    }
    await storage.setBool(
      PreferenceKeys.gaplessEnabled,
      value: settings.gaplessEnabled,
    );
    await storage.setInt(
      PreferenceKeys.crossfadeDurationSeconds,
      settings.crossfadeDurationSeconds,
    );
    await storage.setDouble(
      PreferenceKeys.defaultPlaybackSpeed,
      settings.defaultPlaybackSpeed,
    );
    await storage.setBool(
      PreferenceKeys.hapticsEnabled,
      value: settings.hapticsEnabled,
    );
  }
}
