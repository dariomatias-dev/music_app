import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TextEditingController controller;
  late FocusNode focusNode;

  setUp(() {
    controller = TextEditingController();
    focusNode = FocusNode();
  });

  tearDown(() {
    controller.dispose();
    focusNode.dispose();
  });

  Future<List<String>> pumpField(
    WidgetTester tester, {
    VoidCallback? onClear,
  }) async {
    final changes = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Column(
            children: [
              AppSearchField(
                controller: controller,
                focusNode: focusNode,
                hintText: 'Search your library',
                clearButtonSemanticLabel: 'Clear search',
                onChanged: changes.add,
                onClear: onClear,
              ),
              const SizedBox(height: 200, width: 200),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return changes;
  }

  testWidgets('shows the hint while empty', (tester) async {
    await pumpField(tester);

    expect(find.text('Search your library'), findsOneWidget);
  });

  testWidgets('reports every change', (tester) async {
    final changes = await pumpField(tester);

    await tester.enterText(find.byType(TextField), 'night');
    await tester.pumpAndSettle();

    expect(changes, ['night']);
  });

  testWidgets('hides the clear button while empty', (tester) async {
    await pumpField(tester);

    expect(find.bySemanticsLabel('Clear search'), findsNothing);
  });

  testWidgets('clearing empties the field and reports it', (tester) async {
    var cleared = false;
    await pumpField(tester, onClear: () => cleared = true);

    await tester.enterText(find.byType(TextField), 'night');
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Clear search'));
    await tester.pumpAndSettle();

    expect(controller.text, isEmpty);
    expect(cleared, isTrue);
  });

  testWidgets('tapping outside gives up focus', (tester) async {
    await pumpField(tester);

    focusNode.requestFocus();
    await tester.pumpAndSettle();
    expect(focusNode.hasFocus, isTrue);

    await tester.tapAt(const Offset(100, 400));
    await tester.pumpAndSettle();

    expect(focusNode.hasFocus, isFalse);
  });
}
