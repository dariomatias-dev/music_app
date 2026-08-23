import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _items = [
  AppNavigationItem(
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    label: 'Home',
  ),
  AppNavigationItem(
    icon: Icons.search,
    activeIcon: Icons.search,
    label: 'Search',
  ),
];

Future<List<int>> _pumpBar(
  WidgetTester tester, {
  int index = 0,
  EdgeInsets padding = EdgeInsets.zero,
}) async {
  final selected = <int>[];

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: MediaQuery(
        data: MediaQueryData(padding: padding),
        child: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: AppNavigationBar(
              items: _items,
              index: index,
              onChanged: selected.add,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return selected;
}

void main() {
  testWidgets('shows a label per item', (tester) async {
    await _pumpBar(tester);

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
  });

  testWidgets('tapping an item reports its index', (tester) async {
    final selected = await _pumpBar(tester);

    await tester.tap(find.text('Search'));
    await tester.pump();

    expect(selected, [1]);
  });

  testWidgets('tapping the active item reports it again', (tester) async {
    final selected = await _pumpBar(tester);

    await tester.tap(find.text('Home'));
    await tester.pump();

    expect(selected, [0]);
  });

  testWidgets('marks the active item with its filled icon', (tester) async {
    await _pumpBar(tester, index: 1);

    expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    expect(find.byIcon(Icons.home), findsNothing);
  });

  group('totalHeight', () {
    testWidgets('is the row height without a bottom inset', (tester) async {
      late double total;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              total = AppNavigationBar.totalHeight(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(total, AppNavigationBar.height);
    });

    testWidgets('adds the device bottom inset', (tester) async {
      late double total;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              padding: EdgeInsets.only(bottom: 34),
            ),
            child: Builder(
              builder: (context) {
                total = AppNavigationBar.totalHeight(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(total, AppNavigationBar.height + 34);
    });
  });
}
