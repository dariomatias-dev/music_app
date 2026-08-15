import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/storage/data/repositories/excluded_folder_repository_impl.dart';

void main() {
  late AppDatabase database;
  late ExcludedFolderRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = ExcludedFolderRepositoryImpl(database);
  });

  tearDown(() => database.close());

  test('watchExcludedFolders is empty by default', () async {
    expect(await repository.watchExcludedFolders().first, isEmpty);
  });

  test('exclude adds a folder to the excluded list', () async {
    await repository.exclude('/music/skip');

    expect(await repository.watchExcludedFolders().first, ['/music/skip']);
  });

  test('exclude does not duplicate an already-excluded folder', () async {
    await repository.exclude('/music/skip');
    await repository.exclude('/music/skip');

    expect(await repository.watchExcludedFolders().first, ['/music/skip']);
  });

  test('include removes a folder from the excluded list', () async {
    await repository.exclude('/music/skip');
    await repository.exclude('/music/keep');

    await repository.include('/music/skip');

    expect(await repository.watchExcludedFolders().first, ['/music/keep']);
  });
}
