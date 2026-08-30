import 'dart:async';

import 'dart:convert';
import 'dart:typed_data';

import 'package:app_ui/app_ui.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/core/errors/error_reporter_provider.dart';
import 'package:music_app/src/core/services/device_file/device_file_service_provider.dart';
import 'package:music_app/src/core/widgets/restart_widget.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/storage/data/providers/storage_data_providers.dart';
import 'package:music_app/src/features/storage/domain/create_backup.dart';
import 'package:music_app/src/features/storage/domain/create_database_backup.dart';
import 'package:music_app/src/features/storage/domain/delete_track_file.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_settings.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_snapshot.dart';
import 'package:music_app/src/features/storage/domain/entities/folder_usage.dart';
import 'package:music_app/src/features/storage/domain/restore_backup.dart';
import 'package:music_app/src/features/storage/domain/restore_database_backup.dart';
import 'package:music_app/src/features/storage/presentation/providers/storage_providers.dart';
import 'package:music_app/src/features/storage/presentation/screens/storage_screen.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fake_device_file_service.dart';
import '../../../../helpers/fake_error_reporter.dart';
import '../../../../helpers/fake_excluded_folder_repository.dart';

/// An [AppDatabase] whose connection refuses to close, standing in for a
/// database still held by a pending write when a restore asks to replace
/// the file underneath it.
class _UnclosableDatabase extends AppDatabase {
  _UnclosableDatabase() : super(NativeDatabase.memory());

  @override
  Future<void> close() async => throw Exception('close failed');
}

class _FakeLibraryRepository implements LibraryRepository {
  _FakeLibraryRepository({this.tracks = const []});

  final List<Track> tracks;
  int reindexCalls = 0;
  bool artworkCacheCleared = false;
  bool reindexShouldThrow = false;

  /// Held open so a test can observe the screen mid-rescan.
  Completer<void>? reindexGate;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const []);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const []);

  @override
  Stream<IndexingProgress> reindex() async* {
    reindexCalls++;
    if (reindexShouldThrow) throw Exception('scan boom');
    final gate = reindexGate;
    if (gate != null) await gate.future;
  }

  @override
  Future<void> purgeMissingTracks() async {}

  @override
  Future<void> updateTrackTags(
    String trackId, {
    required String title,
    required String artist,
    required String album,
  }) async {}

  @override
  Future<void> clearArtworkCache() async {
    artworkCacheCleared = true;
  }
}

class _FakeDeleteTrackFile implements DeleteTrackFile {
  final List<Track> deleted = [];
  bool shouldThrow = false;

  @override
  Future<void> call(Track track) async {
    if (shouldThrow) throw Exception('boom');
    deleted.add(track);
  }
}

class _FakeCreateBackup implements CreateBackup {
  _FakeCreateBackup(this.snapshot);
  final BackupSnapshot snapshot;

  @override
  Future<BackupSnapshot> call() async => snapshot;
}

class _FakeRestoreBackup implements RestoreBackup {
  _FakeRestoreBackup(this.result);
  final RestoreBackupResult result;
  BackupSnapshot? received;

  @override
  Future<RestoreBackupResult> call(BackupSnapshot snapshot) async {
    received = snapshot;
    return result;
  }
}

class _FakeCreateDatabaseBackup implements CreateDatabaseBackup {
  _FakeCreateDatabaseBackup(this.bytes);
  final Uint8List bytes;

  @override
  Future<Uint8List> call() async => bytes;
}

class _FakeRestoreDatabaseBackup implements RestoreDatabaseBackup {
  _FakeRestoreDatabaseBackup({this.shouldThrow = false});
  final bool shouldThrow;
  Uint8List? received;

  @override
  Future<void> call(Uint8List bytes) async {
    if (shouldThrow) throw const InvalidDatabaseBackupFile();
    received = bytes;
  }
}

Uint8List _sqliteBytes() => Uint8List.fromList([
  0x53,
  0x51,
  0x4c,
  0x69,
  0x74,
  0x65,
  0x20,
  0x66,
  0x6f,
  0x72,
  0x6d,
  0x61,
  0x74,
  0x20,
  0x33,
  0x00,
  ...List.filled(16, 0),
]);

BackupSnapshot _snapshot({int formatVersion = backupFormatVersion}) {
  return BackupSnapshot(
    formatVersion: formatVersion,
    createdAt: DateTime(2026),
    playlists: const [],
    favoriteTrackSourceIds: const [],
    playHistory: const [],
    excludedFolders: const [],
    searchHistoryTerms: const [],
    settings: const BackupSettings(
      gaplessEnabled: true,
      crossfadeDurationSeconds: 0,
      defaultPlaybackSpeed: 1,
      hapticsEnabled: true,
    ),
  );
}

Uint8List _encode(BackupSnapshot snapshot) {
  return Uint8List.fromList(utf8.encode(jsonEncode(snapshot.toJson())));
}

Track _track(String id, {required String filePath, int fileSize = 1000}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: filePath,
    title: 'Track $id',
    artistId: 'artist-1',
    albumId: 'album-1',
    duration: const Duration(minutes: 3),
    format: 'mp3',
    fileSize: fileSize,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
  );
}

Widget _app({
  _FakeLibraryRepository? libraryRepository,
  FakeExcludedFolderRepository? excludedFolderRepository,
  DeleteTrackFile? deleteTrackFile,
  CreateBackup? createBackup,
  RestoreBackup? restoreBackup,
  CreateDatabaseBackup? createDatabaseBackup,
  RestoreDatabaseBackup? restoreDatabaseBackup,
  FakeDeviceFileService? deviceFileService,
  List<FolderUsage>? folderUsage,
  AppDatabase? database,
  FakeErrorReporter? errorReporter,
}) {
  final playerService = FakeAudioPlayerService();
  return RestartWidget(
    child: ProviderScope(
      overrides: [
        libraryRepositoryProvider.overrideWithValue(
          libraryRepository ?? _FakeLibraryRepository(),
        ),
        excludedFolderRepositoryProvider.overrideWithValue(
          excludedFolderRepository ?? FakeExcludedFolderRepository(),
        ),
        if (folderUsage != null)
          folderUsageProvider.overrideWithValue(folderUsage),
        if (deleteTrackFile != null)
          deleteTrackFileProvider.overrideWithValue(deleteTrackFile),
        if (createBackup != null)
          createBackupProvider.overrideWithValue(createBackup),
        if (restoreBackup != null)
          restoreBackupProvider.overrideWithValue(restoreBackup),
        if (createDatabaseBackup != null)
          createDatabaseBackupProvider.overrideWithValue(createDatabaseBackup),
        if (restoreDatabaseBackup != null)
          restoreDatabaseBackupProvider.overrideWithValue(
            restoreDatabaseBackup,
          ),
        appDatabaseProvider.overrideWithValue(
          database ?? AppDatabase(NativeDatabase.memory()),
        ),
        errorReporterProvider.overrideWithValue(
          errorReporter ?? FakeErrorReporter(),
        ),
        deviceFileServiceProvider.overrideWithValue(
          deviceFileService ?? FakeDeviceFileService(),
        ),
        audioPlayerServiceProvider.overrideWithValue(playerService),
        audioHandlerProvider.overrideWithValue(
          MusicAudioHandler(playerService),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: StorageScreen()),
      ),
    ),
  );
}

void main() {
  testWidgets('shows the empty state when there are no folders', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.text('No folders yet'), findsOneWidget);
  });

  testWidgets('shows total space used and each folder', (tester) async {
    await tester.pumpWidget(
      _app(
        libraryRepository: _FakeLibraryRepository(
          tracks: [
            _track('a', filePath: '/music/rock/a.mp3'),
            _track('b', filePath: '/music/pop/b.mp3', fileSize: 2000),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('2.9 KB'), findsOneWidget);
    expect(find.text('rock'), findsOneWidget);
    expect(find.text('pop'), findsOneWidget);
  });

  testWidgets(
    'an empty folder is not expandable and shows a dimmed chevron',
    (tester) async {
      await tester.pumpWidget(
        _app(
          folderUsage: const [
            FolderUsage(
              path: '/music/empty',
              sizeBytes: 0,
              trackCount: 0,
              isIncluded: true,
            ),
          ],
        ),
      );
      await tester.pump();

      expect(find.text('empty'), findsOneWidget);

      await tester.tap(find.text('empty'));
      await tester.pumpAndSettle();

      expect(find.text('Track a'), findsNothing);
      final icon = tester.widget<Icon>(
        find.descendant(
          of: find.byType(AnimatedRotation),
          matching: find.byType(Icon),
        ),
      );
      expect(icon.color?.a, closeTo(0.4, 0.01));
    },
  );

  testWidgets('expanding a folder shows its files', (tester) async {
    await tester.pumpWidget(
      _app(
        libraryRepository: _FakeLibraryRepository(
          tracks: [_track('a', filePath: '/music/rock/a.mp3', fileSize: 500)],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Track a'), findsNothing);

    await tester.tap(find.text('rock'));
    await tester.pumpAndSettle();

    expect(find.text('Track a'), findsOneWidget);
  });

  testWidgets(
    'expanding a folder with many tracks only builds the visible ones',
    (tester) async {
      await tester.pumpWidget(
        _app(
          libraryRepository: _FakeLibraryRepository(
            tracks: [
              for (var i = 0; i < 1000; i++)
                _track('t$i', filePath: '/music/rock/t$i.mp3'),
            ],
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('rock'));
      await tester.pump();

      expect(find.text('Track t0'), findsOneWidget);
      expect(find.text('Track t999'), findsNothing);
    },
  );

  testWidgets('toggling a folder off excludes it and triggers a rescan', (
    tester,
  ) async {
    final libraryRepository = _FakeLibraryRepository(
      tracks: [_track('a', filePath: '/music/rock/a.mp3')],
    );
    final excludedFolderRepository = FakeExcludedFolderRepository();
    await tester.pumpWidget(
      _app(
        libraryRepository: libraryRepository,
        excludedFolderRepository: excludedFolderRepository,
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(AppSwitch));
    await tester.pumpAndSettle();

    expect(
      await excludedFolderRepository.watchExcludedFolders().first,
      ['/music/rock'],
    );
    expect(libraryRepository.reindexCalls, 1);
  });

  testWidgets('shows an error toast and clears busy when rescan fails', (
    tester,
  ) async {
    final libraryRepository = _FakeLibraryRepository(
      tracks: [_track('a', filePath: '/music/rock/a.mp3')],
    )..reindexShouldThrow = true;
    final excludedFolderRepository = FakeExcludedFolderRepository();
    await tester.pumpWidget(
      _app(
        libraryRepository: libraryRepository,
        excludedFolderRepository: excludedFolderRepository,
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(AppSwitch));
    await tester.pumpAndSettle();

    expect(
      find.text('Something went wrong while scanning your music library.'),
      findsOneWidget,
    );

    // Not stuck busy: a second toggle reaches the repository again.
    await tester.tap(find.byType(AppSwitch));
    await tester.pumpAndSettle();
    expect(libraryRepository.reindexCalls, 2);
  });

  testWidgets('shows an error toast and clears busy when the write fails', (
    tester,
  ) async {
    final libraryRepository = _FakeLibraryRepository(
      tracks: [_track('a', filePath: '/music/rock/a.mp3')],
    );
    final excludedFolderRepository = FakeExcludedFolderRepository()
      ..writeShouldThrow = true;
    await tester.pumpWidget(
      _app(
        libraryRepository: libraryRepository,
        excludedFolderRepository: excludedFolderRepository,
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(AppSwitch));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't update that folder."), findsOneWidget);
    expect(libraryRepository.reindexCalls, 0);
    expect(find.byType(LinearProgressIndicator), findsNothing);

    excludedFolderRepository.writeShouldThrow = false;
    await tester.tap(find.byType(AppSwitch));
    await tester.pumpAndSettle();

    expect(excludedFolderRepository.writeCalls, 2);
    expect(libraryRepository.reindexCalls, 1);
  });

  testWidgets('records the cause of a failure the toast only summarizes', (
    tester,
  ) async {
    final errorReporter = FakeErrorReporter();
    final excludedFolderRepository = FakeExcludedFolderRepository()
      ..writeShouldThrow = true;
    await tester.pumpWidget(
      _app(
        libraryRepository: _FakeLibraryRepository(
          tracks: [_track('a', filePath: '/music/rock/a.mp3')],
        ),
        excludedFolderRepository: excludedFolderRepository,
        errorReporter: errorReporter,
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(AppSwitch));
    await tester.pumpAndSettle();

    expect(errorReporter.reports, hasLength(1));
    expect(
      errorReporter.reports.single.context,
      'Updating an excluded folder',
    );
    expect(errorReporter.reports.single.error, isA<Exception>());
  });

  testWidgets('clearing artwork cache calls it after confirming', (
    tester,
  ) async {
    final libraryRepository = _FakeLibraryRepository(
      tracks: [_track('a', filePath: '/music/rock/a.mp3')],
    );
    await tester.pumpWidget(_app(libraryRepository: libraryRepository));
    await tester.pump();

    await tester.tap(find.text('Clear artwork cache'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(libraryRepository.artworkCacheCleared, isTrue);
  });

  testWidgets('deleting a file removes it after confirming', (tester) async {
    final deleteTrackFile = _FakeDeleteTrackFile();
    await tester.pumpWidget(
      _app(
        libraryRepository: _FakeLibraryRepository(
          tracks: [_track('a', filePath: '/music/rock/a.mp3')],
        ),
        deleteTrackFile: deleteTrackFile,
      ),
    );
    await tester.pump();

    await tester.tap(find.text('rock'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(deleteTrackFile.deleted.map((t) => t.id), ['a']);
    expect(find.text('File deleted'), findsOneWidget);
  });

  testWidgets('shows an error toast when deletion fails', (tester) async {
    final deleteTrackFile = _FakeDeleteTrackFile()..shouldThrow = true;
    await tester.pumpWidget(
      _app(
        libraryRepository: _FakeLibraryRepository(
          tracks: [_track('a', filePath: '/music/rock/a.mp3')],
        ),
        deleteTrackFile: deleteTrackFile,
      ),
    );
    await tester.pump();

    await tester.tap(find.text('rock'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't delete this file"), findsOneWidget);
  });

  testWidgets('the backup actions are reachable with an empty library', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.text('No folders yet'), findsOneWidget);
    expect(find.text('Export backup'), findsOneWidget);
    expect(find.text('Restore backup'), findsOneWidget);
  });

  testWidgets('exporting a backup saves it and confirms', (tester) async {
    final deviceFileService = FakeDeviceFileService();
    final snapshot = _snapshot();
    await tester.pumpWidget(
      _app(
        createBackup: _FakeCreateBackup(snapshot),
        deviceFileService: deviceFileService,
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Export backup'));
    await tester.pumpAndSettle();

    expect(deviceFileService.savedFileName, isNotNull);
    final savedJson =
        jsonDecode(utf8.decode(deviceFileService.savedBytes!))
            as Map<String, dynamic>;
    expect(BackupSnapshot.fromJson(savedJson), snapshot);
    expect(find.text('Backup saved'), findsOneWidget);
  });

  testWidgets('shows an error toast when the export fails', (tester) async {
    final deviceFileService = FakeDeviceFileService()..saveShouldThrow = true;
    await tester.pumpWidget(
      _app(
        createBackup: _FakeCreateBackup(_snapshot()),
        deviceFileService: deviceFileService,
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Export backup'));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't create the backup"), findsOneWidget);
  });

  testWidgets('importing a valid backup restores it and confirms', (
    tester,
  ) async {
    final restoreBackup = _FakeRestoreBackup((
      restoredPlaylists: 1,
      restoredFavorites: 2,
      restoredHistoryEntries: 0,
      skippedTracks: 0,
    ));
    final snapshot = _snapshot();
    await tester.pumpWidget(
      _app(
        restoreBackup: restoreBackup,
        deviceFileService: FakeDeviceFileService()
          ..fileToPick = _encode(snapshot),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Restore backup'));
    await tester.pumpAndSettle();

    expect(restoreBackup.received, snapshot);
    expect(find.text('Backup restored'), findsOneWidget);
  });

  testWidgets('mentions skipped tracks when some could not be resolved', (
    tester,
  ) async {
    final restoreBackup = _FakeRestoreBackup((
      restoredPlaylists: 1,
      restoredFavorites: 0,
      restoredHistoryEntries: 0,
      skippedTracks: 2,
    ));
    await tester.pumpWidget(
      _app(
        restoreBackup: restoreBackup,
        deviceFileService: FakeDeviceFileService()
          ..fileToPick = _encode(_snapshot()),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Restore backup'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        "Backup restored. 2 tracks weren't found — rescan your library "
        'and try again.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('does nothing when the user cancels picking a file', (
    tester,
  ) async {
    final restoreBackup = _FakeRestoreBackup((
      restoredPlaylists: 0,
      restoredFavorites: 0,
      restoredHistoryEntries: 0,
      skippedTracks: 0,
    ));
    await tester.pumpWidget(_app(restoreBackup: restoreBackup));
    await tester.pump();

    await tester.tap(find.text('Restore backup'));
    await tester.pumpAndSettle();

    expect(restoreBackup.received, isNull);
  });

  testWidgets('rejects a backup made with an unsupported format version', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        deviceFileService: FakeDeviceFileService()
          ..fileToPick = _encode(_snapshot(formatVersion: 999)),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Restore backup'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        "This backup was made with a different app version and can't be "
        'restored.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('shows an error toast for a corrupted backup file', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        deviceFileService: FakeDeviceFileService()
          ..fileToPick = Uint8List.fromList(utf8.encode('not json')),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Restore backup'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        "Couldn't restore this backup. Make sure the file is a valid "
        'backup.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('exporting a database backup saves it and confirms', (
    tester,
  ) async {
    final bytes = _sqliteBytes();
    final deviceFileService = FakeDeviceFileService();
    await tester.pumpWidget(
      _app(
        createDatabaseBackup: _FakeCreateDatabaseBackup(bytes),
        deviceFileService: deviceFileService,
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Export database'));
    await tester.pumpAndSettle();

    expect(deviceFileService.savedBytes, bytes);
    expect(find.text('Database backup saved'), findsOneWidget);
  });

  testWidgets('cancelling the restore confirmation does nothing', (
    tester,
  ) async {
    final deviceFileService = FakeDeviceFileService()
      ..fileToPick = _sqliteBytes();
    await tester.pumpWidget(_app(deviceFileService: deviceFileService));
    await tester.pump();

    await tester.tap(find.text('Restore database'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(deviceFileService.savedBytes, isNull);
    expect(find.text('Restore database?'), findsNothing);
  });

  testWidgets('rejects a file that is not a database backup', (tester) async {
    final restoreDatabaseBackup = _FakeRestoreDatabaseBackup();
    await tester.pumpWidget(
      _app(
        restoreDatabaseBackup: restoreDatabaseBackup,
        deviceFileService: FakeDeviceFileService()
          ..fileToPick = Uint8List.fromList(utf8.encode('not a database')),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Restore database'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Restore'));
    await tester.pumpAndSettle();

    expect(restoreDatabaseBackup.received, isNull);
    expect(find.text("This file isn't a database backup."), findsOneWidget);
  });

  testWidgets('shows an error toast when the database restore fails', (
    tester,
  ) async {
    final restoreDatabaseBackup = _FakeRestoreDatabaseBackup(
      shouldThrow: true,
    );
    await tester.pumpWidget(
      _app(
        restoreDatabaseBackup: restoreDatabaseBackup,
        deviceFileService: FakeDeviceFileService()..fileToPick = _sqliteBytes(),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Restore database'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Restore'));
    await tester.pump();

    expect(
      find.text("Couldn't restore this database backup."),
      findsOneWidget,
    );
    // Lets the toast's on-screen delay elapse before the test ends, so the
    // pending restart timer doesn't fire after the widget tree is torn
    // down.
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });

  testWidgets('restoring a valid database backup restarts the app', (
    tester,
  ) async {
    final bytes = _sqliteBytes();
    final restoreDatabaseBackup = _FakeRestoreDatabaseBackup();
    await tester.pumpWidget(
      _app(
        restoreDatabaseBackup: restoreDatabaseBackup,
        deviceFileService: FakeDeviceFileService()..fileToPick = bytes,
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Restore database'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Restore'));
    await tester.pumpAndSettle();

    expect(restoreDatabaseBackup.received, bytes);
    expect(find.text("This file isn't a database backup."), findsNothing);
    expect(find.text("Couldn't restore this database backup."), findsNothing);
  });

  testWidgets('reports a database restore whose close fails', (tester) async {
    final restoreDatabaseBackup = _FakeRestoreDatabaseBackup();
    await tester.pumpWidget(
      _app(
        database: _UnclosableDatabase(),
        restoreDatabaseBackup: restoreDatabaseBackup,
        deviceFileService: FakeDeviceFileService()..fileToPick = _sqliteBytes(),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Restore database'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Restore'));
    await tester.pump();

    expect(
      find.text("Couldn't restore this database backup."),
      findsOneWidget,
    );
    expect(restoreDatabaseBackup.received, isNull);

    // Lets the toast's on-screen delay elapse before the test ends, so the
    // pending restart timer doesn't fire after the widget tree is torn
    // down.
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });

  testWidgets('shows a progress bar while a rescan runs', (tester) async {
    final libraryRepository = _FakeLibraryRepository(
      tracks: [_track('a', filePath: '/music/rock/a.mp3')],
    )..reindexGate = Completer<void>();

    await tester.pumpWidget(_app(libraryRepository: libraryRepository));
    await tester.pump();
    expect(find.byType(LinearProgressIndicator), findsNothing);

    await tester.tap(find.byType(AppSwitch));
    await tester.pump();

    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    libraryRepository.reindexGate!.complete();
    await tester.pumpAndSettle();

    expect(find.byType(LinearProgressIndicator), findsNothing);
  });
}
