import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/library/presentation/view_models/track_sort_view_model.dart';
import 'package:music_app/src/features/library/presentation/widgets/track_sort_sheet.dart';

/// Pumps a screen that opens the sort sheet and watches the resulting order.
///
/// The view model is auto-disposed, so it needs a listener alive for the
/// pick to be observable at all.
Future<ProviderContainer> _pumpSheet(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Consumer(
          builder: (context, ref, child) => Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(ref.watch(trackSortViewModelProvider).name),
                  TextButton(
                    onPressed: () => showTrackSortSheet(context, ref),
                    child: const Text('open'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  final container = ProviderScope.containerOf(
    tester.element(find.byType(Consumer)),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return container;
}

void main() {
  testWidgets('lists every sort option', (tester) async {
    await _pumpSheet(tester);

    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Artist'), findsOneWidget);
    expect(find.text('Date added'), findsOneWidget);
    expect(find.text('Duration'), findsOneWidget);
  });

  group('picking an option', () {
    final cases = <String, TrackSort>{
      'Artist': TrackSort.artist,
      'Date added': TrackSort.dateAdded,
      'Duration': TrackSort.duration,
      'Title': TrackSort.title,
    };

    for (final entry in cases.entries) {
      testWidgets('"${entry.key}" applies ${entry.value.name}', (tester) async {
        final container = await _pumpSheet(tester);

        await tester.tap(find.text(entry.key));
        await tester.pumpAndSettle();

        expect(container.read(trackSortViewModelProvider), entry.value);
      });
    }

    testWidgets('closes the sheet', (tester) async {
      await _pumpSheet(tester);

      await tester.tap(find.text('Artist'));
      await tester.pumpAndSettle();

      expect(find.text('Date added'), findsNothing);
    });
  });
}
