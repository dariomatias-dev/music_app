import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/tables/track_table.dart';

/// Playback history entries used for listening statistics.
// The table only ever grows, and both the statistics screen (events
// since a date) and the recently played row (newest first) read it
// through `startedAt`.
@TableIndex(name: 'play_event_started_at', columns: {#startedAt})
@DataClassName('PlayEventRow')
class PlayEventTable extends Table {
  /// Primary key (UUID v7).
  TextColumn get id => text()();

  /// The played track.
  TextColumn get trackId => text().references(TrackTable, #id)();

  /// When playback started.
  DateTimeColumn get startedAt => dateTime()();

  /// How much of the track was actually played, in milliseconds.
  IntColumn get playedDuration => integer()();

  /// Whether the track played to completion.
  BoolColumn get completed => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
