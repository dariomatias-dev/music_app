// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_dao.dart';

// ignore_for_file: type=lint
mixin _$PlaylistDaoMixin on DatabaseAccessor<AppDatabase> {
  $PlaylistTableTable get playlistTable => attachedDatabase.playlistTable;
  PlaylistDaoManager get managers => PlaylistDaoManager(this);
}

class PlaylistDaoManager {
  final _$PlaylistDaoMixin _db;
  PlaylistDaoManager(this._db);
  $$PlaylistTableTableTableManager get playlistTable =>
      $$PlaylistTableTableTableManager(_db.attachedDatabase, _db.playlistTable);
}
