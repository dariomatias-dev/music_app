// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excluded_folder_dao.dart';

// ignore_for_file: type=lint
mixin _$ExcludedFolderDaoMixin on DatabaseAccessor<AppDatabase> {
  $ExcludedFolderTableTable get excludedFolderTable =>
      attachedDatabase.excludedFolderTable;
  ExcludedFolderDaoManager get managers => ExcludedFolderDaoManager(this);
}

class ExcludedFolderDaoManager {
  final _$ExcludedFolderDaoMixin _db;
  ExcludedFolderDaoManager(this._db);
  $$ExcludedFolderTableTableTableManager get excludedFolderTable =>
      $$ExcludedFolderTableTableTableManager(
        _db.attachedDatabase,
        _db.excludedFolderTable,
      );
}
