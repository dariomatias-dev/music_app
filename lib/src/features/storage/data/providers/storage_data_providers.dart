import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/core/services/media_scanner/media_scanner_providers.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/history/data/providers/history_data_providers.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/search/data/providers/search_data_providers.dart';
import 'package:music_app/src/features/storage/data/repositories/excluded_folder_repository_impl.dart';
import 'package:music_app/src/features/storage/domain/create_backup.dart';
import 'package:music_app/src/features/storage/domain/delete_track_file.dart';
import 'package:music_app/src/features/storage/domain/repositories/excluded_folder_repository.dart';
import 'package:music_app/src/features/storage/domain/restore_backup.dart';

/// Provides the [ExcludedFolderRepository] used across the app.
final excludedFolderRepositoryProvider = Provider<ExcludedFolderRepository>(
  (ref) => ExcludedFolderRepositoryImpl(ref.watch(appDatabaseProvider)),
);

/// Provides the [DeleteTrackFile] use case.
final deleteTrackFileProvider = Provider<DeleteTrackFile>(
  (ref) => DeleteTrackFile(
    dataSource: ref.watch(libraryLocalDataSourceProvider),
    mediaScanner: ref.watch(mediaScannerProvider),
    playlistRepository: ref.watch(playlistRepositoryProvider),
    favoriteRepository: ref.watch(favoriteRepositoryProvider),
  ),
);

/// Provides the [CreateBackup] use case.
final createBackupProvider = Provider<CreateBackup>(
  (ref) => CreateBackup(
    playlistRepository: ref.watch(playlistRepositoryProvider),
    favoriteRepository: ref.watch(favoriteRepositoryProvider),
    playHistoryRepository: ref.watch(playHistoryRepositoryProvider),
    searchHistoryRepository: ref.watch(searchHistoryRepositoryProvider),
    excludedFolderRepository: ref.watch(excludedFolderRepositoryProvider),
    libraryRepository: ref.watch(libraryRepositoryProvider),
    keyValueStorage: ref.watch(keyValueStorageProvider),
  ),
);

/// Provides the [RestoreBackup] use case.
final restoreBackupProvider = Provider<RestoreBackup>(
  (ref) => RestoreBackup(
    playlistRepository: ref.watch(playlistRepositoryProvider),
    favoriteRepository: ref.watch(favoriteRepositoryProvider),
    playHistoryRepository: ref.watch(playHistoryRepositoryProvider),
    searchHistoryRepository: ref.watch(searchHistoryRepositoryProvider),
    excludedFolderRepository: ref.watch(excludedFolderRepositoryProvider),
    libraryRepository: ref.watch(libraryRepositoryProvider),
    keyValueStorage: ref.watch(keyValueStorageProvider),
  ),
);
