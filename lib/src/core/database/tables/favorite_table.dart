import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/tables/track_table.dart';

/// Favorited tracks.
@DataClassName('FavoriteRow')
class FavoriteTable extends Table {
  /// Primary key (UUID v7).
  TextColumn get id => text()();

  /// The favorited track.
  TextColumn get trackId =>
      text().references(TrackTable, #id, onDelete: KeyAction.cascade)();

  /// When the track was favorited.
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {trackId},
  ];
}
