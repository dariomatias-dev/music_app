import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/seeds/seed.dart';
import 'package:music_app/src/features/history/data/seeds/play_history_seed.dart';
import 'package:music_app/src/features/library/data/seeds/favorite_seed.dart';
import 'package:music_app/src/features/library/data/seeds/library_seed.dart';
import 'package:music_app/src/features/player/data/seeds/lyrics_seed.dart';
import 'package:music_app/src/features/playlist/data/seeds/playlist_seed.dart';
import 'package:music_app/src/features/search/data/seeds/search_history_seed.dart';
import 'package:music_app/src/features/storage/data/seeds/excluded_folder_seed.dart';

/// The development seeds, in the order they have to run: a seed that
/// references another aggregate's rows comes after the seed that writes
/// them, since the schema enforces its foreign keys.
///
/// [clock] dates the data relative to the moment it is written, so
/// "recently played" and the listening streak stay in their interesting
/// range instead of drifting into the past as the months pass. A run that
/// has to be reproducible, such as a screenshot capture, pins it.
List<Seed> devSeeds(AppDatabase database, {DateTime Function()? clock}) {
  final now = clock ?? DateTime.now;
  return [
    LibrarySeed(database, clock: now),
    FavoriteSeed(database, clock: now),
    PlaylistSeed(database, clock: now),
    PlayHistorySeed(database, clock: now),
    LyricsSeed(database, clock: now),
    SearchHistorySeed(database, clock: now),
    ExcludedFolderSeed(database),
  ];
}

/// Runs every seed in [devSeeds] against [database].
///
/// Writes a populated library over whatever is there, so the app opens on
/// real-looking content with no device files and no scan. Never call it
/// against a database a user owns: `runDevSeedsIfEnabled` is the guarded
/// entry point the app itself goes through.
Future<void> runDevSeeds(
  AppDatabase database, {
  DateTime Function()? clock,
}) async {
  for (final seed in devSeeds(database, clock: clock)) {
    await seed.run();
  }
}
