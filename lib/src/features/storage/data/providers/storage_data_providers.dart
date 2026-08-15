import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/features/storage/data/repositories/excluded_folder_repository_impl.dart';
import 'package:music_app/src/features/storage/domain/repositories/excluded_folder_repository.dart';

/// Provides the [ExcludedFolderRepository] used across the app.
final excludedFolderRepositoryProvider = Provider<ExcludedFolderRepository>(
  (ref) => ExcludedFolderRepositoryImpl(ref.watch(appDatabaseProvider)),
);
