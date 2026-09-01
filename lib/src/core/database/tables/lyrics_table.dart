import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/tables/track_table.dart';

/// Cached lyrics for a track, resolved from an embedded tag, a sidecar
/// `.lrc` file, or found to have none.
@DataClassName('LyricsRow')
class LyricsTable extends Table {
  /// Primary key (UUID v7).
  TextColumn get id => text()();

  /// The track this entry belongs to.
  TextColumn get trackId =>
      text().references(TrackTable, #id, onDelete: KeyAction.cascade)();

  /// Raw lyrics text, `null` when [source] is `none`.
  TextColumn get content => text().nullable()();

  /// Where [content] came from: `embedded`, `file` or `none`.
  TextColumn get source => text()();

  /// When this entry was resolved.
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {trackId},
  ];
}
