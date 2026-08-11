import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _showDialog(WidgetTester tester, ThemeData theme) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                onPressed: () => AppConfirmationDialog.show(
                  context,
                  title: 'Remove from playlist?',
                  message: 'This track will be removed from Chill Vibes.',
                  confirmLabel: 'Remove',
                  cancelLabel: 'Cancel',
                ),
                child: const Text('Trigger'),
              ),
            );
          },
        ),
      ),
    ),
  );
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  testWidgets('AppConfirmationDialog - light', (tester) async {
    await _showDialog(tester, AppTheme.light);
    await expectLater(
      find.byType(AppDialog),
      matchesGoldenFile('goldens/app_confirmation_dialog_light.png'),
    );
  });

  testWidgets('AppConfirmationDialog - dark', (tester) async {
    await _showDialog(tester, AppTheme.dark);
    await expectLater(
      find.byType(AppDialog),
      matchesGoldenFile('goldens/app_confirmation_dialog_dark.png'),
    );
  });
}
