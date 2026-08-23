import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/constants/preference_keys.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/core/utils/clock.dart';
import 'package:music_app/src/features/home/presentation/widgets/home_header.dart';

import '../../../../helpers/fake_key_value_storage.dart';

Future<void> _pumpHeader(
  WidgetTester tester, {
  required DateTime now,
  String? displayName,
}) async {
  final storage = FakeKeyValueStorage();
  if (displayName != null) {
    await storage.setString(PreferenceKeys.userDisplayName, displayName);
  }

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        keyValueStorageProvider.overrideWithValue(storage),
        clockProvider.overrideWithValue(() => now),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: HomeHeader()),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('shows the name-less welcome until a name is set', (
    tester,
  ) async {
    await _pumpHeader(tester, now: DateTime(2024, 1, 1, 9));

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Good morning'), findsNothing);
  });

  testWidgets('shows the name-less welcome when the stored name is empty', (
    tester,
  ) async {
    await _pumpHeader(
      tester,
      now: DateTime(2024, 1, 1, 9),
      displayName: '',
    );

    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('greets by name once one is stored', (tester) async {
    await _pumpHeader(
      tester,
      now: DateTime(2024, 1, 1, 9),
      displayName: 'Dario',
    );

    expect(find.text('Dario'), findsOneWidget);
    expect(find.text('Welcome back'), findsNothing);
  });

  group('time-of-day greeting', () {
    final cases = <String, List<DateTime>>{
      'Good morning': [DateTime(2024), DateTime(2024, 1, 1, 11, 59)],
      'Good afternoon': [
        DateTime(2024, 1, 1, 12),
        DateTime(2024, 1, 1, 17, 59),
      ],
      'Good evening': [DateTime(2024, 1, 1, 18), DateTime(2024, 1, 1, 23, 59)],
    };

    for (final entry in cases.entries) {
      for (final now in entry.value) {
        testWidgets('says "${entry.key}" at ${now.hour}h', (tester) async {
          await _pumpHeader(tester, now: now, displayName: 'Dario');

          expect(find.text(entry.key), findsOneWidget);
        });
      }
    }
  });

  testWidgets('renders the search trigger hint', (tester) async {
    await _pumpHeader(tester, now: DateTime(2024, 1, 1, 9));

    expect(find.text('Search your library'), findsOneWidget);
  });

  testWidgets('tapping the search trigger switches to the Search tab', (
    tester,
  ) async {
    final storage = FakeKeyValueStorage();
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              Scaffold(body: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const HomeHeader(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/search',
                  builder: (context, state) => const Text('Search screen'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          keyValueStorageProvider.overrideWithValue(storage),
          clockProvider.overrideWithValue(() => DateTime(2024, 1, 1, 9)),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Search your library'));
    await tester.pumpAndSettle();

    expect(find.text('Search screen'), findsOneWidget);
  });
}
