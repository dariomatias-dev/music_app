import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<List<int>> _pumpBar(WidgetTester tester, {int index = 0}) async {
  final selected = <int>[];

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Center(
          child: AppSegmentedBar(
            labels: const ['Week', 'Month', 'Year'],
            index: index,
            onChanged: selected.add,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return selected;
}

void main() {
  testWidgets('shows every segment', (tester) async {
    await _pumpBar(tester);

    expect(find.text('Week'), findsOneWidget);
    expect(find.text('Month'), findsOneWidget);
    expect(find.text('Year'), findsOneWidget);
  });

  testWidgets('tapping a segment reports its index', (tester) async {
    final selected = await _pumpBar(tester);

    await tester.tap(find.text('Year'));
    await tester.pumpAndSettle();

    expect(selected, [2]);
  });

  testWidgets('tapping the selected segment reports it again', (tester) async {
    final selected = await _pumpBar(tester, index: 1);

    await tester.tap(find.text('Month'));
    await tester.pumpAndSettle();

    expect(selected, [1]);
  });
}
