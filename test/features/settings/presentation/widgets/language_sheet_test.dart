import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/settings/presentation/widgets/language_sheet.dart';

import '../../../../helpers/fake_key_value_storage.dart';

Widget _app({FakeKeyValueStorage? storage}) {
  return ProviderScope(
    overrides: [
      keyValueStorageProvider.overrideWithValue(
        storage ?? FakeKeyValueStorage(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: Consumer(
            builder: (context, ref, _) => TextButton(
              onPressed: () => showLanguageSheet(context, ref),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('lists every language plus a system default option', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('System default'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);
    expect(find.text('Português'), findsOneWidget);
    expect(find.text('中文'), findsOneWidget);
  });

  testWidgets('checks the system default option by default', (tester) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('✓'), findsOneWidget);
  });

  testWidgets('selecting a language persists it and closes the sheet', (
    tester,
  ) async {
    final storage = FakeKeyValueStorage();
    await tester.pumpWidget(_app(storage: storage));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Español'));
    await tester.pumpAndSettle();

    expect(await storage.getString('locale'), 'es');
    expect(find.text('open'), findsOneWidget);
    expect(find.text('Español'), findsNothing);
  });

  testWidgets('selecting system default clears the stored locale', (
    tester,
  ) async {
    final storage = FakeKeyValueStorage();
    await storage.setString('locale', 'es');
    await tester.pumpWidget(_app(storage: storage));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('System default'));
    await tester.pumpAndSettle();

    expect(await storage.getString('locale'), isNull);
  });
}
