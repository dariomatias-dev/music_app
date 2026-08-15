import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/search/presentation/screens/search_screen.dart';
import 'package:music_app/src/features/search/presentation/view_models/search_view_model.dart';

Widget _app() {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: SearchScreen()),
    ),
  );
}

void main() {
  testWidgets('shows the search field with its hint', (tester) async {
    await tester.pumpWidget(_app());

    expect(find.text('Search your library'), findsOneWidget);
  });

  testWidgets('typing updates the term after the debounce settles', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    final element = tester.element(find.byType(SearchScreen));
    final container = ProviderScope.containerOf(element)
      ..listen(searchViewModelProvider, (_, _) {});

    await tester.enterText(find.byType(TextField), 'Chill');
    await tester.pump(const Duration(milliseconds: 400));

    expect(container.read(searchViewModelProvider), 'Chill');
  });

  testWidgets('tapping clear empties the field and the term', (tester) async {
    await tester.pumpWidget(_app());

    final element = tester.element(find.byType(SearchScreen));
    final container = ProviderScope.containerOf(element)
      ..listen(searchViewModelProvider, (_, _) {});

    await tester.enterText(find.byType(TextField), 'Chill');
    await tester.pump(const Duration(milliseconds: 400));
    expect(container.read(searchViewModelProvider), 'Chill');

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();

    expect(container.read(searchViewModelProvider), '');
    expect(find.text('Chill'), findsNothing);
  });
}
