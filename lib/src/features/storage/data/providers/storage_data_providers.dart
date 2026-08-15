import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/core/services/media_scanner/media_scanner_providers.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/storage/data/repositories/excluded_folder_repository_impl.dart';
import 'package:music_app/src/features/storage/domain/delete_track_file.dart';
import 'package:music_app/src/features/storage/domain/repositories/excluded_folder_repository.dart';

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
