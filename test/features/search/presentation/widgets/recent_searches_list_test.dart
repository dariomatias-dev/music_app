import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/search/data/providers/search_data_providers.dart';
import 'package:music_app/src/features/search/presentation/widgets/recent_searches_list.dart';

import '../../../../helpers/fake_search_history_repository.dart';

/// Pumps the list over [terms], collecting the terms tapped in [selected].
Future<FakeSearchHistoryRepository> _pumpList(
  WidgetTester tester, {
  List<String> terms = const [],
  List<String>? selected,
}) async {
  final repository = FakeSearchHistoryRepository(terms);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        searchHistoryRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: RecentSearchesList(
            onSelect: (term) => selected?.add(term),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

/// The "Clear" inside the confirmation dialog, told apart from the header
/// button that carries the same label.
Finder confirmAction() => find.descendant(
  of: find.byType(AppDialog),
  matching: find.text('Clear'),
);

void main() {
  testWidgets('renders nothing without history', (tester) async {
    await _pumpList(tester);

    expect(find.text('Recent searches'), findsNothing);
  });

  testWidgets('lists the recorded terms', (tester) async {
    await _pumpList(tester, terms: ['chill', 'night drive']);

    expect(find.text('Recent searches'), findsOneWidget);
    expect(find.text('chill'), findsOneWidget);
    expect(find.text('night drive'), findsOneWidget);
  });

  testWidgets('tapping a term reports it', (tester) async {
    final selected = <String>[];
    await _pumpList(tester, terms: ['chill'], selected: selected);

    await tester.tap(find.text('chill'));
    await tester.pumpAndSettle();

    expect(selected, ['chill']);
  });

  group('clearing the history', () {
    testWidgets('asks for confirmation first', (tester) async {
      await _pumpList(tester, terms: ['chill']);

      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();

      expect(find.text('Clear search history?'), findsOneWidget);
    });

    testWidgets('keeps the history when the dialog is cancelled', (
      tester,
    ) async {
      final repository = await _pumpList(tester, terms: ['chill']);

      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(await repository.watchRecentTerms().first, ['chill']);
      expect(find.text('chill'), findsOneWidget);
    });

    testWidgets('drops every term once confirmed', (tester) async {
      final repository = await _pumpList(tester, terms: ['chill', 'night']);

      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();
      await tester.tap(confirmAction());
      await tester.pumpAndSettle();

      expect(await repository.watchRecentTerms().first, isEmpty);
      expect(find.text('Recent searches'), findsNothing);
    });
  });
}
