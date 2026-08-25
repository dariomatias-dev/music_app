import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/storage/domain/create_database_backup.dart';
import 'package:music_app/src/features/storage/domain/restore_database_backup.dart';

void main() {
  late Directory tempDir;
  late AppDatabase database;
  late CreateDatabaseBackup createDatabaseBackup;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('db_backup_test');
    database = AppDatabase(NativeDatabase.memory());
    createDatabaseBackup = CreateDatabaseBackup(
      database,
      tempDirectory: () async => tempDir,
    );
  });

  tearDown(() async {
    await database.close();
    await tempDir.delete(recursive: true);
  });

  test('produces a valid SQLite file', () async {
    final bytes = await createDatabaseBackup();

    expect(isSqliteDatabase(bytes), isTrue);
  });

  test('carries the data already in the database', () async {
    await database.artistDao.upsertOne(
      ArtistTableCompanion.insert(
        id: 'artist-1',
        sourceId: 'charcoal',
        name: 'Charcoal',
        albumCount: 0,
        trackCount: 0,
      ),
    );

    final bytes = await createDatabaseBackup();

    final restoredFile = File('${tempDir.path}/restored.sqlite');
    await restoredFile.writeAsBytes(bytes);
    final restoredDatabase = AppDatabase(NativeDatabase(restoredFile));
    addTearDown(restoredDatabase.close);

    final artists = await restoredDatabase.artistDao.watchAll().first;
    expect(artists, hasLength(1));
    expect(artists.single.name, 'Charcoal');
  });

  test('does not leave the temporary export file behind', () async {
    await createDatabaseBackup();

    expect(tempDir.listSync(), isEmpty);
  });
}
