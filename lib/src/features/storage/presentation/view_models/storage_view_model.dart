import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/core/errors/error_reporter_provider.dart';
import 'package:music_app/src/core/services/device_file/device_file_service_provider.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';
import 'package:music_app/src/features/storage/data/providers/storage_data_providers.dart';
import 'package:music_app/src/features/storage/domain/restore_backup.dart';
import 'package:music_app/src/features/storage/domain/restore_database_backup.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_view_model.g.dart';

/// How a storage operation ended, for the screen to phrase in the user's
/// language.
enum StorageOutcome {
  /// The operation ran to completion.
  succeeded,

  /// The user backed out of the file picker, so nothing ran.
  cancelled,

  /// Including or excluding a folder could not be written.
  folderUpdateFailed,

  /// The rescan that follows a folder change failed.
  rescanFailed,

  /// The cached artwork could not be removed.
  artworkCacheClearFailed,

  /// A track's file could not be deleted.
  fileDeleteFailed,

  /// The backup could not be written to the chosen destination.
  backupExportFailed,

  /// The picked backup could not be restored.
  backupImportFailed,

  /// The picked file is a backup, but from a format this build can't read.
  unsupportedBackupFormat,

  /// The database snapshot could not be produced or written.
  databaseBackupExportFailed,

  /// The picked file isn't a SQLite database at all.
  invalidDatabaseBackup,

  /// Overwriting the database file with the picked snapshot failed.
  databaseRestoreFailed,
}

/// How importing a JSON backup ended, and how many of its tracks the
/// current library could not match.
typedef BackupImportResult = ({StorageOutcome outcome, int skippedTracks});

/// Runs the storage screen's operations, exposing whether one is in
/// flight so the screen can disable itself while it runs.
///
/// Every method returns a [StorageOutcome] rather than throwing, and
/// reports the cause it swallowed to the app's `ErrorReporter`: the screen
/// has one sentence to say about any of these failures, and the detail
/// that sentence leaves out would otherwise be lost.
@riverpod
class StorageViewModel extends _$StorageViewModel {
  @override
  bool build() => false;

  /// Includes or excludes [path] from the library scan, rescanning after.
  Future<StorageOutcome> toggleFolder(String path, {required bool included}) {
    return _whileBusy(() async {
      try {
        final repository = ref.read(excludedFolderRepositoryProvider);
        if (included) {
          await repository.include(path);
        } else {
          await repository.exclude(path);
        }
      } on Object catch (error, stackTrace) {
        _report('Updating an excluded folder', error, stackTrace);
        return StorageOutcome.folderUpdateFailed;
      }

      try {
        await ref.read(libraryRepositoryProvider).reindex().drain<void>();
      } on Object catch (error, stackTrace) {
        _report('Rescanning after a folder toggle', error, stackTrace);
        return StorageOutcome.rescanFailed;
      }

      return StorageOutcome.succeeded;
    });
  }

  /// Removes every cached cover image.
  Future<StorageOutcome> clearArtworkCache() {
    return _whileBusy(() async {
      try {
        await ref.read(libraryRepositoryProvider).clearArtworkCache();
        return StorageOutcome.succeeded;
      } on Object catch (error, stackTrace) {
        _report('Clearing the artwork cache', error, stackTrace);
        return StorageOutcome.artworkCacheClearFailed;
      }
    });
  }

  /// Deletes [track]'s file and drops it from the queue.
  Future<StorageOutcome> deleteTrack(Track track) {
    return _whileBusy(() async {
      try {
        await ref.read(deleteTrackFileProvider)(track);
        await ref
            .read(queueViewModelProvider.notifier)
            .removeTrackFromQueue(track.id);
        return StorageOutcome.succeeded;
      } on Exception catch (error, stackTrace) {
        _report('Deleting a track file', error, stackTrace);
        return StorageOutcome.fileDeleteFailed;
      }
    });
  }

  /// Writes a portable JSON backup to a destination the user picks.
  Future<StorageOutcome> exportBackup() {
    return _whileBusy(() async {
      try {
        final snapshot = await ref.read(createBackupProvider)();
        final json = jsonEncode(snapshot.toJson());
        final timestamp = snapshot.createdAt.toIso8601String().replaceAll(
          RegExp('[:.]'),
          '-',
        );
        await ref
            .read(deviceFileServiceProvider)
            .saveFile(
              fileName: 'music_app_backup_$timestamp.json',
              bytes: Uint8List.fromList(utf8.encode(json)),
            );
        return StorageOutcome.succeeded;
      } on Object catch (error, stackTrace) {
        _report('Exporting a backup', error, stackTrace);
        return StorageOutcome.backupExportFailed;
      }
    });
  }

  /// Restores a JSON backup the user picks, merging it into this install.
  Future<BackupImportResult> importBackup() async {
    final bytes = await _pickFile('Picking a backup file', const ['json']);
    if (bytes == null) {
      return (outcome: StorageOutcome.cancelled, skippedTracks: 0);
    }

    return _whileBusy(() async {
      try {
        final snapshot = readBackupSnapshot(bytes);
        final result = await ref.read(restoreBackupProvider)(snapshot);
        return (
          outcome: StorageOutcome.succeeded,
          skippedTracks: result.skippedTracks,
        );
      } on UnsupportedBackupFormatVersion {
        return (
          outcome: StorageOutcome.unsupportedBackupFormat,
          skippedTracks: 0,
        );
      } on Object catch (error, stackTrace) {
        _report('Importing a backup', error, stackTrace);
        return (outcome: StorageOutcome.backupImportFailed, skippedTracks: 0);
      }
    });
  }

  /// Writes a byte-for-byte database snapshot to a destination the user
  /// picks.
  Future<StorageOutcome> exportDatabaseBackup() {
    return _whileBusy(() async {
      try {
        final bytes = await ref.read(createDatabaseBackupProvider)();
        final timestamp = DateTime.now().toIso8601String().replaceAll(
          RegExp('[:.]'),
          '-',
        );
        await ref
            .read(deviceFileServiceProvider)
            .saveFile(fileName: 'music_app_db_$timestamp.sqlite', bytes: bytes);
        return StorageOutcome.succeeded;
      } on Object catch (error, stackTrace) {
        _report('Exporting a database backup', error, stackTrace);
        return StorageOutcome.databaseBackupExportFailed;
      }
    });
  }

  /// Replaces the database file with a snapshot the user picks.
  ///
  /// The caller has to restart the app on anything but
  /// [StorageOutcome.cancelled] and [StorageOutcome.invalidDatabaseBackup]:
  /// past the close below there is no live connection left to serve the
  /// screen, whether the write that follows succeeded or not.
  Future<StorageOutcome> restoreDatabaseBackup() async {
    final bytes = await _pickFile('Picking a database backup', const [
      'sqlite',
      'db',
    ]);
    if (bytes == null) return StorageOutcome.cancelled;
    if (!isSqliteDatabase(bytes)) return StorageOutcome.invalidDatabaseBackup;

    return _whileBusy(() async {
      try {
        // The database file is about to be overwritten on disk, so the live
        // connection is closed first: writing under an open SQLite
        // connection can corrupt it.
        await ref.read(appDatabaseProvider).close();
        await ref.read(restoreDatabaseBackupProvider)(bytes);
        return StorageOutcome.succeeded;
      } on Object catch (error, stackTrace) {
        _report('Restoring a database backup', error, stackTrace);
        return StorageOutcome.databaseRestoreFailed;
      }
    });
  }

  /// Asks the user for a file, returning `null` when they back out.
  ///
  /// A picker that fails outright reads as a cancellation here: there are
  /// no bytes either way, and the operation has not started yet.
  Future<Uint8List?> _pickFile(
    String operation,
    List<String> allowedExtensions,
  ) async {
    try {
      return await ref
          .read(deviceFileServiceProvider)
          .pickFile(allowedExtensions: allowedExtensions);
    } on Object catch (error, stackTrace) {
      _report(operation, error, stackTrace);
      return null;
    }
  }

  /// Runs [operation] with the screen marked busy, releasing it after.
  Future<T> _whileBusy<T>(Future<T> Function() operation) async {
    state = true;
    try {
      return await operation();
    } finally {
      if (ref.mounted) state = false;
    }
  }

  void _report(String operation, Object error, StackTrace stackTrace) {
    ref
        .read(errorReporterProvider)
        .report(error, stackTrace, context: operation);
  }
}
