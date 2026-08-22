import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/src/core/navigation/navigators/main_shell_navigator.dart';

/// A shell shaped like the app's, whose Home branch can jump to Search.
GoRouter _router() {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            Scaffold(body: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => Center(
                  child: TextButton(
                    onPressed: () => MainShellNavigator.goToSearchTab(context),
                    child: const Text('Home screen'),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => const Text('Search screen'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                builder: (context, state) => const Text('Library screen'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const Text('Settings screen'),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

void main() {
  testWidgets('goToSearchTab switches the shell to the Search branch', (
    tester,
  ) async {
    final router = _router();
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home screen'), findsOneWidget);

    await tester.tap(find.text('Home screen'));
    await tester.pumpAndSettle();

    expect(find.text('Search screen'), findsOneWidget);
  });
}
