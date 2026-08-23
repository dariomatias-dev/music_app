import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpIndicator(
  WidgetTester tester, {
  required bool playing,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Center(child: AppPlaybackIndicator(playing: playing)),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('animates from the start when it is already playing', (
    tester,
  ) async {
    await _pumpIndicator(tester, playing: true);

    expect(SchedulerBinding.instance.transientCallbackCount, greaterThan(0));
  });

  testWidgets('stands still while paused', (tester) async {
    await _pumpIndicator(tester, playing: false);

    expect(SchedulerBinding.instance.transientCallbackCount, 0);
  });

  testWidgets('starts moving once playback begins', (tester) async {
    await _pumpIndicator(tester, playing: false);
    expect(SchedulerBinding.instance.transientCallbackCount, 0);

    await _pumpIndicator(tester, playing: true);

    expect(SchedulerBinding.instance.transientCallbackCount, greaterThan(0));
  });

  testWidgets('stops when playback pauses', (tester) async {
    await _pumpIndicator(tester, playing: true);
    expect(SchedulerBinding.instance.transientCallbackCount, greaterThan(0));

    await _pumpIndicator(tester, playing: false);

    expect(SchedulerBinding.instance.transientCallbackCount, 0);
  });

  testWidgets('is laid out square at its size', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: Center(
            child: AppPlaybackIndicator(playing: false, size: 24),
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(AppPlaybackIndicator)),
      const Size(24, 24),
    );
  });
}
