import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/storage/domain/create_database_backup.dart';
import 'package:music_app/src/features/storage/domain/restore_database_backup.dart';

Future<Uint8List> _validBackupBytes(Directory dir) async {
  final database = AppDatabase(NativeDatabase.memory());
  final bytes = await CreateDatabaseBackup(
    database,
    tempDirectory: () async => dir,
  )();
  await database.close();
  return bytes;
}

void main() {
  late Directory documentsDir;
  late RestoreDatabaseBackup restoreDatabaseBackup;

  setUp(() async {
    documentsDir = await Directory.systemTemp.createTemp(
      'db_restore_test_docs',
    );
    restoreDatabaseBackup = RestoreDatabaseBackup(
      documentsDirectory: () async => documentsDir,
    );
  });

  tearDown(() => documentsDir.delete(recursive: true));

  test('throws for a file that is not a SQLite database', () async {
    final bytes = Uint8List.fromList('not a database'.codeUnits);

    await expectLater(
      restoreDatabaseBackup(bytes),
      throwsA(isA<InvalidDatabaseBackupFile>()),
    );
  });

  test('leaves no database file behind for an invalid backup', () async {
    final bytes = Uint8List.fromList('not a database'.codeUnits);

    await expectLater(
      restoreDatabaseBackup(bytes),
      throwsA(isA<InvalidDatabaseBackupFile>()),
    );
    expect(
      File('${documentsDir.path}/$appDatabaseFileName').existsSync(),
      isFalse,
    );
  });

  test('writes a valid backup to the app database file path', () async {
    final bytes = await _validBackupBytes(documentsDir);

    await restoreDatabaseBackup(bytes);

    final dbFile = File('${documentsDir.path}/$appDatabaseFileName');
    expect(dbFile.existsSync(), isTrue);
    expect(await dbFile.readAsBytes(), bytes);
  });

  test(
    'clears stale WAL/SHM/journal sidecars from a previous connection',
    () async {
      final bytes = await _validBackupBytes(documentsDir);
      for (final suffix in ['-wal', '-shm', '-journal']) {
        await File(
          '${documentsDir.path}/$appDatabaseFileName$suffix',
        ).writeAsBytes([1, 2, 3]);
      }

      await restoreDatabaseBackup(bytes);

      for (final suffix in ['-wal', '-shm', '-journal']) {
        expect(
          File('${documentsDir.path}/$appDatabaseFileName$suffix').existsSync(),
          isFalse,
        );
      }
    },
  );
}
