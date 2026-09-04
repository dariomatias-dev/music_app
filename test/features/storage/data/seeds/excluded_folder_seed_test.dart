import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/library/data/seeds/library_seed.dart';
import 'package:music_app/src/features/storage/data/seeds/excluded_folder_seed.dart';

void main() {
  late AppDatabase database;

  DateTime clock() => DateTime(2026, 3, 15, 10, 30);

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await ExcludedFolderSeed(database).run();
  });

  test('excludes folders from the scan', () async {
    expect(await database.excludedFolderDao.watchAll().first, isNotEmpty);
  });

  test('excludes no folder the seeded library indexes tracks in', () async {
    await LibrarySeed(database, clock: clock).run();

    final excluded = await database.excludedFolderDao.watchAll().first;
    final tracks = await database.trackDao.getAll();

    for (final path in excluded) {
      expect(
        tracks.where((track) => track.filePath.startsWith(path)),
        isEmpty,
        reason: path,
      );
    }
  });

  test('running twice does not repeat a folder', () async {
    await ExcludedFolderSeed(database).run();

    final excluded = await database.excludedFolderDao.watchAll().first;

    expect(excluded.toSet().length, excluded.length);
  });
}
