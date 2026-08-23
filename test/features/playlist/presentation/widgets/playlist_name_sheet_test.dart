import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_name_sheet.dart';

/// Opens the sheet and hands back whatever it resolves to.
Future<PlaylistNameSheetResult?> _openSheet(
  WidgetTester tester, {
  String? initialName,
  String? initialDescription,
  bool showDescriptionField = false,
}) async {
  PlaylistNameSheetResult? result;

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
                result = await showPlaylistNameSheet(
                  context,
                  title: 'New playlist',
                  confirmLabel: 'Create',
                  initialName: initialName,
                  initialDescription: initialDescription,
                  showDescriptionField: showDescriptionField,
                );
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
  return result;
}

/// Reads the value the sheet resolved to after it closes.
Future<PlaylistNameSheetResult?> _resultAfter(
  WidgetTester tester,
  Future<void> Function() action, {
  String? initialName,
  bool showDescriptionField = false,
}) async {
  PlaylistNameSheetResult? result;

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
                result = await showPlaylistNameSheet(
                  context,
                  title: 'New playlist',
                  confirmLabel: 'Create',
                  initialName: initialName,
                  showDescriptionField: showDescriptionField,
                );
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
  return result;
}

void main() {
  testWidgets('shows the title and confirm label it was given', (tester) async {
    await _openSheet(tester);

    expect(find.text('New playlist'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
  });

  testWidgets('pre-fills the name when renaming', (tester) async {
    await _openSheet(tester, initialName: 'Road Trip');

    expect(find.text('Road Trip'), findsOneWidget);
  });

  testWidgets('cannot confirm while the name is blank', (tester) async {
    await _openSheet(tester);

    expect(
      tester.widget<AppPrimaryButton>(find.byType(AppPrimaryButton)).onPressed,
      isNull,
    );
  });

  testWidgets('enables confirm once a name is typed', (tester) async {
    await _openSheet(tester);

    await tester.enterText(find.byType(AppTextField).first, 'Road Trip');
    await tester.pump();

    expect(
      tester.widget<AppPrimaryButton>(find.byType(AppPrimaryButton)).onPressed,
      isNotNull,
    );
  });

  testWidgets('keeps confirm disabled for whitespace alone', (tester) async {
    await _openSheet(tester);

    await tester.enterText(find.byType(AppTextField).first, '   ');
    await tester.pump();

    expect(
      tester.widget<AppPrimaryButton>(find.byType(AppPrimaryButton)).onPressed,
      isNull,
    );
  });

  testWidgets('returns the trimmed name on confirm', (tester) async {
    final result = await _resultAfter(tester, () async {
      await tester.enterText(find.byType(AppTextField).first, '  Road Trip  ');
      await tester.pump();
      await tester.tap(find.text('Create'));
    });

    expect(result?.name, 'Road Trip');
  });

  group('the keyboard action', () {
    testWidgets('submits the name when there is no description field', (
      tester,
    ) async {
      final result = await _resultAfter(tester, () async {
        await tester.enterText(find.byType(AppTextField).first, 'Road Trip');
        await tester.pump();
        await tester.testTextInput.receiveAction(TextInputAction.done);
      });

      expect(result?.name, 'Road Trip');
    });

    testWidgets('submits from the description field when there is one', (
      tester,
    ) async {
      final result = await _resultAfter(
        tester,
        () async {
          await tester.enterText(find.byType(AppTextField).first, 'Road Trip');
          await tester.pump();
          await tester.enterText(
            find.byType(AppTextField).last,
            'Songs for the drive',
          );
          await tester.pump();
          await tester.testTextInput.receiveAction(TextInputAction.done);
        },
        showDescriptionField: true,
      );

      expect(result?.name, 'Road Trip');
      expect(result?.description, 'Songs for the drive');
    });

    testWidgets('does nothing on a blank name', (tester) async {
      final result = await _resultAfter(tester, () async {
        await tester.enterText(find.byType(AppTextField).first, '   ');
        await tester.pump();
        await tester.testTextInput.receiveAction(TextInputAction.done);
      });

      expect(result, isNull);
      expect(find.text('Create'), findsOneWidget);
    });
  });
}
