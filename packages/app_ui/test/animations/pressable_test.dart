import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: child),
  );
}

void main() {
  tearDown(() => Pressable.hapticsEnabled = true);

  testWidgets('tapping calls onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _app(Pressable(onTap: () => tapped = true, child: const Text('tap'))),
    );

    await tester.tap(find.text('tap'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('is focusable and activates onTap via keyboard', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      _app(Pressable(onTap: () => tapped = true, child: const Text('tap'))),
    );

    final element = tester.element(find.text('tap'));
    Focus.of(element).requestFocus();
    await tester.pump();

    expect(Focus.of(element).hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('is not focusable when onTap is null', (tester) async {
    await tester.pumpWidget(_app(const Pressable(child: Text('tap'))));

    final element = tester.element(find.text('tap'));
    Focus.of(element).requestFocus();
    await tester.pump();

    expect(Focus.of(element).hasFocus, isFalse);
  });
}
