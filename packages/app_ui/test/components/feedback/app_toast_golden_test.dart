import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _showToast(
  WidgetTester tester,
  ThemeData theme,
  AppToastVariant variant,
  String message,
) async {
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
                onPressed: () =>
                    AppToast.show(context, message: message, variant: variant),
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
  final themes = {'light': AppTheme.light, 'dark': AppTheme.dark};
  for (final theme in themes.entries) {
    for (final variant in AppToastVariant.values) {
      testWidgets('AppToast - ${variant.name} - ${theme.key}', (
        tester,
      ) async {
        await _showToast(
          tester,
          theme.value,
          variant,
          'This is a ${variant.name} message',
        );
        await expectLater(
          find.byType(SnackBar),
          matchesGoldenFile(
            'goldens/app_toast_${variant.name}_${theme.key}.png',
          ),
        );
      });
    }
  }
}
