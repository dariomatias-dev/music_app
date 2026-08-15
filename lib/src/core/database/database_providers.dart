import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/database/app_database.dart';
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

/// Provides the app's [AppDatabase] instance.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

/// Provides [ArtistDao].
final artistDaoProvider = Provider<ArtistDao>(
  (ref) => ref.watch(appDatabaseProvider).artistDao,
);

/// Provides [AlbumDao].
final albumDaoProvider = Provider<AlbumDao>(
  (ref) => ref.watch(appDatabaseProvider).albumDao,
);

/// Provides [TrackDao].
final trackDaoProvider = Provider<TrackDao>(
  (ref) => ref.watch(appDatabaseProvider).trackDao,
);

/// Provides [PlaylistDao].
final playlistDaoProvider = Provider<PlaylistDao>(
  (ref) => ref.watch(appDatabaseProvider).playlistDao,
);

/// Provides [PlaylistTrackDao].
final playlistTrackDaoProvider = Provider<PlaylistTrackDao>(
  (ref) => ref.watch(appDatabaseProvider).playlistTrackDao,
);

/// Provides [FavoriteDao].
final favoriteDaoProvider = Provider<FavoriteDao>(
  (ref) => ref.watch(appDatabaseProvider).favoriteDao,
);

/// Provides [PlayEventDao].
final playEventDaoProvider = Provider<PlayEventDao>(
  (ref) => ref.watch(appDatabaseProvider).playEventDao,
);

/// Provides [LyricsDao].
final lyricsDaoProvider = Provider<LyricsDao>(
  (ref) => ref.watch(appDatabaseProvider).lyricsDao,
);

/// Provides [SearchHistoryDao].
final searchHistoryDaoProvider = Provider<SearchHistoryDao>(
  (ref) => ref.watch(appDatabaseProvider).searchHistoryDao,
);

/// Provides [ExcludedFolderDao].
final excludedFolderDaoProvider = Provider<ExcludedFolderDao>(
  (ref) => ref.watch(appDatabaseProvider).excludedFolderDao,
);
