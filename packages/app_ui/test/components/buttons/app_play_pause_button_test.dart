// The painters these tests inspect are private to the library, so their
// fields can only be reached dynamically.
// ignore_for_file: avoid_dynamic_calls

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpButton(
  WidgetTester tester, {
  required bool isPlaying,
  double? progress,
  VoidCallback? onTap,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Center(
          child: AppPlayPauseButton(
            isPlaying: isPlaying,
            progress: progress,
            playSemanticLabel: 'Play',
            pauseSemanticLabel: 'Pause',
            onTap: onTap ?? () {},
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

/// The progress ring's painter, or null when no ring is drawn.
dynamic _ringPainter(WidgetTester tester) {
  final paints = tester.widgetList<CustomPaint>(
    find.descendant(
      of: find.byType(AppPlayPauseButton),
      matching: find.byType(CustomPaint),
    ),
  );
  for (final paint in paints) {
    final painter = paint.painter;
    if (painter != null && '$painter'.contains('ProgressRing')) return painter;
  }
  return null;
}

void main() {
  final hapticCalls = <String>[];

  setUp(() {
    hapticCalls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'HapticFeedback.vibrate') {
            hapticCalls.add(call.arguments as String? ?? '');
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
    Pressable.hapticsEnabled = true;
  });

  testWidgets('tapping reports through onTap', (tester) async {
    var taps = 0;
    await _pumpButton(tester, isPlaying: false, onTap: () => taps++);

    await tester.tap(find.byType(AppPlayPauseButton));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('tapping fires a haptic', (tester) async {
    await _pumpButton(tester, isPlaying: false);

    await tester.tap(find.byType(AppPlayPauseButton));
    await tester.pump();

    expect(hapticCalls, isNotEmpty);
  });

  testWidgets('stays silent while haptics are off', (tester) async {
    Pressable.hapticsEnabled = false;
    await _pumpButton(tester, isPlaying: false);

    await tester.tap(find.byType(AppPlayPauseButton));
    await tester.pump();

    expect(hapticCalls, isEmpty);
  });

  group('the progress ring', () {
    testWidgets('is absent when no progress is given', (tester) async {
      await _pumpButton(tester, isPlaying: false);

      expect(_ringPainter(tester), isNull);
    });

    testWidgets('draws the progress it was given', (tester) async {
      await _pumpButton(tester, isPlaying: true, progress: 0.4);

      expect(_ringPainter(tester).progress, 0.4);
    });

    testWidgets('repaints the ring when progress changes', (tester) async {
      await _pumpButton(tester, isPlaying: true, progress: 0.2);
      expect(_ringPainter(tester).progress, 0.2);

      await _pumpButton(tester, isPlaying: true, progress: 0.6);

      expect(_ringPainter(tester).progress, 0.6);
    });
  });

  group('switching state', () {
    testWidgets('animates the icon and bounces', (tester) async {
      await _pumpButton(tester, isPlaying: false);
      expect(SchedulerBinding.instance.transientCallbackCount, 0);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Center(
              child: AppPlayPauseButton(
                isPlaying: true,
                playSemanticLabel: 'Play',
                pauseSemanticLabel: 'Pause',
                onTap: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(SchedulerBinding.instance.transientCallbackCount, greaterThan(0));

      await tester.pumpAndSettle();
      expect(SchedulerBinding.instance.transientCallbackCount, 0);
    });

    testWidgets('animates back when playback stops', (tester) async {
      await _pumpButton(tester, isPlaying: true);
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Center(
              child: AppPlayPauseButton(
                isPlaying: false,
                playSemanticLabel: 'Play',
                pauseSemanticLabel: 'Pause',
                onTap: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(SchedulerBinding.instance.transientCallbackCount, greaterThan(0));
      await tester.pumpAndSettle();
    });

    testWidgets('stays still when nothing changed', (tester) async {
      await _pumpButton(tester, isPlaying: true);
      await tester.pumpAndSettle();

      await _pumpButton(tester, isPlaying: true);

      expect(SchedulerBinding.instance.transientCallbackCount, 0);
    });
  });

  group('semantics', () {
    testWidgets('announces pausing while playing', (tester) async {
      await _pumpButton(tester, isPlaying: true);

      expect(find.bySemanticsLabel('Pause'), findsOneWidget);
    });

    testWidgets('announces playing while paused', (tester) async {
      await _pumpButton(tester, isPlaying: false);

      expect(find.bySemanticsLabel('Play'), findsOneWidget);
    });
  });
}
