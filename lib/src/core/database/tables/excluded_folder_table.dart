import 'package:drift/drift.dart';

/// Folders the user has excluded from the library scan.
@DataClassName('ExcludedFolderRow')
class ExcludedFolderTable extends Table {
  /// The excluded folder's absolute path.
  TextColumn get path => text()();

  @override
  Set<Column> get primaryKey => {path};
}
