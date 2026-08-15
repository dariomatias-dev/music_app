import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/tables/playlist_track_table.dart';

part 'playlist_track_dao.g.dart';

/// Data access for [PlaylistTrackTable].
@DriftAccessor(tables: [PlaylistTrackTable])
class PlaylistTrackDao extends DatabaseAccessor<AppDatabase>
    with _$PlaylistTrackDaoMixin {
  /// Creates a [PlaylistTrackDao] bound to [attachedDatabase].
  PlaylistTrackDao(super.attachedDatabase);

  /// Watches the tracks of [playlistId], ordered by position.
  Stream<List<PlaylistTrackRow>> watchForPlaylist(String playlistId) {
    final query = select(playlistTrackTable)
      ..where((t) => t.playlistId.equals(playlistId))
      ..orderBy([(t) => OrderingTerm.asc(t.position)]);
    return query.watch();
  }

  /// Replaces the tracks of [playlistId] with [entries] atomically.
  Future<void> replaceForPlaylist(
    String playlistId,
    List<Insertable<PlaylistTrackRow>> entries,
  ) {
    return transaction(() async {
      await (delete(
        playlistTrackTable,
      )..where((t) => t.playlistId.equals(playlistId))).go();
      await batch((batch) => batch.insertAll(playlistTrackTable, entries));
    });
  }

  /// Removes [trackId] from every playlist it appears in.
  Future<void> deleteTrackFromAllPlaylists(String trackId) => (delete(
    playlistTrackTable,
  )..where((t) => t.trackId.equals(trackId))).go();
}
