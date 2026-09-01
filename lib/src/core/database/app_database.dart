import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:music_app/src/core/database/daos/album_dao.dart';
import 'package:music_app/src/core/database/daos/artist_dao.dart';
import 'package:music_app/src/core/database/daos/excluded_folder_dao.dart';
import 'package:music_app/src/core/database/daos/favorite_dao.dart';
import 'package:music_app/src/core/database/daos/lyrics_dao.dart';
import 'package:music_app/src/core/database/daos/play_event_dao.dart';
import 'package:music_app/src/core/database/daos/playlist_dao.dart';
import 'package:music_app/src/core/database/daos/playlist_track_dao.dart';
import 'package:music_app/src/core/database/daos/search_history_dao.dart';
import 'package:music_app/src/core/database/daos/track_dao.dart';
import 'package:music_app/src/core/database/tables/album_table.dart';
import 'package:music_app/src/core/database/tables/artist_table.dart';
import 'package:music_app/src/core/database/tables/excluded_folder_table.dart';
import 'package:music_app/src/core/database/tables/favorite_table.dart';
import 'package:music_app/src/core/database/tables/lyrics_table.dart';
import 'package:music_app/src/core/database/tables/play_event_table.dart';
import 'package:music_app/src/core/database/tables/playlist_table.dart';
import 'package:music_app/src/core/database/tables/playlist_track_table.dart';
import 'package:music_app/src/core/database/tables/search_history_table.dart';
import 'package:music_app/src/core/database/tables/track_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// The database file's name inside the app's documents directory.
const appDatabaseFileName = 'music_app.sqlite';

/// The local database storing the library index, playlists, favorites and
/// playback history.
@DriftDatabase(
  tables: [
    ArtistTable,
    AlbumTable,
    TrackTable,
    PlaylistTable,
    PlaylistTrackTable,
    FavoriteTable,
    PlayEventTable,
    LyricsTable,
    SearchHistoryTable,
    ExcludedFolderTable,
  ],
  daos: [
    ArtistDao,
    AlbumDao,
    TrackDao,
    PlaylistDao,
    PlaylistTrackDao,
    FavoriteDao,
    PlayEventDao,
    LyricsDao,
    SearchHistoryDao,
    ExcludedFolderDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Creates the database using [connection], or opens the default file
  /// location when omitted.
  AppDatabase([QueryExecutor? connection])
    : super(connection ?? _openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(playlistTable, playlistTable.description);
        await m.addColumn(playlistTable, playlistTable.isFavorite);
      }
      if (from < 3) {
        for (final index in [
          trackSourceId,
          albumSourceId,
          artistSourceId,
          playEventStartedAt,
          playlistTrackPlaylist,
          playlistTrackTrack,
        ]) {
          await m.createIndex(index);
        }
      }
      if (from < 4) {
        // Foreign keys were declared but never enforced, so deleting a
        // track or a playlist left the rows pointing at it behind. Those
        // rows are dropped before the tables below are recreated with the
        // cascade they should always have had: turning enforcement on over
        // rows that already violate it would leave the database failing
        // its own integrity check with no way back.
        Future<void> dropOrphans(String table, String column, String parent) {
          return m.database.customStatement(
            'DELETE FROM $table WHERE $column NOT IN (SELECT id FROM $parent)',
          );
        }

        await dropOrphans('favorite_table', 'track_id', 'track_table');
        await dropOrphans('lyrics_table', 'track_id', 'track_table');
        await dropOrphans('play_event_table', 'track_id', 'track_table');
        await dropOrphans('playlist_track_table', 'track_id', 'track_table');
        await dropOrphans(
          'playlist_track_table',
          'playlist_id',
          'playlist_table',
        );

        // A foreign key clause lives in the table's own DDL, so picking up
        // the cascade means recreating each table and copying its rows
        // across.
        for (final table in <TableInfo<Table, dynamic>>[
          favoriteTable,
          lyricsTable,
          playEventTable,
          playlistTrackTable,
        ]) {
          // Recreating a table to change its foreign keys is what drift
          // offers for this, experimental marker and all; the alternative
          // is hand-writing the same create/copy/drop/rename by hand.
          // ignore: experimental_member_use
          await m.alterTable(TableMigration(table));
        }
      }
    },
    // Runs after any migration above, which is what lets those recreate
    // tables freely: SQLite applies foreign keys per connection, and
    // leaves them off unless asked.
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final directory = await getApplicationDocumentsDirectory();
      final file = p.join(directory.path, appDatabaseFileName);
      return NativeDatabase.createInBackground(File(file));
    });
  }
}
