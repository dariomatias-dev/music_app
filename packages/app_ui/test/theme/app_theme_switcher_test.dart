import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpSwitcher(WidgetTester tester, ThemeData data) {
  return tester.pumpWidget(
    MaterialApp(
      home: AppThemeSwitcher(
        data: data,
        child: Builder(
          builder: (context) => Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Text('${Theme.of(context).brightness}'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('themes its subtree with the data it was given', (tester) async {
    await _pumpSwitcher(tester, AppTheme.dark);
    await tester.pumpAndSettle();

    expect(find.text('${Brightness.dark}'), findsOneWidget);
  });

  testWidgets('crossfades instead of cutting when the theme changes', (
    tester,
  ) async {
    await _pumpSwitcher(tester, AppTheme.light);
    await tester.pumpAndSettle();
    final before = tester
        .widget<Scaffold>(find.byType(Scaffold))
        .backgroundColor;

    await _pumpSwitcher(tester, AppTheme.dark);
    await tester.pump(const Duration(milliseconds: 1));
    final midway = tester
        .widget<Scaffold>(find.byType(Scaffold))
        .backgroundColor;

    expect(midway, isNot(AppTheme.dark.scaffoldBackgroundColor));
    expect(midway, isNot(before));

    await tester.pumpAndSettle();
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
      AppTheme.dark.scaffoldBackgroundColor,
    );
  });
}
