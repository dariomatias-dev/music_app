import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/settings/presentation/screens/language_settings_screen.dart';

import '../../../../helpers/fake_key_value_storage.dart';

Widget _app({FakeKeyValueStorage? storage}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => context.push('/language'),
              child: const Text('Settings screen reached'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/language',
        builder: (context, state) => const LanguageSettingsScreen(),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      keyValueStorageProvider.overrideWithValue(
        storage ?? FakeKeyValueStorage(),
      ),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

Future<void> _openLanguageScreen(WidgetTester tester) async {
  await tester.tap(find.text('Settings screen reached'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lists every language plus a system default option', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await _openLanguageScreen(tester);

    expect(find.text('System default'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);
    expect(find.text('Português'), findsOneWidget);
    expect(find.text('中文'), findsOneWidget);
  });

  testWidgets('checks the system default option by default', (tester) async {
    await tester.pumpWidget(_app());
    await _openLanguageScreen(tester);

    final systemRow = tester.widget<AppSettingsRow>(
      find
          .ancestor(
            of: find.text('System default'),
            matching: find.byType(AppSettingsRow),
          )
          .first,
    );
    expect(systemRow.trailing, isA<Icon>());
  });

  testWidgets('selecting a language persists it and goes back', (
    tester,
  ) async {
    final storage = FakeKeyValueStorage();
    await tester.pumpWidget(_app(storage: storage));
    await _openLanguageScreen(tester);

    await tester.tap(find.text('Español'));
    await tester.pumpAndSettle();

    expect(await storage.getString('locale'), 'es');
    expect(find.text('Settings screen reached'), findsOneWidget);
  });

  testWidgets('selecting system default clears the stored locale', (
    tester,
  ) async {
    final storage = FakeKeyValueStorage();
    await storage.setString('locale', 'es');
    await tester.pumpWidget(_app(storage: storage));
    await _openLanguageScreen(tester);

    await tester.tap(find.text('System default'));
    await tester.pumpAndSettle();

    expect(await storage.getString('locale'), isNull);
    expect(find.text('Settings screen reached'), findsOneWidget);
  });
}
