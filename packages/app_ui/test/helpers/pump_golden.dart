import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps [child] inside a themed [MaterialApp], for golden tests.
Future<void> pumpGolden(
  WidgetTester tester,
  Widget child, {
  required ThemeData theme,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Padding(padding: const EdgeInsets.all(24), child: child),
        ),
      ),
    ),
  );
  // Advances a fixed amount of frames instead of settling, since some
  // components (e.g. loading spinners) animate continuously.
  await tester.pump(const Duration(milliseconds: 300));
}
