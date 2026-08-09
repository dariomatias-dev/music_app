import 'package:drift/drift.dart';

/// User-created playlists.
@DataClassName('PlaylistRow')
class PlaylistTable extends Table {
  /// Primary key (UUID v7).
  TextColumn get id => text()();

  /// Playlist name.
  TextColumn get name => text()();

  /// Whether this is the built-in favorites playlist.
  BoolColumn get isFavoritesPlaylist =>
      boolean().withDefault(const Constant(false))();

  /// When the playlist was created.
  DateTimeColumn get createdAt => dateTime()();

  /// When the playlist was last updated.
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
