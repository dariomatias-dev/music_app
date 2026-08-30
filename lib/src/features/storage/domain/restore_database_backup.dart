import 'dart:io';
import 'dart:typed_data';

import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/errors/app_exception.dart';
import 'package:music_app/src/features/storage/domain/create_database_backup.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Resolves the directory the app's database file lives in.
typedef DocumentsDirectoryResolver = Future<Directory> Function();

/// The first 16 bytes of every valid SQLite database file: the ASCII
/// string `SQLite format 3` followed by a null terminator.
const _sqliteMagicHeader = [
  0x53, 0x51, 0x4c, 0x69, 0x74, 0x65, // 'SQLite'
  0x20, 0x66, 0x6f, 0x72, 0x6d, 0x61, 0x74, // ' format'
  0x20, 0x33, // ' 3'
  0x00,
];

/// Thrown by [RestoreDatabaseBackup] when the picked file isn't a SQLite
/// database.
class InvalidDatabaseBackupFile implements Exception {
  /// Creates an [InvalidDatabaseBackupFile].
  const InvalidDatabaseBackupFile();
}

/// Whether [bytes] starts with the SQLite file format's magic header.
///
/// Exposed so callers can reject an obviously wrong file (validation only,
/// no disk access) before taking any action that can't be undone, such as
/// closing the live database connection.
bool isSqliteDatabase(Uint8List bytes) {
  if (bytes.length < _sqliteMagicHeader.length) return false;
  for (var i = 0; i < _sqliteMagicHeader.length; i++) {
    if (bytes[i] != _sqliteMagicHeader[i]) return false;
  }
  return true;
}

/// Overwrites the app's database file with a raw [CreateDatabaseBackup]
/// snapshot.
///
/// The caller must close the current [AppDatabase] connection before
/// calling this (writing over a file SQLite still has open can corrupt it)
/// and restart the app afterwards, so a fresh connection opens against the
/// restored file.
class RestoreDatabaseBackup {
  /// Creates a [RestoreDatabaseBackup], optionally over an existing
  /// [documentsDirectory] resolver (useful for tests).
  const RestoreDatabaseBackup({
    DocumentsDirectoryResolver documentsDirectory =
        getApplicationDocumentsDirectory,
  }) : _documentsDirectory = documentsDirectory;

  final DocumentsDirectoryResolver _documentsDirectory;

  /// Restores [bytes] as the app's database file.
  ///
  /// Throws [InvalidDatabaseBackupFile] if [bytes] isn't a SQLite database,
  /// leaving the current database file untouched, and a [FileException] if
  /// writing over the database file fails.
  Future<void> call(Uint8List bytes) async {
    if (!isSqliteDatabase(bytes)) {
      throw const InvalidDatabaseBackupFile();
    }

    await FileException.guard('Could not restore the database file.', () async {
      final directory = await _documentsDirectory();
      final dbFile = File(p.join(directory.path, appDatabaseFileName));
      await dbFile.writeAsBytes(bytes, flush: true);

      // A restored file starts with no journal of its own; clear out any
      // sidecar files left by the connection this replaces, so SQLite doesn't
      // try to replay a journal that no longer matches the new content.
      for (final suffix in ['-wal', '-shm', '-journal']) {
        final sidecar = File('${dbFile.path}$suffix');
        if (sidecar.existsSync()) {
          await sidecar.delete();
        }
      }
    });
  }
}
