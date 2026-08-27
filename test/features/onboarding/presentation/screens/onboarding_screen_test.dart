import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/constants/preference_keys.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/onboarding/presentation/screens/onboarding_screen.dart';

import '../../../../helpers/fake_key_value_storage.dart';

Future<void> _pumpAtSize(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const OnboardingScreen(),
    ),
  );
  await tester.pump();
}

/// Pumps the screen with the storage its completion is written to, and a
/// route standing in for the permission screen it hands off to.
Future<FakeKeyValueStorage> _pumpFlow(WidgetTester tester) async {
  final storage = FakeKeyValueStorage();
  final router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        name: 'permissions',
        path: '/permissions',
        builder: (context, state) =>
            const Scaffold(body: Text('Permission screen')),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [keyValueStorageProvider.overrideWithValue(storage)],
      child: MaterialApp.router(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return storage;
}

void main() {
  testWidgets('shows the first page', (tester) async {
    await _pumpAtSize(tester, const Size(390, 844));

    expect(find.text('Your music, on your device'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('does not overflow on a small phone', (tester) async {
    await _pumpAtSize(tester, const Size(320, 568));

    expect(tester.takeException(), isNull);
  });

  testWidgets('does not overflow on a small phone with large text scale', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await _pumpAtSize(tester, const Size(320, 568));

    expect(tester.takeException(), isNull);
  });

  group('paging', () {
    testWidgets('next advances through every page', (tester) async {
      await _pumpFlow(tester);

      expect(find.text('Your music, on your device'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Built for one hand'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('It learns what you play'), findsOneWidget);
    });

    testWidgets('swiping keeps the button label in step', (tester) async {
      await _pumpFlow(tester);

      await tester.fling(
        find.byType(PageView),
        const Offset(-400, 0),
        1000,
      );
      await tester.pumpAndSettle();

      expect(find.text('Built for one hand'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('the last page swaps the label and drops skip', (
      tester,
    ) async {
      await _pumpFlow(tester);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('Start listening'), findsOneWidget);
      expect(find.text('Next'), findsNothing);
      expect(
        tester.widget<AppTextButton>(find.byType(AppTextButton)).onPressed,
        isNull,
      );
    });
  });

  group('finishing', () {
    testWidgets('skip records completion and moves on', (tester) async {
      final storage = await _pumpFlow(tester);

      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(
        await storage.getBool(PreferenceKeys.onboardingCompleted),
        isTrue,
      );
      expect(find.text('Permission screen'), findsOneWidget);
    });

    testWidgets('the last page button records completion and moves on', (
      tester,
    ) async {
      final storage = await _pumpFlow(tester);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start listening'));
      await tester.pumpAndSettle();

      expect(
        await storage.getBool(PreferenceKeys.onboardingCompleted),
        isTrue,
      );
      expect(find.text('Permission screen'), findsOneWidget);
    });
  });
}
