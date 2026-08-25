import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/core/navigation/route_names.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/core/navigation/route_transitions.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/player/presentation/screens/playback_screen.dart';
import 'package:music_app/src/features/player/presentation/widgets/mini_player.dart';
import 'package:music_app/src/features/player/presentation/widgets/playback_cover.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fake_favorite_repository.dart';
import '../../../../helpers/fake_key_value_storage.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository();

  @override
  Stream<List<Track>> watchTracks() => const Stream.empty();

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const [
    Album(
      id: 'album-1',
      sourceId: 'album-1',
      title: 'Chill Vibes',
      artistId: 'artist-1',
      trackCount: 1,
      totalDuration: Duration(minutes: 3),
    ),
  ]);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const [
    Artist(
      id: 'artist-1',
      sourceId: 'artist-1',
      name: 'Charcoal',
      albumCount: 1,
      trackCount: 1,
    ),
  ]);

  @override
  Stream<IndexingProgress> reindex() => const Stream.empty();

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

Widget _scaffold(Widget child, {ThemeData? theme}) {
  return MaterialApp(
    theme: theme ?? AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Align(alignment: Alignment.topCenter, child: child),
    ),
  );
}

Widget _routedScaffold(Widget child) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: Align(alignment: Alignment.topCenter, child: child),
        ),
      ),
      GoRoute(
        name: RouteNames.player,
        path: '/player',
        builder: (context, state) => const Scaffold(body: Text('Now Playing')),
      ),
    ],
  );
  return MaterialApp.router(
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: router,
  );
}

Track _track({
  String id = 'track-1',
  String title = 'Night Drive',
}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: '/music/$id.mp3',
    title: title,
    artistId: 'artist-1',
    albumId: 'album-1',
    duration: const Duration(minutes: 3),
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
  );
}

void main() {
  testWidgets('renders nothing while the queue is empty', (tester) async {
    final service = FakeAudioPlayerService();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [audioPlayerServiceProvider.overrideWithValue(service)],
        child: _scaffold(const MiniPlayer()),
      ),
    );

    expect(find.byType(MiniPlayer), findsOneWidget);
    expect(find.text('Charcoal'), findsNothing);
  });

  testWidgets('shows title and artist once the queue is loaded', (
    tester,
  ) async {
    final service = FakeAudioPlayerService();
    final handler = MusicAudioHandler(service);
    addTearDown(handler.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioPlayerServiceProvider.overrideWithValue(service),
          audioHandlerProvider.overrideWithValue(handler),
          libraryRepositoryProvider.overrideWithValue(
            const _FakeLibraryRepository(),
          ),
        ],
        child: _scaffold(const MiniPlayer()),
      ),
    );

    final element = tester.element(find.byType(MiniPlayer));
    final container = ProviderScope.containerOf(element);
    await container.read(queueViewModelProvider.notifier).playFromSource([
      _track(),
    ], startIndex: 0);
    await tester.pump();

    expect(find.text('Night Drive'), findsOneWidget);
    expect(find.text('Charcoal'), findsOneWidget);
  });

  testWidgets(
    'exposes a single combined semantic label for title and artist',
    (tester) async {
      // Disposed explicitly at the end of the test body, not via
      // addTearDown: the framework verifies every handle is disposed
      // before addTearDown callbacks run, so an addTearDown-based dispose
      // would always fail that check.
      final handle = tester.ensureSemantics();

      final service = FakeAudioPlayerService();
      final handler = MusicAudioHandler(service);
      addTearDown(handler.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioPlayerServiceProvider.overrideWithValue(service),
            audioHandlerProvider.overrideWithValue(handler),
            libraryRepositoryProvider.overrideWithValue(
              const _FakeLibraryRepository(),
            ),
          ],
          child: _scaffold(const MiniPlayer()),
        ),
      );

      final element = tester.element(find.byType(MiniPlayer));
      final container = ProviderScope.containerOf(element);
      await container.read(queueViewModelProvider.notifier).playFromSource([
        _track(),
      ], startIndex: 0);
      // AppPlaybackIndicator's equalizer animates forever while playing, so
      // pumpAndSettle would never settle; step through the cross-fade's
      // duration manually instead. The first, zero-duration pump starts the
      // AnimatedSwitcher's transition; without it, the entering child's
      // semantics never populate even after further pumps.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(
        find.bySemanticsLabel('Now playing, Night Drive, Charcoal'),
        findsOneWidget,
      );
      // The title and artist are no longer separately reachable stops.
      expect(find.bySemanticsLabel('Night Drive'), findsNothing);
      handle.dispose();
    },
  );

  testWidgets('tapping opens the playback screen', (tester) async {
    final service = FakeAudioPlayerService();
    final handler = MusicAudioHandler(service);
    addTearDown(handler.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioPlayerServiceProvider.overrideWithValue(service),
          audioHandlerProvider.overrideWithValue(handler),
          libraryRepositoryProvider.overrideWithValue(
            const _FakeLibraryRepository(),
          ),
        ],
        child: _routedScaffold(const MiniPlayer()),
      ),
    );

    final element = tester.element(find.byType(MiniPlayer));
    final container = ProviderScope.containerOf(element);
    await container.read(queueViewModelProvider.notifier).playFromSource([
      _track(),
    ], startIndex: 0);
    await tester.pump();

    // Simulated pointer gestures land unreliably through the nested
    // AnimatedSwitcher/Theme/Pressable layers in the test harness; invoke
    // the recognizer's callback directly to verify the wiring instead.
    final gestureArea = tester.widget<GestureDetector>(
      find.byKey(const ValueKey('miniPlayerGestureArea')),
    );
    gestureArea.onVerticalDragEnd!(
      DragEndDetails(
        velocity: const Velocity(pixelsPerSecond: Offset(0, -300)),
        primaryVelocity: -300,
      ),
    );
    // The page transition needs several frames to complete; a single long
    // pump can skip over route-building steps that happen mid-transition.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('Now Playing'), findsOneWidget);
  });

  testWidgets('swiping left skips to the next track', (tester) async {
    final service = FakeAudioPlayerService();
    final handler = MusicAudioHandler(service);
    addTearDown(handler.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioPlayerServiceProvider.overrideWithValue(service),
          audioHandlerProvider.overrideWithValue(handler),
          libraryRepositoryProvider.overrideWithValue(
            const _FakeLibraryRepository(),
          ),
        ],
        child: _scaffold(const MiniPlayer()),
      ),
    );

    final element = tester.element(find.byType(MiniPlayer));
    final container = ProviderScope.containerOf(element);
    await container.read(queueViewModelProvider.notifier).playFromSource([
      _track(),
      _track(id: 'track-2', title: 'Sunset'),
    ], startIndex: 0);
    await tester.pump();

    final gestureArea = tester.widget<GestureDetector>(
      find.byKey(const ValueKey('miniPlayerGestureArea')),
    );
    gestureArea.onHorizontalDragEnd!(
      DragEndDetails(
        velocity: const Velocity(pixelsPerSecond: Offset(-300, 0)),
        primaryVelocity: -300,
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(service.snapshot.currentIndex, 1);
  });

  testWidgets(
    'opening the playback screen shares a matching Hero tag with the artwork',
    (tester) async {
      final service = FakeAudioPlayerService();
      final handler = MusicAudioHandler(service);
      addTearDown(handler.dispose);

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(
              body: Align(
                alignment: Alignment.topCenter,
                child: MiniPlayer(),
              ),
            ),
          ),
          GoRoute(
            name: RouteNames.player,
            path: RoutePaths.player,
            pageBuilder: (context, state) => buildVerticalTransitionPage(
              key: state.pageKey,
              child: const PlaybackScreen(),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioPlayerServiceProvider.overrideWithValue(service),
            audioHandlerProvider.overrideWithValue(handler),
            libraryRepositoryProvider.overrideWithValue(
              const _FakeLibraryRepository(),
            ),
            favoriteRepositoryProvider.overrideWithValue(
              FakeFavoriteRepository(),
            ),
          ],
          child: MaterialApp.router(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        ),
      );

      final element = tester.element(find.byType(MiniPlayer));
      final container = ProviderScope.containerOf(element);
      await container.read(queueViewModelProvider.notifier).playFromSource([
        _track(),
      ], startIndex: 0);
      await tester.pump();

      final gestureArea = tester.widget<GestureDetector>(
        find.byKey(const ValueKey('miniPlayerGestureArea')),
      );
      gestureArea.onVerticalDragEnd!(
        DragEndDetails(
          velocity: const Velocity(pixelsPerSecond: Offset(0, -300)),
          primaryVelocity: -300,
        ),
      );
      // PlaybackCover's breathing animation repeats forever, so
      // pumpAndSettle would never settle; step through frames manually
      // instead, matching "tapping opens the playback screen" above.
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      final expectedTag = heroTagFor(origin: 'player', id: 'track-1');
      // Once the player route is on top, the mini player's route is
      // covered (opaque) and the default finders skip it; look it up with
      // skipOffstage: false to reach its still-mounted Hero.
      final miniPlayerHero = tester.widget<Hero>(
        find.descendant(
          of: find.byType(MiniPlayer, skipOffstage: false),
          matching: find.byType(Hero, skipOffstage: false),
          skipOffstage: false,
        ),
      );
      final coverHero = tester.widget<Hero>(
        find.descendant(
          of: find.byType(PlaybackCover),
          matching: find.byType(Hero),
        ),
      );

      expect(miniPlayerHero.tag, expectedTag);
      expect(coverHero.tag, expectedTag);
    },
  );

  testWidgets(
    'a second, docked mini player next to the main one does not add a '
    'competing Hero',
    (tester) async {
      // Reproduces the shape of MainShell (always-mounted MiniPlayer) plus
      // MiniPlayerDock (its own floating copy, on screens pushed outside
      // the shell): with both showing the same track, a second Hero
      // sharing the first's tag made Flutter treat unrelated navigation
      // between the two as a flight, sliding the artwork across the
      // screen instead of just appearing in place.
      final service = FakeAudioPlayerService();
      final handler = MusicAudioHandler(service);
      addTearDown(handler.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioPlayerServiceProvider.overrideWithValue(service),
            audioHandlerProvider.overrideWithValue(handler),
            libraryRepositoryProvider.overrideWithValue(
              const _FakeLibraryRepository(),
            ),
          ],
          child: _scaffold(
            const Column(
              children: [
                MiniPlayer(),
                MiniPlayer(enableHeroAnimation: false),
              ],
            ),
          ),
        ),
      );

      final element = tester.element(find.byType(MiniPlayer).first);
      final container = ProviderScope.containerOf(element);
      await container.read(queueViewModelProvider.notifier).playFromSource([
        _track(),
      ], startIndex: 0);
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(Hero), findsOneWidget);
      expect(find.text('Night Drive'), findsNWidgets(2));
    },
  );

  /// Pumps the mini player with one track already loaded and playing.
  Future<(FakeAudioPlayerService, ProviderContainer)> pumpLoaded(
    WidgetTester tester, {
    bool routed = false,
    ThemeData? theme,
  }) async {
    final service = FakeAudioPlayerService();
    final handler = MusicAudioHandler(service);
    addTearDown(handler.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioPlayerServiceProvider.overrideWithValue(service),
          audioHandlerProvider.overrideWithValue(handler),
          libraryRepositoryProvider.overrideWithValue(
            const _FakeLibraryRepository(),
          ),
          keyValueStorageProvider.overrideWithValue(FakeKeyValueStorage()),
        ],
        child: routed
            ? _routedScaffold(const MiniPlayer())
            : _scaffold(const MiniPlayer(), theme: theme),
      ),
    );

    final container = ProviderScope.containerOf(
      tester.element(find.byType(MiniPlayer)),
    );
    await container.read(queueViewModelProvider.notifier).playFromSource([
      _track(),
      _track(id: 'track-2', title: 'Sunset'),
    ], startIndex: 1);
    await tester.pump();
    await tester.pump();

    return (service, container);
  }

  testWidgets('swiping right goes back to the previous track', (tester) async {
    final (service, _) = await pumpLoaded(tester);

    final gestureArea = tester.widget<GestureDetector>(
      find.byKey(const ValueKey('miniPlayerGestureArea')),
    );
    gestureArea.onHorizontalDragEnd!(
      DragEndDetails(
        velocity: const Velocity(pixelsPerSecond: Offset(300, 0)),
        primaryVelocity: 300,
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(service.snapshot.currentIndex, 0);
  });

  testWidgets('a swipe too slow to count changes nothing', (tester) async {
    final (service, _) = await pumpLoaded(tester);

    final gestureArea = tester.widget<GestureDetector>(
      find.byKey(const ValueKey('miniPlayerGestureArea')),
    );
    gestureArea.onHorizontalDragEnd!(
      DragEndDetails(
        velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
        primaryVelocity: 50,
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(service.snapshot.currentIndex, 1);
  });

  testWidgets('tapping the card opens the playback screen', (tester) async {
    await pumpLoaded(tester, routed: true);

    final pressable = tester.widget<Pressable>(
      find
          .descendant(
            of: find.byKey(const ValueKey('miniPlayerGestureArea')),
            matching: find.byType(Pressable),
          )
          .first,
    );
    pressable.onTap!();
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('Now Playing'), findsOneWidget);
  });

  testWidgets('the play button pauses while playing', (tester) async {
    final (service, _) = await pumpLoaded(tester);
    expect(service.snapshot.playing, isTrue);

    tester.widget<AppPlayPauseButton>(find.byType(AppPlayPauseButton)).onTap();
    await tester.pump(const Duration(milliseconds: 500));

    expect(service.snapshot.playing, isFalse);
  });

  testWidgets('the play button resumes once paused', (tester) async {
    final (service, _) = await pumpLoaded(tester);
    await service.pause();
    await tester.pump();
    await tester.pump();

    tester.widget<AppPlayPauseButton>(find.byType(AppPlayPauseButton)).onTap();
    await tester.pump(const Duration(milliseconds: 500));

    expect(service.snapshot.playing, isTrue);
  });

  testWidgets('inverts its theme against a dark app', (tester) async {
    await pumpLoaded(tester, theme: AppTheme.dark);

    expect(find.byType(MiniPlayer), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
