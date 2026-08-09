import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:music_app/src/core/database/daos/album_dao.dart';
import 'package:music_app/src/core/database/daos/artist_dao.dart';
import 'package:music_app/src/core/database/daos/favorite_dao.dart';
import 'package:music_app/src/core/database/daos/play_event_dao.dart';
import 'package:music_app/src/core/database/daos/playlist_dao.dart';
import 'package:music_app/src/core/database/daos/playlist_track_dao.dart';
import 'package:music_app/src/core/database/daos/track_dao.dart';
import 'package:music_app/src/core/database/tables/album_table.dart';
import 'package:music_app/src/core/database/tables/artist_table.dart';
import 'package:music_app/src/core/database/tables/favorite_table.dart';
import 'package:music_app/src/core/database/tables/play_event_table.dart';
import 'package:music_app/src/core/database/tables/playlist_table.dart';
import 'package:music_app/src/core/database/tables/playlist_track_table.dart';
import 'package:music_app/src/core/database/tables/track_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

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
  ],
  daos: [
    ArtistDao,
    AlbumDao,
    TrackDao,
    PlaylistDao,
    PlaylistTrackDao,
    FavoriteDao,
    PlayEventDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Creates the database using [connection], or opens the default file
  /// location when omitted.
  AppDatabase([QueryExecutor? connection])
    : super(connection ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final directory = await getApplicationDocumentsDirectory();
      final file = p.join(directory.path, 'music_app.sqlite');
      return NativeDatabase.createInBackground(File(file));
    });
  }
}
