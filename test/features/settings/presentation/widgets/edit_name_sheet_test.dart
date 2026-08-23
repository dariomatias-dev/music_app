import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/settings/presentation/widgets/edit_name_sheet.dart';

/// Opens the sheet and reports what it resolved to after [action].
Future<String?> _resultAfter(
  WidgetTester tester,
  Future<void> Function() action, {
  String? initialName,
}) async {
  String? result;
  var resolved = false;

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await showEditNameSheet(
                  context,
                  initialName: initialName,
                );
                resolved = true;
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  await action();
  await tester.pumpAndSettle();

  expect(resolved, isTrue, reason: 'the sheet should have closed');
  return result;
}

void main() {
  testWidgets('pre-fills the current name', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () =>
                    showEditNameSheet(context, initialName: 'Dario'),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Dario'), findsOneWidget);
  });

  testWidgets('saving returns the trimmed name', (tester) async {
    final result = await _resultAfter(tester, () async {
      await tester.enterText(find.byType(AppTextField), '  Dario  ');
      await tester.pump();
      await tester.tap(find.text('Save'));
    });

    expect(result, 'Dario');
  });

  testWidgets('the keyboard action saves too', (tester) async {
    final result = await _resultAfter(tester, () async {
      await tester.enterText(find.byType(AppTextField), 'Dario');
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.done);
    });

    expect(result, 'Dario');
  });

  testWidgets('an emptied field returns an empty name, to clear it', (
    tester,
  ) async {
    final result = await _resultAfter(
      tester,
      () async {
        await tester.enterText(find.byType(AppTextField), '');
        await tester.pump();
        await tester.tap(find.text('Save'));
      },
      initialName: 'Dario',
    );

    expect(result, isEmpty);
  });
}
