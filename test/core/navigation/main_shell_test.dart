import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/navigation/main_shell.dart';
import 'package:music_app/src/features/player/presentation/widgets/mini_player.dart';

import '../../helpers/fake_audio_player_service.dart';

/// A shell route shaped like the app's: four branches, each with a root
/// screen, and Home carrying a detail route to push onto its own stack.
GoRouter _router() {
  GoRoute root(String path, String label) => GoRoute(
    path: path,
    builder: (context, state) => Scaffold(body: Text('$label screen')),
  );

  return GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) =>
                    const Scaffold(body: Text('Home screen')),
                routes: [
                  GoRoute(
                    path: 'detail',
                    builder: (context, state) =>
                        const Scaffold(body: Text('Home detail')),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(routes: [root('/search', 'Search')]),
          StatefulShellBranch(routes: [root('/library', 'Library')]),
          StatefulShellBranch(routes: [root('/settings', 'Settings')]),
        ],
      ),
    ],
  );
}

Future<GoRouter> _pumpShell(WidgetTester tester) async {
  final router = _router();
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        audioPlayerServiceProvider.overrideWithValue(FakeAudioPlayerService()),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

void main() {
  testWidgets('shows the four main tabs', (tester) async {
    await _pumpShell(tester);

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('starts on the first branch', (tester) async {
    await _pumpShell(tester);

    expect(find.text('Home screen'), findsOneWidget);
    expect(
      tester.widget<AppNavigationBar>(find.byType(AppNavigationBar)).index,
      0,
    );
  });

  testWidgets('tapping a tab switches to its branch', (tester) async {
    await _pumpShell(tester);

    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();

    expect(find.text('Library screen'), findsOneWidget);
    expect(
      tester.widget<AppNavigationBar>(find.byType(AppNavigationBar)).index,
      2,
    );
  });

  testWidgets('keeps a branch stack while another tab is visited', (
    tester,
  ) async {
    final router = await _pumpShell(tester);

    router.go('/home/detail');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Home detail'), findsOneWidget);
  });

  testWidgets('tapping the active tab returns it to its root', (tester) async {
    final router = await _pumpShell(tester);

    router.go('/home/detail');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Home detail'), findsNothing);
    expect(find.text('Home screen'), findsOneWidget);
  });

  testWidgets('hosts the mini player above the tabs', (tester) async {
    await _pumpShell(tester);

    expect(find.byType(MiniPlayer), findsOneWidget);
    expect(
      tester.getBottomLeft(find.byType(MiniPlayer)).dy,
      lessThanOrEqualTo(tester.getTopLeft(find.byType(AppNavigationBar)).dy),
    );
  });

  group('on a wide window', () {
    Future<void> setWideSurface(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('shows a navigation rail instead of the bottom bar', (
      tester,
    ) async {
      await setWideSurface(tester);
      await _pumpShell(tester);

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(AppNavigationBar), findsNothing);
      expect(find.byType(MiniPlayer), findsOneWidget);
    });

    testWidgets('tapping a rail destination switches to its branch', (
      tester,
    ) async {
      await setWideSurface(tester);
      await _pumpShell(tester);

      await tester.tap(find.text('Library'));
      await tester.pumpAndSettle();

      expect(find.text('Library screen'), findsOneWidget);
      expect(
        tester
            .widget<NavigationRail>(find.byType(NavigationRail))
            .selectedIndex,
        2,
      );
    });
  });
}
