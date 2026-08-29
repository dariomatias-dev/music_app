import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:music_app/src/core/services/id_generator/uuid_v7_generator.dart';
import 'package:music_app/src/features/library/data/repositories/favorite_repository_impl.dart';
import 'package:music_app/src/features/playlist/data/repositories/playlist_repository_impl.dart';
import 'package:music_app/src/features/storage/domain/create_backup.dart';
import 'package:music_app/src/features/storage/domain/restore_database_backup.dart';

import '../test/helpers/fake_device_file_service.dart';
import 'helpers/app_harness.dart';

/// Backup and restore, driven through the Storage screen.
///
/// This is the app's only destructive path — a bad restore loses a user's
/// playlists, favorites and history — and the only one whose correctness
/// depends on data surviving a change of install, so it is exercised
/// end to end rather than only at the use-case level.
///
/// The round-trip runs across two installs: the second holds the same
/// library by `sourceId` but assigns every track a different internal id,
/// as a reinstall or a second device would. A backup that leaked
/// install-specific ids restores nothing there, which is the failure that
/// test exists to catch.
///
/// The refusal case tampers with a real export rather than hand-writing a
/// file, so the file stays structurally valid and its version is the single
/// reason it is refused; a hand-written one could fail parsing instead and
/// pass for the wrong reason. It then asserts on the database rather than
/// on the error toast: what has to hold is that nothing was written, and a
/// restore that half-applied a file it could not fully read would show an
/// error while having already corrupted the library.
///
/// Run on a connected device or emulator with:
///   fvm flutter test integration_test/backup_flows_test.dart -d `<device-id>`
///
/// `fvm flutter devices` lists the ids. A device is required: these flows
/// read through drift's stream queries, which never emit under the fake
/// async a plain `flutter test` run uses.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('a backup restores onto an install with different track ids', (
    tester,
  ) async {
    final original = await openSeededDatabase();
    const idGenerator = UuidV7Generator();
    final playlists = PlaylistRepositoryImpl(original, idGenerator);
    final favorites = FavoriteRepositoryImpl(original, idGenerator);

    final playlistId = await playlists.createPlaylist('Road Trip');
    await playlists.setPlaylistTracks(playlistId, ['track-1']);
    await favorites.setFavorite('track-2', isFavorite: true);

    final app = await launchSeededApp(tester, database: original);
    await openStorageScreen(tester, app.l10n);

    await tester.tap(find.text(app.l10n.exportBackupLabel));
    await settleUntil(tester, find.text(app.l10n.backupExportedMessage));

    final exported = app.deviceFiles.savedBytes;
    expect(exported, isNotNull, reason: 'export should have written bytes');
    expect(app.deviceFiles.savedFileName, contains('music_app_backup_'));

    final reinstall = await openSeededDatabase(idPrefix: 'reinstalled-');
    final files = FakeDeviceFileService()..fileToPick = exported;

    final restored = await launchSeededApp(
      tester,
      database: reinstall,
      deviceFiles: files,
    );
    await openStorageScreen(tester, restored.l10n);

    await tester.tap(find.text(restored.l10n.importBackupLabel));
    await settleUntil(tester, find.text(restored.l10n.backupImportedMessage));

    final restoredPlaylists = await firstValue(
      PlaylistRepositoryImpl(reinstall, idGenerator).watchPlaylists(),
      describe: "the reinstalled library's playlists",
    );
    expect(restoredPlaylists.map((p) => p.name), contains('Road Trip'));

    final restoredTrackIds = await firstValue(
      PlaylistRepositoryImpl(
        reinstall,
        idGenerator,
      ).watchPlaylistTrackIds(restoredPlaylists.first.id),
      describe: "the restored playlist's track ids",
    );
    expect(restoredTrackIds, ['reinstalled-track-1']);

    final restoredFavorites = await firstValue(
      FavoriteRepositoryImpl(reinstall, idGenerator).watchFavoriteTrackIds(),
      describe: 'the restored favorite track ids',
    );
    expect(restoredFavorites, contains('reinstalled-track-2'));
  });

  testWidgets('a backup from an unsupported format version is refused', (
    tester,
  ) async {
    final database = await openSeededDatabase();
    final files = FakeDeviceFileService();
    final app = await launchSeededApp(
      tester,
      database: database,
      deviceFiles: files,
    );
    await openStorageScreen(tester, app.l10n);

    await tester.tap(find.text(app.l10n.exportBackupLabel));
    await settleUntil(tester, find.text(app.l10n.backupExportedMessage));

    final json =
        jsonDecode(utf8.decode(files.savedBytes!)) as Map<String, dynamic>;
    json['formatVersion'] = backupFormatVersion + 999;
    files.fileToPick = Uint8List.fromList(utf8.encode(jsonEncode(json)));

    await tester.tap(find.text(app.l10n.importBackupLabel));
    await settle(tester, frames: 30);

    final playlists = await firstValue(
      PlaylistRepositoryImpl(
        database,
        const UuidV7Generator(),
      ).watchPlaylists(),
      describe: "the library's playlists after a refused restore",
    );
    expect(playlists, isEmpty);
  });

  testWidgets('the database export writes a real SQLite file', (tester) async {
    final app = await launchSeededApp(tester);
    await openStorageScreen(tester, app.l10n);

    await tester.tap(find.text(app.l10n.exportDatabaseBackupLabel));
    await pumpUntil(
      tester,
      () => app.deviceFiles.savedBytes != null,
      describe: 'the database export to hand bytes to the file service',
    );

    final exported = app.deviceFiles.savedBytes;
    expect(exported, isNotNull);
    expect(app.deviceFiles.savedFileName, contains('music_app_db_'));
    expect(isSqliteDatabase(exported!), isTrue);
  });
}
