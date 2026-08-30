import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/widgets/app_failure_screen.dart';

/// Pumps [screen] on its own, the way the framework does: with no
/// MaterialApp, Theme, Directionality or Localizations above it.
Future<void> _pumpBare(WidgetTester tester, AppFailureScreen screen) async {
  await tester.pumpWidget(screen);
}

ThemeData _theme(WidgetTester tester) =>
    tester.widget<Theme>(find.byType(Theme).first).data;

void main() {
  final en = lookupAppLocalizations(const Locale('en'));

  testWidgets('renders without an app, a theme or localizations above it', (
    tester,
  ) async {
    await _pumpBare(
      tester,
      const AppFailureScreen(kind: AppFailureKind.unexpected),
    );

    expect(tester.takeException(), isNull);
    expect(find.text(en.unexpectedErrorTitle), findsOneWidget);
    expect(find.text(en.unexpectedErrorMessage), findsOneWidget);
  });

  testWidgets('describes a startup failure and offers a retry', (tester) async {
    var retries = 0;

    await _pumpBare(
      tester,
      AppFailureScreen(
        kind: AppFailureKind.startup,
        onRetry: () => retries++,
      ),
    );

    expect(find.text(en.startupErrorTitle), findsOneWidget);
    expect(find.text(en.startupErrorMessage), findsOneWidget);

    await tester.tap(find.text(en.retryLabel));
    await tester.pump();

    expect(retries, 1);
  });

  testWidgets('offers no retry when there is nothing to retry', (tester) async {
    await _pumpBare(
      tester,
      const AppFailureScreen(kind: AppFailureKind.unexpected),
    );

    expect(find.text(en.retryLabel), findsNothing);
  });

  testWidgets('shows the technical details in a debug build', (tester) async {
    await _pumpBare(
      tester,
      const AppFailureScreen(
        kind: AppFailureKind.startup,
        technicalDetails: 'Exception: audio service unavailable',
      ),
    );

    expect(
      find.text('Exception: audio service unavailable'),
      findsOneWidget,
    );
  });

  group('theme', () {
    testWidgets('follows a light platform', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      await _pumpBare(
        tester,
        const AppFailureScreen(kind: AppFailureKind.unexpected),
      );

      expect(_theme(tester).brightness, Brightness.light);
    });

    testWidgets('follows a dark platform', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      await _pumpBare(
        tester,
        const AppFailureScreen(kind: AppFailureKind.unexpected),
      );

      expect(_theme(tester).brightness, Brightness.dark);
      expect(
        tester.widget<Material>(find.byType(Material).first).color,
        AppTheme.dark.scaffoldBackgroundColor,
      );
    });
  });

  group('language', () {
    testWidgets('uses the device language when it is supported', (
      tester,
    ) async {
      tester.platformDispatcher.localeTestValue = const Locale('pt');
      addTearDown(tester.platformDispatcher.clearLocaleTestValue);

      await _pumpBare(
        tester,
        const AppFailureScreen(kind: AppFailureKind.unexpected),
      );

      final pt = lookupAppLocalizations(const Locale('pt'));
      expect(find.text(pt.unexpectedErrorTitle), findsOneWidget);
    });

    testWidgets('falls back to English on an unsupported language', (
      tester,
    ) async {
      tester.platformDispatcher.localeTestValue = const Locale('fr');
      addTearDown(tester.platformDispatcher.clearLocaleTestValue);

      await _pumpBare(
        tester,
        const AppFailureScreen(kind: AppFailureKind.unexpected),
      );

      expect(find.text(en.unexpectedErrorTitle), findsOneWidget);
    });
  });
}
