import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/storage/domain/repositories/excluded_folder_repository.dart';

/// [ExcludedFolderRepository] implementation backed by [AppDatabase].
class ExcludedFolderRepositoryImpl implements ExcludedFolderRepository {
  /// Creates an [ExcludedFolderRepositoryImpl].
  const ExcludedFolderRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Stream<List<String>> watchExcludedFolders() =>
      _database.excludedFolderDao.watchAll();

  @override
  Future<void> exclude(String path) =>
      _database.excludedFolderDao.exclude(path);

  @override
  Future<void> include(String path) =>
      _database.excludedFolderDao.include(path);
}
