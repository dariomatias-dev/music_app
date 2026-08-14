import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/tables/lyrics_table.dart';

part 'lyrics_dao.g.dart';

/// Data access for [LyricsTable].
@DriftAccessor(tables: [LyricsTable])
class LyricsDao extends DatabaseAccessor<AppDatabase> with _$LyricsDaoMixin {
  /// Creates a [LyricsDao] bound to [attachedDatabase].
  LyricsDao(super.attachedDatabase);

  /// Reads the lyrics entry for [trackId], if it was already resolved.
  Future<LyricsRow?> getByTrackId(String trackId) => (select(
    lyricsTable,
  )..where((t) => t.trackId.equals(trackId))).getSingleOrNull();

  /// Watches the lyrics entry for [trackId].
  Stream<LyricsRow?> watchByTrackId(String trackId) => (select(
    lyricsTable,
  )..where((t) => t.trackId.equals(trackId))).watchSingleOrNull();

  /// Inserts [entry]. Callers are expected to check [getByTrackId] first,
  /// since a track's lyrics are resolved once and cached.
  Future<void> insertOne(Insertable<LyricsRow> entry) =>
      into(lyricsTable).insert(entry);
}
