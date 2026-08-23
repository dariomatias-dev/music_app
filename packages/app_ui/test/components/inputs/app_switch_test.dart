import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<List<bool>> _pumpSwitch(
  WidgetTester tester, {
  required bool value,
  bool enabled = true,
}) async {
  final changes = <bool>[];

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Center(
          child: AppSwitch(
            value: value,
            onChanged: enabled ? changes.add : null,
            semanticLabel: 'Gapless playback',
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return changes;
}

void main() {
  testWidgets('tapping an off switch turns it on', (tester) async {
    final changes = await _pumpSwitch(tester, value: false);

    await tester.tap(find.byType(AppSwitch));
    await tester.pumpAndSettle();

    expect(changes, [true]);
  });

  testWidgets('tapping an on switch turns it off', (tester) async {
    final changes = await _pumpSwitch(tester, value: true);

    await tester.tap(find.byType(AppSwitch));
    await tester.pumpAndSettle();

    expect(changes, [false]);
  });

  testWidgets('a disabled switch reports nothing', (tester) async {
    final changes = await _pumpSwitch(tester, value: false, enabled: false);

    await tester.tap(find.byType(AppSwitch));
    await tester.pumpAndSettle();

    expect(changes, isEmpty);
  });

  testWidgets('carries its semantic label', (tester) async {
    await _pumpSwitch(tester, value: false);

    expect(find.bySemanticsLabel('Gapless playback'), findsOneWidget);
  });
}
