import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpSkeleton(
  WidgetTester tester, {
  bool disableAnimations = false,
  double? width,
  double height = 14,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Scaffold(
          body: Center(
            child: AppSkeleton(width: width, height: height),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('pulses by default', (tester) async {
    await _pumpSkeleton(tester);

    expect(SchedulerBinding.instance.transientCallbackCount, greaterThan(0));
  });

  testWidgets('holds still when motion is reduced', (tester) async {
    await _pumpSkeleton(tester, disableAnimations: true);

    expect(SchedulerBinding.instance.transientCallbackCount, 0);
  });

  testWidgets('still paints a placeholder when motion is reduced', (
    tester,
  ) async {
    await _pumpSkeleton(tester, disableAnimations: true, width: 80);

    expect(tester.getSize(find.byType(AppSkeleton)), const Size(80, 14));
    expect(
      find.descendant(
        of: find.byType(AppSkeleton),
        matching: find.byType(Container),
      ),
      findsOneWidget,
    );
  });

  testWidgets('is laid out at the size it was given', (tester) async {
    await _pumpSkeleton(tester, width: 120, height: 20);

    expect(tester.getSize(find.byType(AppSkeleton)), const Size(120, 20));
  });

  testWidgets('stops pulsing once motion is reduced mid-life', (tester) async {
    await _pumpSkeleton(tester);
    expect(SchedulerBinding.instance.transientCallbackCount, greaterThan(0));

    await _pumpSkeleton(tester, disableAnimations: true);

    expect(SchedulerBinding.instance.transientCallbackCount, 0);
  });
}
