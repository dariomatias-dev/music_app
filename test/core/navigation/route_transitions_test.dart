import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/src/core/navigation/route_transitions.dart';

/// Routes a second screen the tests can push to drive a transition.
GoRouter _router({Page<void> Function(GoRouterState state)? secondPage}) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: Text('first')),
      ),
      GoRoute(
        path: '/second',
        builder: (context, state) => const Scaffold(body: Text('second')),
        pageBuilder: secondPage == null
            ? null
            : (context, state) => secondPage(state),
      ),
    ],
  );
}

/// The innermost [SlideTransition] wrapping the route showing [text].
SlideTransition _slideAround(WidgetTester tester, String text) {
  return tester.widget<SlideTransition>(
    find
        .ancestor(
          of: find.text(text, skipOffstage: false),
          matching: find.byType(SlideTransition),
        )
        .first,
  );
}

Future<void> _pumpApp(WidgetTester tester, GoRouter router) async {
  addTearDown(router.dispose);
  await tester.pumpWidget(
    MaterialApp.router(
      theme: AppTheme.light.copyWith(
        pageTransitionsTheme: appPageTransitionsTheme,
      ),
      routerConfig: router,
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('appPageTransitionsTheme', () {
    test('applies the app builder on both mobile platforms', () {
      expect(
        appPageTransitionsTheme.builders[TargetPlatform.android],
        isA<AppPageTransitionsBuilder>(),
      );
      expect(
        appPageTransitionsTheme.builders[TargetPlatform.iOS],
        isA<AppPageTransitionsBuilder>(),
      );
    });

    testWidgets('fades and rises the incoming route into place', (
      tester,
    ) async {
      final router = _router();
      await _pumpApp(tester, router);

      unawaited(router.push('/second'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));

      final fade = tester.widgetList<FadeTransition>(
        find.byType(FadeTransition),
      );
      expect(fade, isNotEmpty);
      expect(
        fade.map((transition) => transition.opacity.value),
        anyElement(lessThan(1)),
      );

      expect(_slideAround(tester, 'second').position.value.dy, greaterThan(0));

      await tester.pumpAndSettle();
      expect(find.text('second'), findsOneWidget);
    });

    testWidgets('settles with no offset or scale left over', (tester) async {
      final router = _router();
      await _pumpApp(tester, router);

      unawaited(router.push('/second'));
      await tester.pumpAndSettle();

      final scale = tester.widget<ScaleTransition>(
        find
            .ancestor(
              of: find.text('second'),
              matching: find.byType(ScaleTransition),
            )
            .first,
      );

      expect(_slideAround(tester, 'second').position.value, Offset.zero);
      expect(scale.scale.value, 1);
    });
  });

  group('buildVerticalTransitionPage', () {
    testWidgets('slides the route up from the bottom edge', (tester) async {
      final router = _router(
        secondPage: (state) => buildVerticalTransitionPage(
          key: state.pageKey,
          child: const Scaffold(body: Text('second')),
        ),
      );
      await _pumpApp(tester, router);

      unawaited(router.push('/second'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1));

      expect(
        _slideAround(tester, 'second').position.value.dy,
        greaterThan(0.9),
      );

      await tester.pumpAndSettle();
      expect(find.text('second'), findsOneWidget);
    });

    testWidgets('lands with the route fully in view', (tester) async {
      final router = _router(
        secondPage: (state) => buildVerticalTransitionPage(
          key: state.pageKey,
          child: const Scaffold(body: Text('second')),
        ),
      );
      await _pumpApp(tester, router);

      unawaited(router.push('/second'));
      await tester.pumpAndSettle();

      expect(_slideAround(tester, 'second').position.value, Offset.zero);
    });
  });

  group('heroTagFor', () {
    test('prefixes the id with its origin', () {
      expect(heroTagFor(origin: 'home', id: 'track-1'), 'home-track-1');
    });

    test('keeps the same id distinct between two origins', () {
      expect(
        heroTagFor(origin: 'home', id: 'track-1'),
        isNot(heroTagFor(origin: 'search', id: 'track-1')),
      );
    });
  });
}
