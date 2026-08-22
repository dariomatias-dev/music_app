import 'package:app_ui/app_ui.dart';
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
import 'package:music_app/src/core/navigation/app_router.dart';
import 'package:music_app/src/core/navigation/main_shell.dart';
import 'package:music_app/src/core/navigation/not_found_screen.dart';
import 'package:music_app/src/core/permissions/media_permission_service.dart';
import 'package:music_app/src/core/permissions/permission_providers.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/home/presentation/screens/home_screen.dart';
import 'package:music_app/src/features/library/presentation/screens/album_screen.dart';
import 'package:music_app/src/features/library/presentation/screens/artist_screen.dart';
import 'package:music_app/src/features/library/presentation/screens/library_screen.dart';
import 'package:music_app/src/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:music_app/src/features/onboarding/presentation/screens/permission_screen.dart';
import 'package:music_app/src/features/player/presentation/screens/lyrics_screen.dart';
import 'package:music_app/src/features/player/presentation/screens/playback_screen.dart';
import 'package:music_app/src/features/playlist/presentation/screens/playlist_screen.dart';
import 'package:music_app/src/features/queue/presentation/screens/queue_screen.dart';
import 'package:music_app/src/features/search/presentation/screens/search_screen.dart';
import 'package:music_app/src/features/settings/presentation/screens/about_screen.dart';
import 'package:music_app/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:music_app/src/features/splash/presentation/screens/splash_screen.dart';
import 'package:music_app/src/features/statistics/presentation/screens/statistics_screen.dart';
import 'package:music_app/src/features/storage/presentation/screens/storage_screen.dart';

import '../../helpers/fake_audio_player_service.dart';
import '../../helpers/fake_key_value_storage.dart';

class _FakeMediaPermissionService implements MediaPermissionService {
  _FakeMediaPermissionService(this.status);

  final MediaPermissionStatus status;

  @override
  Future<MediaPermissionStatus> check() async => status;

  @override
  Future<MediaPermissionStatus> request() async => status;

  @override
  Future<void> openSystemSettings() async {}
}

/// Mounts the app's real router over an in-memory database, overriding only
/// the leaves that reach the platform.
///
/// Repositories and view models are the production ones, so a route that
/// points at the wrong screen, or a screen that cannot build from a cold
/// start, fails here.
Future<ProviderContainer> _pumpRouter(
  WidgetTester tester, {
  bool onboardingCompleted = true,
  MediaPermissionStatus permission = MediaPermissionStatus.granted,
  bool settle = true,
}) async {
  final database = AppDatabase(NativeDatabase.memory());
  addTearDown(database.close);

  final storage = FakeKeyValueStorage();
  if (onboardingCompleted) {
    await storage.setBool(PreferenceKeys.onboardingCompleted, value: true);
  }

  final service = FakeAudioPlayerService();
  final handler = MusicAudioHandler(service);
  addTearDown(handler.dispose);

  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
      keyValueStorageProvider.overrideWithValue(storage),
      mediaPermissionServiceProvider.overrideWithValue(
        _FakeMediaPermissionService(permission),
      ),
      audioPlayerServiceProvider.overrideWithValue(service),
      audioHandlerProvider.overrideWithValue(handler),
    ],
  );
  addTearDown(container.dispose);
  addTearDown(container.read(appRouterProvider).dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: container.read(appRouterProvider),
      ),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
  return container;
}

/// Navigates to [location] and settles the resulting screen.
Future<void> _goTo(
  WidgetTester tester,
  ProviderContainer container,
  String location,
) async {
  container.read(appRouterProvider).go(location);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('starts on the splash route', (tester) async {
    await _pumpRouter(tester, settle: false);

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pumpAndSettle();
  });

  testWidgets('the splash route hands off once it is ready', (tester) async {
    await _pumpRouter(tester);

    expect(find.byType(SplashScreen), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  group('shell branches', () {
    testWidgets('each tab route builds its screen inside the shell', (
      tester,
    ) async {
      final container = await _pumpRouter(tester);

      await _goTo(tester, container, const HomeRoute().location);
      expect(find.byType(MainShell), findsOneWidget);
      expect(find.byType(HomeScreen), findsOneWidget);

      await _goTo(tester, container, const SearchRoute().location);
      expect(find.byType(SearchScreen), findsOneWidget);

      await _goTo(tester, container, const LibraryRoute().location);
      expect(find.byType(LibraryScreen), findsOneWidget);

      await _goTo(tester, container, const SettingsRoute().location);
      expect(find.byType(SettingsScreen), findsOneWidget);
    });
  });

  group('detail routes', () {
    testWidgets('an album route builds the album screen', (tester) async {
      final container = await _pumpRouter(tester);

      await _goTo(
        tester,
        container,
        const AlbumRoute(albumId: 'album-1').location,
      );

      expect(find.byType(AlbumScreen), findsOneWidget);
    });

    testWidgets('an artist route builds the artist screen', (tester) async {
      final container = await _pumpRouter(tester);

      await _goTo(
        tester,
        container,
        const ArtistRoute(artistId: 'artist-1').location,
      );

      expect(find.byType(ArtistScreen), findsOneWidget);
    });

    testWidgets('a playlist route builds the playlist screen', (tester) async {
      final container = await _pumpRouter(tester);

      await _goTo(
        tester,
        container,
        const PlaylistRoute(playlistId: 'playlist-1').location,
      );

      expect(find.byType(PlaylistScreen), findsOneWidget);
    });

    testWidgets('the settings detail routes build their screens', (
      tester,
    ) async {
      final container = await _pumpRouter(tester);

      await _goTo(tester, container, const StorageRoute().location);
      expect(find.byType(StorageScreen), findsOneWidget);

      await _goTo(tester, container, const StatisticsRoute().location);
      expect(find.byType(StatisticsScreen), findsOneWidget);

      await _goTo(tester, container, const AboutRoute().location);
      expect(find.byType(AboutScreen), findsOneWidget);
    });
  });

  group('player routes', () {
    testWidgets('the player route builds the playback screen', (tester) async {
      final container = await _pumpRouter(tester);

      await _goTo(tester, container, const PlayerRoute().location);

      expect(find.byType(PlaybackScreen), findsOneWidget);
    });

    testWidgets('the nested routes build lyrics and queue', (tester) async {
      final container = await _pumpRouter(tester);

      await _goTo(tester, container, const LyricsRoute().location);
      expect(find.byType(LyricsScreen), findsOneWidget);

      await _goTo(tester, container, const QueueRoute().location);
      expect(find.byType(QueueScreen), findsOneWidget);
    });
  });

  group('redirects', () {
    testWidgets('sends an unfinished onboarding to its screen', (tester) async {
      final container = await _pumpRouter(tester, onboardingCompleted: false);

      await _goTo(tester, container, const HomeRoute().location);

      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets('sends a denied media permission to its screen', (
      tester,
    ) async {
      final container = await _pumpRouter(
        tester,
        permission: MediaPermissionStatus.denied,
      );

      await _goTo(tester, container, const HomeRoute().location);

      expect(find.byType(PermissionScreen), findsOneWidget);
    });

    testWidgets('sends a prepared user off onboarding and permissions', (
      tester,
    ) async {
      final container = await _pumpRouter(tester);

      await _goTo(tester, container, const OnboardingRoute().location);
      expect(find.byType(HomeScreen), findsOneWidget);

      await _goTo(tester, container, const PermissionsRoute().location);
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });

  testWidgets('an unknown location falls back to the not found screen', (
    tester,
  ) async {
    final container = await _pumpRouter(tester);

    await _goTo(tester, container, '/nowhere');

    expect(find.byType(NotFoundScreen), findsOneWidget);
  });
}
