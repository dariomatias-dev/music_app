import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/permissions/notification_permission_service.dart';
import 'package:music_app/src/core/permissions/permission_providers.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/settings/data/providers/app_info_provider.dart';
import 'package:music_app/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../helpers/fake_key_value_storage.dart';
import '../../../../helpers/fake_notification_permission_service.dart';

class _FakeLibraryRepository implements LibraryRepository {
  int reindexCalls = 0;
  bool reindexShouldThrow = false;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(const []);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const []);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const []);

  @override
  Stream<IndexingProgress> reindex() {
    reindexCalls++;
    if (reindexShouldThrow) return Stream.error(Exception('scan boom'));
    return const Stream.empty();
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
  Future<void> clearArtworkCache() async {}
}

Widget _app({
  FakeKeyValueStorage? storage,
  LibraryRepository? libraryRepository,
  PackageInfo? packageInfo,
  FakeNotificationPermissionService? notificationPermissionService,
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: SettingsScreen()),
      ),
      GoRoute(
        name: 'onboarding',
        path: '/onboarding',
        builder: (context, state) =>
            const Scaffold(body: Text('Onboarding screen reached')),
      ),
      GoRoute(
        name: 'storage',
        path: '/storage',
        builder: (context, state) =>
            const Scaffold(body: Text('Storage screen reached')),
      ),
      GoRoute(
        name: 'statistics',
        path: '/statistics',
        builder: (context, state) =>
            const Scaffold(body: Text('Statistics screen reached')),
      ),
      GoRoute(
        name: 'about',
        path: '/about',
        builder: (context, state) =>
            const Scaffold(body: Text('About screen reached')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      keyValueStorageProvider.overrideWithValue(
        storage ?? FakeKeyValueStorage(),
      ),
      libraryRepositoryProvider.overrideWithValue(
        libraryRepository ?? _FakeLibraryRepository(),
      ),
      notificationPermissionServiceProvider.overrideWithValue(
        notificationPermissionService ?? FakeNotificationPermissionService(),
      ),
      if (packageInfo != null)
        appInfoProvider.overrideWith((ref) async => packageInfo),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

void main() {
  setUp(() {
    // The default 800x600 test surface leaves the last rows a few pixels
    // short now that rows have more generous padding.
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
          ..physicalSize = const Size(800, 1000)
          ..devicePixelRatio = 1;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  });

  testWidgets('leaves the notification row out while it is allowed', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.text('Playback notification'), findsNothing);
  });

  testWidgets('leaves the notification row out where it does not apply', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        notificationPermissionService: FakeNotificationPermissionService(
          status: NotificationPermissionStatus.notApplicable,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Playback notification'), findsNothing);
  });

  testWidgets('reports blocked notifications and asks again on tap', (
    tester,
  ) async {
    final service = FakeNotificationPermissionService(
      status: NotificationPermissionStatus.denied,
      requestedStatus: NotificationPermissionStatus.granted,
    );

    await tester.pumpWidget(_app(notificationPermissionService: service));
    await tester.pump();

    expect(find.text('Playback notification'), findsOneWidget);
    expect(find.text('Blocked'), findsOneWidget);

    await tester.tap(find.text('Playback notification'));
    await tester.pump();

    expect(service.requestCalls, 1);
    expect(find.text('Playback notification'), findsNothing);
  });

  testWidgets('sends the user to the system settings once denied for good', (
    tester,
  ) async {
    final service = FakeNotificationPermissionService(
      status: NotificationPermissionStatus.permanentlyDenied,
    );

    await tester.pumpWidget(_app(notificationPermissionService: service));
    await tester.pump();

    await tester.tap(find.text('Playback notification'));
    await tester.pump();

    expect(service.openSettingsCalls, 1);
    expect(service.requestCalls, 0);
  });

  testWidgets('shows every section title', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });

  testWidgets(
    'shows a placeholder name, light theme and system language by default',
    (tester) async {
      await tester.pumpWidget(_app());
      await tester.pump();

      expect(find.text('Not set'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('System default'), findsOneWidget);
    },
  );

  testWidgets('shows the stored display name', (tester) async {
    final storage = FakeKeyValueStorage();
    await storage.setString('userDisplayName', 'Dário');

    await tester.pumpWidget(_app(storage: storage));
    await tester.pump();

    expect(find.text('Dário'), findsOneWidget);
  });

  testWidgets('editing the name saves it and updates the row', (
    tester,
  ) async {
    final storage = FakeKeyValueStorage();
    await tester.pumpWidget(_app(storage: storage));
    await tester.pump();

    await tester.tap(find.text('Not set'));
    await tester.pumpAndSettle();

    expect(find.text('Your name'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Dário');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Dário'), findsOneWidget);
    expect(await storage.getString('userDisplayName'), 'Dário');
  });

  testWidgets('clearing the name in the sheet removes it', (tester) async {
    final storage = FakeKeyValueStorage();
    await storage.setString('userDisplayName', 'Dário');
    await tester.pumpWidget(_app(storage: storage));
    await tester.pump();

    await tester.tap(find.text('Dário'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Not set'), findsOneWidget);
    expect(await storage.getString('userDisplayName'), isNull);
  });

  testWidgets('tapping Appearance toggles the theme directly', (
    tester,
  ) async {
    final storage = FakeKeyValueStorage();
    await tester.pumpWidget(_app(storage: storage));
    await tester.pump();

    await tester.tap(find.text('Light'));
    await tester.pump();

    expect(find.text('Dark'), findsOneWidget);
    expect(await storage.getString('themeMode'), 'dark');

    await tester.tap(find.text('Dark'));
    await tester.pump();

    expect(find.text('Light'), findsOneWidget);
    expect(await storage.getString('themeMode'), 'light');
  });

  testWidgets('tapping Language opens the language sheet', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();

    expect(find.text('System default'), findsWidgets);
    expect(find.text('English'), findsOneWidget);
  });

  testWidgets('tapping the playback row opens the playback sheet', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    await tester.tap(find.text('Gapless, crossfade & speed'));
    await tester.pumpAndSettle();

    expect(find.text('Gapless playback'), findsOneWidget);
    expect(find.text('Haptic feedback'), findsOneWidget);
  });

  testWidgets('tapping Storage opens the storage route', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    await tester.tap(find.text('Storage'));
    await tester.pumpAndSettle();

    expect(find.text('Storage screen reached'), findsOneWidget);
  });

  testWidgets('tapping Statistics opens the statistics route', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    await tester.tap(find.text('Statistics'));
    await tester.pumpAndSettle();

    expect(find.text('Statistics screen reached'), findsOneWidget);
  });

  testWidgets('tapping the about row opens the about route', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    await tester.tap(find.text('App info & version'));
    await tester.pumpAndSettle();

    expect(find.text('About screen reached'), findsOneWidget);
  });

  testWidgets('replaying onboarding resets it and navigates there', (
    tester,
  ) async {
    final storage = FakeKeyValueStorage();
    await storage.setBool('onboardingCompleted', value: true);
    await tester.pumpWidget(_app(storage: storage));
    await tester.pump();

    await tester.tap(find.text('Show onboarding again'));
    await tester.pumpAndSettle();

    expect(find.text('Onboarding screen reached'), findsOneWidget);
    expect(await storage.getBool('onboardingCompleted'), isFalse);
  });

  testWidgets('tapping Rescan library triggers a reindex', (tester) async {
    final libraryRepository = _FakeLibraryRepository();
    await tester.pumpWidget(_app(libraryRepository: libraryRepository));
    await tester.pump();

    await tester.tap(find.text('Rescan library'));
    await tester.pumpAndSettle();

    expect(libraryRepository.reindexCalls, 1);
    expect(find.text('Library rescanned'), findsOneWidget);
  });

  testWidgets('shows an error toast and clears busy when rescan fails', (
    tester,
  ) async {
    final libraryRepository = _FakeLibraryRepository()
      ..reindexShouldThrow = true;
    await tester.pumpWidget(_app(libraryRepository: libraryRepository));
    await tester.pump();

    await tester.tap(find.text('Rescan library'));
    await tester.pumpAndSettle();

    expect(
      find.text('Something went wrong while scanning your music library.'),
      findsOneWidget,
    );

    // Not stuck busy: a second tap reaches the repository again.
    await tester.tap(find.text('Rescan library'));
    await tester.pumpAndSettle();
    expect(libraryRepository.reindexCalls, 2);
  });

  testWidgets('shows the app name alone until the version is known', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('Music App'), findsOneWidget);
  });

  testWidgets('appends the version once package info resolves', (tester) async {
    await tester.pumpWidget(
      _app(
        packageInfo: PackageInfo(
          appName: 'Music App',
          packageName: 'dev.dariomatias.music_app',
          version: '1.2.3',
          buildNumber: '7',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Music App 1.2.3'), findsOneWidget);
  });

  testWidgets('names the chosen language instead of the system default', (
    tester,
  ) async {
    final storage = FakeKeyValueStorage();
    await storage.setString('locale', 'es');

    await tester.pumpWidget(_app(storage: storage));
    await tester.pumpAndSettle();

    expect(find.text('System default'), findsNothing);
    expect(find.text('Espa\u00f1ol'), findsOneWidget);
  });
}
