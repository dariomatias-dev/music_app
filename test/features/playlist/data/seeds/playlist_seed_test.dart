import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/library/data/seeds/library_seed.dart';
import 'package:music_app/src/features/playlist/data/seeds/playlist_seed.dart';

void main() {
  late AppDatabase database;

  DateTime clock() => DateTime(2026, 3, 15, 10, 30);

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await LibrarySeed(database, clock: clock).run();
    await PlaylistSeed(database, clock: clock).run();
  });

  Future<List<int>> trackCounts() async {
    final playlists = await database.playlistDao.watchAll().first;
    return [
      for (final playlist in playlists)
        (await database.playlistTrackDao.watchForPlaylist(playlist.id).first)
            .length,
    ];
  }

  test('writes a full, a short and an empty playlist', () async {
    final counts = await trackCounts()
      ..sort();

    expect(counts.length, 3);
    expect(counts.first, 0);
    expect(counts.last, greaterThan(5));
  });

  test('carries a description and a favorited playlist', () async {
    final playlists = await database.playlistDao.watchAll().first;

    expect(
      playlists.where((playlist) => playlist.description != null),
      isNotEmpty,
    );
    expect(playlists.where((playlist) => playlist.isFavorite), isNotEmpty);
  });

  test('running twice neither duplicates playlists nor their tracks', () async {
    final before = await trackCounts()
      ..sort();

    await PlaylistSeed(database, clock: clock).run();

    expect(
      await trackCounts()
        ..sort(),
      before,
    );
  });
}
