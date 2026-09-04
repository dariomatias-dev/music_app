import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/library/data/seeds/favorite_seed.dart';
import 'package:music_app/src/features/library/data/seeds/library_seed.dart';

void main() {
  late AppDatabase database;

  DateTime clock() => DateTime(2026, 3, 15, 10, 30);

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await LibrarySeed(database, clock: clock).run();
    await FavoriteSeed(database, clock: clock).run();
  });

  test('favorites tracks from more than one artist', () async {
    final favorites = await database.favoriteDao.watchAll().first;
    final tracks = await database.trackDao.getAll();
    final tracksById = {for (final track in tracks) track.id: track};
    final artistIds = {
      for (final favorite in favorites) tracksById[favorite.trackId]!.artistId,
    };

    expect(favorites, isNotEmpty);
    expect(artistIds.length, greaterThan(1));
  });

  test('running twice keeps one favorite per track', () async {
    await FavoriteSeed(database, clock: clock).run();

    final favorites = await database.favoriteDao.watchAll().first;

    expect(
      favorites.map((favorite) => favorite.trackId).toSet().length,
      favorites.length,
    );
  });
}
