import 'dart:async';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/core/constants/preference_keys.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/core/permissions/media_permission_service.dart';
import 'package:music_app/src/core/permissions/notification_permission_service.dart';
import 'package:music_app/src/core/permissions/permission_providers.dart';
import 'package:music_app/src/core/services/device_file/device_file_service_provider.dart';
import 'package:music_app/src/core/storage/shared_preferences_storage.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source_impl.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/music_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test/helpers/fake_audio_player_service.dart';
import '../../test/helpers/fake_device_file_service.dart';

/// Grants access immediately and never scans, so a launch lands straight on
/// Home instead of stopping at the permission screen or waiting on a real
/// device media store.
class FakeGrantedPermissionService implements MediaPermissionService {
  @override
  Future<MediaPermissionStatus> check() async => MediaPermissionStatus.granted;

  @override
  Future<MediaPermissionStatus> request() async =>
      MediaPermissionStatus.granted;

  @override
  Future<void> openSystemSettings() async {}
}

/// Reports notifications as allowed without reaching the platform, so a
/// launch never waits on a system prompt.
class FakeGrantedNotificationPermissionService
    implements NotificationPermissionService {
  @override
  Future<NotificationPermissionStatus> check() async =>
      NotificationPermissionStatus.granted;

  @override
  Future<NotificationPermissionStatus> request() async =>
      NotificationPermissionStatus.granted;

  @override
  Future<void> openSystemSettings() async {}
}

/// The library the flow tests are seeded with: one artist, one album, and
/// two tracks, which is the smallest set that still exercises ordering,
/// queues with more than one entry, and "the other track" assertions.
abstract final class SeedData {
  /// The seeded artist, credited on both tracks.
  static const artist = Artist(
    id: 'artist-1',
    sourceId: 'charcoal',
    name: 'Charcoal',
    albumCount: 1,
    trackCount: 2,
  );

  /// The seeded album, holding both tracks.
  static const album = Album(
    id: 'album-1',
    sourceId: 'charcoal::chill-vibes',
    title: 'Chill Vibes',
    artistId: 'artist-1',
    trackCount: 2,
    totalDuration: Duration(minutes: 8),
  );

  /// Title of the track the flows play first.
  static const firstTrackTitle = 'Night Drive';

  /// Title of the second track, used where a flow needs a track that is
  /// deliberately *not* the one playing.
  static const secondTrackTitle = 'Afterglow';

  /// Both seeded tracks, in the order the library lists them.
  static final List<Track> tracks = tracksForInstall();

  /// The same two tracks as a given install would hold them: [idPrefix]
  /// changes the internal ids while the `sourceId`s stay put.
  ///
  /// A backup keys everything by `sourceId` precisely so it can be restored
  /// onto an install that assigned different internal ids, so a round-trip
  /// test needs a second set that differs in exactly that way.
  static List<Track> tracksForInstall({String idPrefix = ''}) => [
    _track(
      id: '${idPrefix}track-1',
      sourceId: 'track-1',
      title: firstTrackTitle,
    ),
    _track(
      id: '${idPrefix}track-2',
      sourceId: 'track-2',
      title: secondTrackTitle,
    ),
  ];

  static Track _track({
    required String id,
    required String sourceId,
    required String title,
  }) {
    return Track(
      id: id,
      sourceId: sourceId,
      filePath: '/music/$id.mp3',
      title: title,
      artistId: artist.id,
      albumId: album.id,
      duration: const Duration(minutes: 4),
      format: 'mp3',
      fileSize: 1000,
      hasEmbeddedArtwork: false,
      dateAdded: DateTime.fromMillisecondsSinceEpoch(0),
      dateModified: DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}

/// A launched app, plus the seams a flow test needs to assert against.
typedef LaunchedApp = ({
  AppDatabase database,
  FakeAudioPlayerService player,
  FakeDeviceFileService deviceFiles,
  AppLocalizations l10n,
});

/// Opens an in-memory database holding [SeedData]'s library.
///
/// [idPrefix] varies the tracks' internal ids while leaving their
/// `sourceId`s alone, which is what a second install of the app looks like.
///
/// Drift's multiple-database warning is silenced here: a round-trip test
/// deliberately opens a second install's database, and each is its own
/// in-memory executor rather than the shared-executor race that warning is
/// meant to catch.
Future<AppDatabase> openSeededDatabase({String idPrefix = ''}) async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final database = AppDatabase(NativeDatabase.memory());
  final library = LibraryLocalDataSourceImpl(database);
  await library.upsertArtist(SeedData.artist);
  await library.upsertAlbum(SeedData.album);
  for (final track in SeedData.tracksForInstall(idPrefix: idPrefix)) {
    await library.upsertTrack(track);
  }
  return database;
}

/// Boots the real [MusicApp] over an in-memory database seeded with
/// [SeedData], past onboarding and with media access already granted, so a
/// test starts on Home with a populated library.
///
/// The database is in memory rather than file-backed: these flows assert on
/// what the UI does with the data, and a fresh database per test keeps them
/// independent of each other's writes. Flows that need data to survive a
/// reopen use a real file instead (see `app_flows_test.dart`).
///
/// [locale] is persisted before launch so label lookups match regardless of
/// the device's own system locale.
///
/// Any previous tree is torn down first. Pumping [MusicApp] over an
/// existing one *updates* it rather than replacing it — same widget type,
/// so the element, its router and its `ProviderScope` all survive — which
/// would leave a relaunch sitting on whatever route the previous app was
/// showing. An empty tree in between forces the teardown a fresh launch
/// implies.
///
/// Returns once the shell is up rather than after a fixed number of
/// frames: startup runs the splash screen and the router's redirect first,
/// and how long that takes varies by device.
Future<LaunchedApp> launchSeededApp(
  WidgetTester tester, {
  String locale = 'en',
  AppDatabase? database,
  FakeDeviceFileService? deviceFiles,
}) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();

  final db = database ?? await openSeededDatabase();
  addTearDown(db.close);

  final files = deviceFiles ?? FakeDeviceFileService();

  SharedPreferences.setMockInitialValues(const {});
  final storage = SharedPreferencesStorage(
    await SharedPreferences.getInstance(),
  );
  await storage.setBool(PreferenceKeys.onboardingCompleted, value: true);
  await storage.setString(PreferenceKeys.locale, locale);

  final player = FakeAudioPlayerService();
  final handler = MusicAudioHandler(player);
  addTearDown(handler.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        keyValueStorageProvider.overrideWithValue(storage),
        audioPlayerServiceProvider.overrideWithValue(player),
        audioHandlerProvider.overrideWithValue(handler),
        deviceFileServiceProvider.overrideWithValue(files),
        mediaPermissionServiceProvider.overrideWithValue(
          FakeGrantedPermissionService(),
        ),
        notificationPermissionServiceProvider.overrideWithValue(
          FakeGrantedNotificationPermissionService(),
        ),
      ],
      child: const MusicApp(),
    ),
  );
  final l10n = await AppLocalizations.delegate.load(Locale(locale));
  await settleUntil(tester, find.text(l10n.settingsTabLabel));

  return (
    database: db,
    player: player,
    deviceFiles: files,
    l10n: l10n,
  );
}

/// Pumps until [finder] matches something, or gives up after [timeout].
///
/// Preferred over a fixed number of frames wherever the wait is for real
/// work — a database read, a route settling, the app's own startup redirect
/// — since how long that takes varies by device and a fixed count either
/// flakes or wastes time.
Future<void> settleUntil(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 15),
}) {
  return pumpUntil(
    tester,
    () => finder.evaluate().isNotEmpty,
    describe: '$finder',
    timeout: timeout,
  );
}

/// Pumps until [condition] holds, or gives up after [timeout].
///
/// The counterpart to [settleUntil] for work that finishes somewhere other
/// than the widget tree — bytes handed to the device file service, or rows
/// written to the database.
///
/// Prefer this over waiting on a toast. A toast is transient, and CI runs
/// the emulator with animations disabled, so a wait on one passes on a
/// device and times out there. Wait on what the action produced instead.
Future<void> pumpUntil(
  WidgetTester tester,
  FutureOr<bool> Function() condition, {
  required String describe,
  Duration timeout = const Duration(seconds: 15),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (await condition()) return;
  }
  throw StateError('Timed out after $timeout waiting for: $describe');
}

/// Navigates from wherever the app is to Settings, then into Storage.
Future<void> openStorageScreen(
  WidgetTester tester,
  AppLocalizations l10n,
) async {
  await tester.tap(find.text(l10n.settingsTabLabel));
  await settleUntil(tester, find.text(l10n.storageLabel));
  await tester.tap(find.text(l10n.storageLabel));
  await settleUntil(tester, find.text(l10n.exportBackupLabel));
}

/// Reads the first value [stream] emits, failing with [describe] rather
/// than waiting forever if it emits nothing.
///
/// A bare `.first` on a drift stream query has no upper bound: if the query
/// never emits, the test hangs until the CI job's own timeout kills it,
/// with no output naming the read that stalled.
Future<T> firstValue<T>(
  Stream<T> stream, {
  required String describe,
  Duration timeout = const Duration(seconds: 20),
}) {
  return stream.first.timeout(
    timeout,
    onTimeout: () => throw StateError(
      'Timed out after $timeout waiting for the first value of: $describe',
    ),
  );
}

/// Loads the app's strings for [locale], for tests that assert against a
/// language other than the one they launched in.
Future<AppLocalizations> appLocalizations(String locale) =>
    AppLocalizations.delegate.load(Locale(locale));

/// Advances a fixed number of frames, letting transitions and pending
/// futures land.
///
/// [WidgetTester.pumpAndSettle] is deliberately not used anywhere in these
/// flows: once a track is playing, the now-playing indicator animates on a
/// loop, so the tree never goes idle and the call times out rather than
/// returning. A bounded pump behaves the same either way.
Future<void> settle(WidgetTester tester, {int frames = 12}) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
