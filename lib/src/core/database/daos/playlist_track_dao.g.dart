// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_track_dao.dart';

// ignore_for_file: type=lint
mixin _$PlaylistTrackDaoMixin on DatabaseAccessor<AppDatabase> {
  $PlaylistTableTable get playlistTable => attachedDatabase.playlistTable;
  $ArtistTableTable get artistTable => attachedDatabase.artistTable;
  $AlbumTableTable get albumTable => attachedDatabase.albumTable;
  $TrackTableTable get trackTable => attachedDatabase.trackTable;
  $PlaylistTrackTableTable get playlistTrackTable =>
      attachedDatabase.playlistTrackTable;
  PlaylistTrackDaoManager get managers => PlaylistTrackDaoManager(this);
}

class PlaylistTrackDaoManager {
  final _$PlaylistTrackDaoMixin _db;
  PlaylistTrackDaoManager(this._db);
  $$PlaylistTableTableTableManager get playlistTable =>
      $$PlaylistTableTableTableManager(_db.attachedDatabase, _db.playlistTable);
  $$ArtistTableTableTableManager get artistTable =>
      $$ArtistTableTableTableManager(_db.attachedDatabase, _db.artistTable);
  $$AlbumTableTableTableManager get albumTable =>
      $$AlbumTableTableTableManager(_db.attachedDatabase, _db.albumTable);
  $$TrackTableTableTableManager get trackTable =>
      $$TrackTableTableTableManager(_db.attachedDatabase, _db.trackTable);
  $$PlaylistTrackTableTableTableManager get playlistTrackTable =>
      $$PlaylistTrackTableTableTableManager(
        _db.attachedDatabase,
        _db.playlistTrackTable,
      );
}
