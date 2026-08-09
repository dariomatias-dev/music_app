// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_dao.dart';

// ignore_for_file: type=lint
mixin _$ArtistDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArtistTableTable get artistTable => attachedDatabase.artistTable;
  ArtistDaoManager get managers => ArtistDaoManager(this);
}

class ArtistDaoManager {
  final _$ArtistDaoMixin _db;
  ArtistDaoManager(this._db);
  $$ArtistTableTableTableManager get artistTable =>
      $$ArtistTableTableTableManager(_db.attachedDatabase, _db.artistTable);
}
