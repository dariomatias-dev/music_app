import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';

/// Pumps [screen] (already wrapped in its `ProviderScope`) inside a themed,
/// localized app, for golden tests.
Future<void> pumpGoldenScreen(
  WidgetTester tester,
  Widget screen, {
  required ThemeData theme,
  Size surfaceSize = const Size(390, 844),
}) async {
  tester.view.physicalSize = surfaceSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // AppScaffold needs a Material ancestor to render correctly.
      home: Scaffold(body: screen),
    ),
  );
  // Lets provider chains settle, then advances a fixed duration instead
  // of pumpAndSettle, since some widgets animate continuously.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}
