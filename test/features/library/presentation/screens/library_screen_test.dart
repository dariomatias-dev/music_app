import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/library/presentation/screens/library_screen.dart';
import 'package:music_app/src/features/library/presentation/view_models/library_view_model.dart';

Widget _app() {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LibraryScreen(),
    ),
  );
}

void main() {
  testWidgets('shows every section label', (tester) async {
    await tester.pumpWidget(_app());

    expect(find.text('Tracks'), findsOneWidget);
    expect(find.text('Albums'), findsOneWidget);
    expect(find.text('Artists'), findsOneWidget);
    expect(find.text('Playlists'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
  });

  testWidgets('tapping a label switches the section', (tester) async {
    await tester.pumpWidget(_app());

    final element = tester.element(find.byType(LibraryScreen));
    final container = ProviderScope.containerOf(element);
    expect(
      container.read(libraryViewModelProvider),
      LibrarySection.tracks,
    );

    await tester.tap(find.text('Albums'));
    await tester.pump();

    expect(
      container.read(libraryViewModelProvider),
      LibrarySection.albums,
    );
  });
}
