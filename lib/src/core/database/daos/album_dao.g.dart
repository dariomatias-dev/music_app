// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_dao.dart';

// ignore_for_file: type=lint
mixin _$AlbumDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArtistTableTable get artistTable => attachedDatabase.artistTable;
  $AlbumTableTable get albumTable => attachedDatabase.albumTable;
  AlbumDaoManager get managers => AlbumDaoManager(this);
}

class AlbumDaoManager {
  final _$AlbumDaoMixin _db;
  AlbumDaoManager(this._db);
  $$ArtistTableTableTableManager get artistTable =>
      $$ArtistTableTableTableManager(_db.attachedDatabase, _db.artistTable);
  $$AlbumTableTableTableManager get albumTable =>
      $$AlbumTableTableTableManager(_db.attachedDatabase, _db.albumTable);
}
