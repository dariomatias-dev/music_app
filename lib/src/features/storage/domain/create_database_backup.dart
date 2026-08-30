import 'dart:io';
import 'dart:typed_data';

import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/errors/app_exception.dart';
import 'package:music_app/src/features/storage/domain/create_backup.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Resolves the directory to stage a temporary export file in.
typedef TempDirectoryResolver = Future<Directory> Function();

/// Produces a byte-for-byte snapshot of the on-disk database file.
///
/// Unlike [CreateBackup]'s portable JSON snapshot, this carries every table
/// as-is (including the indexed library), so restoring it recreates the
/// install exactly rather than merging into whatever is already there.
class CreateDatabaseBackup {
  /// Creates a [CreateDatabaseBackup], optionally over an existing
  /// [tempDirectory] resolver (useful for tests).
  const CreateDatabaseBackup(
    this._database, {
    TempDirectoryResolver tempDirectory = getTemporaryDirectory,
  }) : _tempDirectory = tempDirectory;

  final AppDatabase _database;
  final TempDirectoryResolver _tempDirectory;

  /// Builds the snapshot.
  ///
  /// Uses `VACUUM INTO` rather than copying the file directly, so the
  /// result is complete and consistent even while the app keeps writing to
  /// the database (journal-mode changes, in-flight transactions, ...).
  ///
  /// Throws a [FileException] if the snapshot cannot be written or read
  /// back.
  Future<Uint8List> call() {
    return FileException.guard('Could not export the database.', () async {
      final tempDir = await _tempDirectory();
      final tempFile = File(
        p.join(
          tempDir.path,
          'music_app_db_export_${DateTime.now().microsecondsSinceEpoch}.sqlite',
        ),
      );
      await _database.customStatement("VACUUM INTO '${tempFile.path}'");
      try {
        return await tempFile.readAsBytes();
      } finally {
        await tempFile.delete();
      }
    });
  }
}
