// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_event_dao.dart';

// ignore_for_file: type=lint
mixin _$PlayEventDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArtistTableTable get artistTable => attachedDatabase.artistTable;
  $AlbumTableTable get albumTable => attachedDatabase.albumTable;
  $TrackTableTable get trackTable => attachedDatabase.trackTable;
  $PlayEventTableTable get playEventTable => attachedDatabase.playEventTable;
  PlayEventDaoManager get managers => PlayEventDaoManager(this);
}

class PlayEventDaoManager {
  final _$PlayEventDaoMixin _db;
  PlayEventDaoManager(this._db);
  $$ArtistTableTableTableManager get artistTable =>
      $$ArtistTableTableTableManager(_db.attachedDatabase, _db.artistTable);
  $$AlbumTableTableTableManager get albumTable =>
      $$AlbumTableTableTableManager(_db.attachedDatabase, _db.albumTable);
  $$TrackTableTableTableManager get trackTable =>
      $$TrackTableTableTableManager(_db.attachedDatabase, _db.trackTable);
  $$PlayEventTableTableTableManager get playEventTable =>
      $$PlayEventTableTableTableManager(
        _db.attachedDatabase,
        _db.playEventTable,
      );
}
