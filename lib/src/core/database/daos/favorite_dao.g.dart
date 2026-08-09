// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_dao.dart';

// ignore_for_file: type=lint
mixin _$FavoriteDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArtistTableTable get artistTable => attachedDatabase.artistTable;
  $AlbumTableTable get albumTable => attachedDatabase.albumTable;
  $TrackTableTable get trackTable => attachedDatabase.trackTable;
  $FavoriteTableTable get favoriteTable => attachedDatabase.favoriteTable;
  FavoriteDaoManager get managers => FavoriteDaoManager(this);
}

class FavoriteDaoManager {
  final _$FavoriteDaoMixin _db;
  FavoriteDaoManager(this._db);
  $$ArtistTableTableTableManager get artistTable =>
      $$ArtistTableTableTableManager(_db.attachedDatabase, _db.artistTable);
  $$AlbumTableTableTableManager get albumTable =>
      $$AlbumTableTableTableManager(_db.attachedDatabase, _db.albumTable);
  $$TrackTableTableTableManager get trackTable =>
      $$TrackTableTableTableManager(_db.attachedDatabase, _db.trackTable);
  $$FavoriteTableTableTableManager get favoriteTable =>
      $$FavoriteTableTableTableManager(_db.attachedDatabase, _db.favoriteTable);
}
