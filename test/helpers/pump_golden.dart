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
      // AppScaffold relies on a Material ancestor it would normally get
      // from MaterialPageRoute's own transition machinery; `home:` skips
      // that, so provide a bare Scaffold here to match.
      home: Scaffold(body: screen),
    ),
  );
  // A first empty pump lets every provider chain (StreamProvider ->
  // derived Provider -> widget) settle its initial async value before the
  // frame that gets captured.
  await tester.pump();
  // Advances a fixed amount of frames instead of settling, since some
  // widgets (e.g. loading spinners, playback indicators) animate
  // continuously.
  await tester.pump(const Duration(milliseconds: 300));
}
