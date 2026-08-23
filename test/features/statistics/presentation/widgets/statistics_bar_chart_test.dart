import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/features/statistics/presentation/widgets/statistics_bar_chart.dart';

Future<void> _pumpChart(WidgetTester tester, List<int> values) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: StatisticsBarChart(values: values)),
    ),
  );
}

/// The height fractions of the rendered bars, left to right.
List<double> _heightFactors(WidgetTester tester) => tester
    .widgetList<FractionallySizedBox>(find.byType(FractionallySizedBox))
    .map((box) => box.heightFactor!)
    .toList();

void main() {
  testWidgets('draws nothing but its height when there are no values', (
    tester,
  ) async {
    await _pumpChart(tester, const []);

    expect(find.byType(FractionallySizedBox), findsNothing);
    expect(tester.getSize(find.byType(StatisticsBarChart)).height, 96);
  });

  testWidgets('draws one bar per value', (tester) async {
    await _pumpChart(tester, const [1, 2, 3]);

    expect(_heightFactors(tester), hasLength(3));
  });

  testWidgets('scales each bar against the largest value', (tester) async {
    await _pumpChart(tester, const [5, 10]);

    expect(_heightFactors(tester), [0.5, 1.0]);
  });

  testWidgets('keeps an empty day visible as a stub', (tester) async {
    await _pumpChart(tester, const [0, 10]);

    expect(_heightFactors(tester).first, 0.02);
  });

  testWidgets('keeps every bar a stub when nothing was played', (
    tester,
  ) async {
    await _pumpChart(tester, const [0, 0]);

    expect(_heightFactors(tester), [0.02, 0.02]);
  });
}
