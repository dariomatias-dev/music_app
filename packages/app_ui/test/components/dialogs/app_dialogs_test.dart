import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Opens a dialog through [show] and reports what it resolved to.
Future<T?> _openDialog<T>(
  WidgetTester tester,
  Future<T> Function(BuildContext context) show, {
  required Future<void> Function() dismiss,
}) async {
  T? result;

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () async => result = await show(context),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  await dismiss();
  await tester.pumpAndSettle();
  return result;
}

void main() {
  group('AppConfirmationDialog', () {
    Future<bool?> open(WidgetTester tester, String tapLabel) => _openDialog(
      tester,
      (context) => AppConfirmationDialog.show(
        context,
        title: 'Replace queue?',
        message: 'The current queue will be replaced.',
        confirmLabel: 'Replace',
        cancelLabel: 'Cancel',
      ),
      dismiss: () => tester.tap(find.text(tapLabel)),
    );

    testWidgets('shows its title, message and actions', (tester) async {
      await _openDialog(
        tester,
        (context) => AppConfirmationDialog.show(
          context,
          title: 'Replace queue?',
          message: 'The current queue will be replaced.',
          confirmLabel: 'Replace',
          cancelLabel: 'Cancel',
        ),
        dismiss: () async {},
      );

      expect(find.text('Replace queue?'), findsOneWidget);
      expect(find.text('The current queue will be replaced.'), findsOneWidget);
      expect(find.text('Replace'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('confirming returns true', (tester) async {
      expect(await open(tester, 'Replace'), isTrue);
    });

    testWidgets('cancelling returns false', (tester) async {
      expect(await open(tester, 'Cancel'), isFalse);
    });
  });

  group('AppDestructiveDialog', () {
    Future<bool?> open(WidgetTester tester, String tapLabel) => _openDialog(
      tester,
      (context) => AppDestructiveDialog.show(
        context,
        title: 'Delete playlist?',
        message: 'This cannot be undone.',
        confirmLabel: 'Delete',
        cancelLabel: 'Cancel',
      ),
      dismiss: () => tester.tap(find.text(tapLabel)),
    );

    testWidgets('confirming returns true', (tester) async {
      expect(await open(tester, 'Delete'), isTrue);
    });

    testWidgets('cancelling returns false', (tester) async {
      expect(await open(tester, 'Cancel'), isFalse);
    });
  });

  group('AppInformationDialog', () {
    testWidgets('closes on its single action', (tester) async {
      await _openDialog<void>(
        tester,
        (context) => AppInformationDialog.show(
          context,
          title: 'File information',
          message: 'Format: FLAC',
          dismissLabel: 'Close',
        ),
        dismiss: () => tester.tap(find.text('Close')),
      );

      expect(find.text('File information'), findsNothing);
    });
  });
}
