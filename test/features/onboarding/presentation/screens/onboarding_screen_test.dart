import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/onboarding/presentation/screens/onboarding_screen.dart';

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
}
