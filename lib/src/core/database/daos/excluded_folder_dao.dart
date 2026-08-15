import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/tables/excluded_folder_table.dart';

part 'excluded_folder_dao.g.dart';

/// Data access for [ExcludedFolderTable].
@DriftAccessor(tables: [ExcludedFolderTable])
class ExcludedFolderDao extends DatabaseAccessor<AppDatabase>
    with _$ExcludedFolderDaoMixin {
  /// Creates an [ExcludedFolderDao] bound to [attachedDatabase].
  ExcludedFolderDao(super.attachedDatabase);

  /// Watches every excluded folder's path.
  Stream<List<String>> watchAll() => select(
    excludedFolderTable,
  ).watch().map((rows) => rows.map((row) => row.path).toList());

  /// Excludes [path] from the library scan.
  Future<void> exclude(String path) => into(
    excludedFolderTable,
  ).insertOnConflictUpdate(ExcludedFolderTableCompanion.insert(path: path));

  /// Re-includes [path] in the library scan.
  Future<void> include(String path) => (delete(
    excludedFolderTable,
  )..where((t) => t.path.equals(path))).go();
}
