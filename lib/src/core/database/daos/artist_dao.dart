import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/tables/artist_table.dart';

part 'artist_dao.g.dart';

/// Data access for [ArtistTable].
@DriftAccessor(tables: [ArtistTable])
class ArtistDao extends DatabaseAccessor<AppDatabase> with _$ArtistDaoMixin {
  /// Creates an [ArtistDao] bound to [attachedDatabase].
  ArtistDao(super.attachedDatabase);

  /// Watches all artists.
  Stream<List<ArtistRow>> watchAll() => select(artistTable).watch();

  /// Reads a single artist by its [sourceId].
  Future<ArtistRow?> getBySourceId(String sourceId) => (select(
    artistTable,
  )..where((t) => t.sourceId.equals(sourceId))).getSingleOrNull();

  /// Every artist, keyed by `sourceId`.
  ///
  /// A scan resolves one artist per distinct name it meets, and asking the
  /// database each time is a query per artist in the library. This reads
  /// the table once instead.
  Future<Map<String, ArtistRow>> getAllBySourceId() async {
    final rows = await select(artistTable).get();
    return {for (final row in rows) row.sourceId: row};
  }

  /// Inserts or updates [entry].
  Future<void> upsertOne(Insertable<ArtistRow> entry) =>
      into(artistTable).insertOnConflictUpdate(entry);
}
