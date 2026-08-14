// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics_dao.dart';

// ignore_for_file: type=lint
mixin _$LyricsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArtistTableTable get artistTable => attachedDatabase.artistTable;
  $AlbumTableTable get albumTable => attachedDatabase.albumTable;
  $TrackTableTable get trackTable => attachedDatabase.trackTable;
  $LyricsTableTable get lyricsTable => attachedDatabase.lyricsTable;
  LyricsDaoManager get managers => LyricsDaoManager(this);
}

class LyricsDaoManager {
  final _$LyricsDaoMixin _db;
  LyricsDaoManager(this._db);
  $$ArtistTableTableTableManager get artistTable =>
      $$ArtistTableTableTableManager(_db.attachedDatabase, _db.artistTable);
  $$AlbumTableTableTableManager get albumTable =>
      $$AlbumTableTableTableManager(_db.attachedDatabase, _db.albumTable);
  $$TrackTableTableTableManager get trackTable =>
      $$TrackTableTableTableManager(_db.attachedDatabase, _db.trackTable);
  $$LyricsTableTableTableManager get lyricsTable =>
      $$LyricsTableTableTableManager(_db.attachedDatabase, _db.lyricsTable);
}
