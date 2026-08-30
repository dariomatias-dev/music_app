import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/errors/app_exception.dart';
import 'package:music_app/src/core/errors/error_reporter_provider.dart';
import 'package:music_app/src/core/services/device_file/device_file_service_provider.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/storage/data/providers/storage_data_providers.dart';
import 'package:music_app/src/features/storage/presentation/view_models/storage_view_model.dart';

import '../../../../helpers/fake_device_file_service.dart';
import '../../../../helpers/fake_error_reporter.dart';
import '../../../../helpers/fake_excluded_folder_repository.dart';

class _FakeLibraryRepository implements LibraryRepository {
  bool reindexShouldThrow = false;
  bool clearShouldThrow = false;
  int reindexCalls = 0;
  bool artworkCacheCleared = false;

  @override
  Stream<IndexingProgress> reindex() async* {
    reindexCalls++;
    if (reindexShouldThrow) throw Exception('scan boom');
  }

  @override
  Future<void> clearArtworkCache() async {
    if (clearShouldThrow) throw const FileException('cache boom');
    artworkCacheCleared = true;
  }

  @override
  Stream<List<Track>> watchTracks() => Stream.value(const []);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const []);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const []);

  @override
  Future<void> purgeMissingTracks() async {}

  @override
  Future<void> updateTrackTags(
    String trackId, {
    required String title,
    required String artist,
    required String album,
  }) async {}
}

void main() {
  late FakeErrorReporter errorReporter;
  late FakeExcludedFolderRepository excludedFolders;
  late _FakeLibraryRepository library;
  late FakeDeviceFileService deviceFiles;

  ProviderContainer container() {
    final result = ProviderContainer(
      overrides: [
        errorReporterProvider.overrideWithValue(errorReporter),
        excludedFolderRepositoryProvider.overrideWithValue(excludedFolders),
        libraryRepositoryProvider.overrideWithValue(library),
        deviceFileServiceProvider.overrideWithValue(deviceFiles),
      ],
    );
    addTearDown(result.dispose);
    return result;
  }

  setUp(() {
    errorReporter = FakeErrorReporter();
    excludedFolders = FakeExcludedFolderRepository();
    library = _FakeLibraryRepository();
    deviceFiles = FakeDeviceFileService();
  });

  test('starts idle', () {
    expect(container().read(storageViewModelProvider), isFalse);
  });

  group('toggleFolder', () {
    test('excludes the folder and rescans', () async {
      final outcome = await container()
          .read(storageViewModelProvider.notifier)
          .toggleFolder('/music/rock', included: false);

      expect(outcome, StorageOutcome.succeeded);
      expect(await excludedFolders.watchExcludedFolders().first, [
        '/music/rock',
      ]);
      expect(library.reindexCalls, 1);
    });

    test('includes the folder again', () async {
      await excludedFolders.exclude('/music/rock');

      final outcome = await container()
          .read(storageViewModelProvider.notifier)
          .toggleFolder('/music/rock', included: true);

      expect(outcome, StorageOutcome.succeeded);
      expect(await excludedFolders.watchExcludedFolders().first, isEmpty);
    });

    test('reports a failed write without rescanning', () async {
      excludedFolders.writeShouldThrow = true;

      final outcome = await container()
          .read(storageViewModelProvider.notifier)
          .toggleFolder('/music/rock', included: false);

      expect(outcome, StorageOutcome.folderUpdateFailed);
      expect(library.reindexCalls, 0);
      expect(
        errorReporter.reports.single.context,
        'Updating an excluded folder',
      );
    });

    test('reports a failed rescan after the write went through', () async {
      library.reindexShouldThrow = true;

      final outcome = await container()
          .read(storageViewModelProvider.notifier)
          .toggleFolder('/music/rock', included: false);

      expect(outcome, StorageOutcome.rescanFailed);
      expect(await excludedFolders.watchExcludedFolders().first, [
        '/music/rock',
      ]);
      expect(
        errorReporter.reports.single.context,
        'Rescanning after a folder toggle',
      );
    });

    test('releases the busy state whichever way it ends', () async {
      excludedFolders.writeShouldThrow = true;
      final target = container();

      await target
          .read(storageViewModelProvider.notifier)
          .toggleFolder('/music/rock', included: false);

      expect(target.read(storageViewModelProvider), isFalse);
    });
  });

  group('clearArtworkCache', () {
    test('clears the cache', () async {
      final outcome = await container()
          .read(storageViewModelProvider.notifier)
          .clearArtworkCache();

      expect(outcome, StorageOutcome.succeeded);
      expect(library.artworkCacheCleared, isTrue);
    });

    test('reports a failure instead of letting it escape', () async {
      library.clearShouldThrow = true;

      final outcome = await container()
          .read(storageViewModelProvider.notifier)
          .clearArtworkCache();

      expect(outcome, StorageOutcome.artworkCacheClearFailed);
      expect(
        errorReporter.reports.single.context,
        'Clearing the artwork cache',
      );
    });
  });

  group('importBackup', () {
    test('reads a cancelled picker as a cancellation', () async {
      final result = await container()
          .read(storageViewModelProvider.notifier)
          .importBackup();

      expect(result.outcome, StorageOutcome.cancelled);
      expect(errorReporter.reports, isEmpty);
    });

    test('reports a picker that fails, and cancels', () async {
      deviceFiles.pickShouldThrow = true;

      final result = await container()
          .read(storageViewModelProvider.notifier)
          .importBackup();

      expect(result.outcome, StorageOutcome.cancelled);
      expect(errorReporter.reports.single.context, 'Picking a backup file');
    });

    test('rejects a backup written by an unsupported format version', () async {
      deviceFiles.fileToPick = Uint8List.fromList(
        utf8.encode(jsonEncode({'formatVersion': 0})),
      );

      final result = await container()
          .read(storageViewModelProvider.notifier)
          .importBackup();

      expect(result.outcome, StorageOutcome.unsupportedBackupFormat);
    });

    test('reports a file that is not a backup at all', () async {
      deviceFiles.fileToPick = Uint8List.fromList(utf8.encode('nonsense'));

      final result = await container()
          .read(storageViewModelProvider.notifier)
          .importBackup();

      expect(result.outcome, StorageOutcome.backupImportFailed);
      expect(errorReporter.reports.single.context, 'Importing a backup');
    });
  });

  group('restoreDatabaseBackup', () {
    test('reads a cancelled picker as a cancellation', () async {
      final outcome = await container()
          .read(storageViewModelProvider.notifier)
          .restoreDatabaseBackup();

      expect(outcome, StorageOutcome.cancelled);
    });

    test('rejects a file that is not a SQLite database', () async {
      deviceFiles.fileToPick = Uint8List.fromList(utf8.encode('nonsense'));

      final outcome = await container()
          .read(storageViewModelProvider.notifier)
          .restoreDatabaseBackup();

      expect(outcome, StorageOutcome.invalidDatabaseBackup);
    });
  });
}
