// The painters these tests inspect are private to the library, so their
// fields can only be reached dynamically.
// ignore_for_file: avoid_dynamic_calls

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps a seek bar of a known width, collecting every reported progress.
Future<List<double>> _pumpSeekBar(
  WidgetTester tester, {
  double progress = 0,
  bool isPlaying = false,
  int seed = 1,
  bool disableAnimations = false,
}) async {
  final reported = <double>[];

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Scaffold(
          body: Center(
            child: SizedBox(
              width: 200,
              child: AppWaveformSeekBar(
                progress: progress,
                isPlaying: isPlaying,
                seed: seed,
                onSeek: reported.add,
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return reported;
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

  group('seeking', () {
    testWidgets('a tap reports the fraction it landed on', (tester) async {
      final reported = await _pumpSeekBar(tester);

      final bar = find.byType(AppWaveformSeekBar);
      final left = tester.getTopLeft(bar);
      await tester.tapAt(Offset(left.dx + 50, tester.getCenter(bar).dy));
      await tester.pump();

      expect(reported, hasLength(1));
      expect(reported.single, closeTo(0.25, 0.01));
    });

    testWidgets('a tap at the far end clamps to the track', (tester) async {
      final reported = await _pumpSeekBar(tester);

      final bar = find.byType(AppWaveformSeekBar);
      final right = tester.getTopRight(bar);
      await tester.tapAt(Offset(right.dx - 1, tester.getCenter(bar).dy));
      await tester.pump();

      expect(reported.single, closeTo(1, 0.01));
    });

    testWidgets('a drag reports continuously as the finger moves', (
      tester,
    ) async {
      final reported = await _pumpSeekBar(tester);

      final bar = find.byType(AppWaveformSeekBar);
      final start = tester.getCenter(bar);
      final drag = await tester.startGesture(start);
      await drag.moveBy(const Offset(-50, 0));
      await tester.pump();
      await drag.moveBy(const Offset(20, 0));
      await tester.pump();
      await drag.up();
      await tester.pump();

      expect(reported.length, greaterThanOrEqualTo(2));
      expect(reported.last, greaterThan(reported[reported.length - 2]));
    });

    testWidgets('the scrub position wins over the incoming progress', (
      tester,
    ) async {
      await _pumpSeekBar(tester, progress: 0.9);

      final bar = find.byType(AppWaveformSeekBar);
      final drag = await tester.startGesture(tester.getTopLeft(bar));
      await drag.moveBy(const Offset(10, 20));
      await tester.pump();

      final painter =
          tester
                  .widget<CustomPaint>(
                    find
                        .descendant(of: bar, matching: find.byType(CustomPaint))
                        .first,
                  )
                  .painter
              as dynamic;
      expect(painter.scrubbing, isTrue);
      expect(painter.progress, isNot(0.9));

      await drag.up();
      await tester.pump();
    });

    testWidgets('lifting the finger hands control back to progress', (
      tester,
    ) async {
      await _pumpSeekBar(tester, progress: 0.9);

      final bar = find.byType(AppWaveformSeekBar);
      final drag = await tester.startGesture(tester.getTopLeft(bar));
      await drag.moveBy(const Offset(10, 0));
      await tester.pump();
      await drag.up();
      await tester.pump();

      final painter =
          tester
                  .widget<CustomPaint>(
                    find
                        .descendant(of: bar, matching: find.byType(CustomPaint))
                        .first,
                  )
                  .painter
              as dynamic;
      expect(painter.scrubbing, isFalse);
      expect(painter.progress, 0.9);
    });
  });

  group('haptics', () {
    testWidgets('fire on tap and on drag end', (tester) async {
      await _pumpSeekBar(tester);

      await tester.tap(find.byType(AppWaveformSeekBar));
      await tester.pump();

      expect(hapticCalls, isNotEmpty);
    });

    testWidgets('stay silent while they are turned off', (tester) async {
      Pressable.hapticsEnabled = false;
      await _pumpSeekBar(tester);

      await tester.tap(find.byType(AppWaveformSeekBar));
      await tester.pump();

      expect(hapticCalls, isEmpty);
    });
  });

  group('the pulse', () {
    testWidgets('runs while playing', (tester) async {
      await _pumpSeekBar(tester, isPlaying: true);

      expect(SchedulerBinding.instance.transientCallbackCount, greaterThan(0));
    });

    testWidgets('stays still while paused', (tester) async {
      await _pumpSeekBar(tester);

      expect(SchedulerBinding.instance.transientCallbackCount, 0);
    });

    testWidgets('stays still when motion is reduced', (tester) async {
      await _pumpSeekBar(tester, isPlaying: true, disableAnimations: true);

      expect(SchedulerBinding.instance.transientCallbackCount, 0);
    });
  });

  testWidgets('rebuilds the waveform when the seed changes', (tester) async {
    Widget app(int seed) => MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 200,
            child: AppWaveformSeekBar(
              progress: 0,
              isPlaying: false,
              seed: seed,
              onSeek: (_) {},
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(app(1));
    await tester.pump();
    final first =
        (tester
                        .widget<CustomPaint>(
                          find
                              .descendant(
                                of: find.byType(AppWaveformSeekBar),
                                matching: find.byType(CustomPaint),
                              )
                              .first,
                        )
                        .painter
                    as dynamic)
                .amps
            as List<double>;

    await tester.pumpWidget(app(2));
    await tester.pump();
    final second =
        (tester
                        .widget<CustomPaint>(
                          find
                              .descendant(
                                of: find.byType(AppWaveformSeekBar),
                                matching: find.byType(CustomPaint),
                              )
                              .first,
                        )
                        .painter
                    as dynamic)
                .amps
            as List<double>;

    expect(second, isNot(first));
  });
}
