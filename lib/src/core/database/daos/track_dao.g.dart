// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_dao.dart';

// ignore_for_file: type=lint
mixin _$TrackDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArtistTableTable get artistTable => attachedDatabase.artistTable;
  $AlbumTableTable get albumTable => attachedDatabase.albumTable;
  $TrackTableTable get trackTable => attachedDatabase.trackTable;
  TrackDaoManager get managers => TrackDaoManager(this);
}

class TrackDaoManager {
  final _$TrackDaoMixin _db;
  TrackDaoManager(this._db);
  $$ArtistTableTableTableManager get artistTable =>
      $$ArtistTableTableTableManager(_db.attachedDatabase, _db.artistTable);
  $$AlbumTableTableTableManager get albumTable =>
      $$AlbumTableTableTableManager(_db.attachedDatabase, _db.albumTable);
  $$TrackTableTableTableManager get trackTable =>
      $$TrackTableTableTableManager(_db.attachedDatabase, _db.trackTable);
}
