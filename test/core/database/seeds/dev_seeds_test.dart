import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/seeds/dev_seed_guard.dart';
import 'package:music_app/src/core/database/seeds/dev_seeds.dart';

void main() {
  late AppDatabase database;

  DateTime clock() => DateTime(2026, 3, 15, 10, 30);

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
  });

  Future<
    ({
      int tracks,
      int favorites,
      int playlists,
      int plays,
      int lyrics,
      int searches,
      int excludedFolders,
    })
  >
  counts() async {
    return (
      tracks: (await database.trackDao.getAll()).length,
      favorites: (await database.favoriteDao.watchAll().first).length,
      playlists: (await database.playlistDao.watchAll().first).length,
      plays: (await database.playEventDao.getAll()).length,
      lyrics: (await database.select(database.lyricsTable).get()).length,
      searches: (await database.searchHistoryDao.watchRecent(limit: 100).first)
          .length,
      excludedFolders:
          (await database.excludedFolderDao.watchAll().first).length,
    );
  }

  test('fills every table the app reads on launch', () async {
    await runDevSeeds(database, clock: clock);

    final filled = await counts();

    expect(filled.tracks, greaterThan(20));
    expect(filled.favorites, greaterThan(0));
    expect(filled.playlists, greaterThan(0));
    expect(filled.plays, greaterThan(0));
    expect(filled.lyrics, greaterThan(0));
    expect(filled.searches, greaterThan(0));
    expect(filled.excludedFolders, greaterThan(0));
  });

  test('running twice leaves the same data behind', () async {
    await runDevSeeds(database, clock: clock);
    final first = await counts();

    await runDevSeeds(database, clock: clock);

    expect(await counts(), first);
  });

  test('writes the same rows for the same clock', () async {
    await runDevSeeds(database, clock: clock);
    final first = await database.trackDao.getAll();

    final second = AppDatabase(NativeDatabase.memory());
    addTearDown(second.close);
    await runDevSeeds(second, clock: clock);

    expect(await second.trackDao.getAll(), first);
  });

  test('dates the library against the clock it is given', () async {
    await runDevSeeds(database, clock: clock);

    final tracks = await database.trackDao.getAll();
    final newest = tracks
        .map((track) => track.dateAdded)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    expect(newest, clock());
  });

  test('seeds nothing unless the build asked for them', () async {
    await runDevSeedsIfEnabled(database);

    expect((await counts()).tracks, 0);
    expect(devSeedsEnabled, isFalse);
  });
}
