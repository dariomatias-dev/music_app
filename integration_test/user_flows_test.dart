import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:music_app/src/features/player/presentation/widgets/mini_player.dart';

import 'helpers/app_harness.dart';

/// End-to-end journeys that cross feature boundaries, each driving the real
/// app over a real (in-memory) database rather than a mocked repository.
///
/// The flows in `app_flows_test.dart` cover first launch, playback and
/// persistence across a reopen; these cover what a user does once the
/// library is populated.
///
/// Three details of the app decide how these are written:
///
/// - The playlist sheet's confirm button stays disabled until its field
///   reports a non-empty name, so entering text and tapping confirm need a
///   pump between them; without it the tap hits a disabled button and does
///   nothing at all.
/// - That field is an `AppTextField`, addressed by type so it cannot be
///   confused with the plain `TextField` a search field is built from.
/// - `AppTopBar` renders its own back control rather than a Material
///   `BackButton`, so [WidgetTester.pageBack] never finds it; the back
///   button is tapped by its semantics label instead.
///
/// The favoriting flow depends on playback actually starting, which only
/// happens on a device: `playFromSource` awaits the library's drift
/// streams, and those do not emit under the fake async a plain
/// `flutter test` run uses. The playback flow in `app_flows_test.dart` has
/// the same constraint.
///
/// Run on a connected device or emulator with:
///   fvm flutter test integration_test/user_flows_test.dart -d `<device-id>`
///
/// `fvm flutter devices` lists the ids.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('a playlist created in the library opens on its own screen', (
    tester,
  ) async {
    final app = await launchSeededApp(tester);

    await tester.tap(find.text(app.l10n.libraryTabLabel));
    await settle(tester);
    await tester.tap(find.text(app.l10n.libraryPlaylistsTab));
    await settle(tester);

    expect(find.text(app.l10n.playlistsEmptyTitle), findsOneWidget);

    await tester.tap(find.text(app.l10n.newPlaylistLabel));
    await settle(tester);
    await tester.enterText(find.byType(AppTextField).first, 'Road Trip');
    await settle(tester);
    await tester.tap(find.text(app.l10n.createLabel));
    await settle(tester);

    expect(find.text('Road Trip'), findsOneWidget);
    expect(find.text(app.l10n.playlistsEmptyTitle), findsNothing);

    await tester.tap(find.text('Road Trip'));
    await settle(tester);

    expect(find.text(app.l10n.playlistEmptyTitle), findsOneWidget);
  });

  testWidgets('favoriting from the player lists the track under Favorites', (
    tester,
  ) async {
    final app = await launchSeededApp(tester);

    await tester.tap(find.text(app.l10n.libraryTabLabel));
    await settle(tester);
    await tester.tap(find.text(app.l10n.libraryTracksTab));
    await settle(tester);
    await tester.tap(find.text(SeedData.firstTrackTitle).first);
    await settle(tester);

    expect(app.player.snapshot.playing, isTrue);

    await tester.tap(
      find.descendant(
        of: find.byType(MiniPlayer),
        matching: find.text(SeedData.firstTrackTitle),
      ),
    );
    await settle(tester);
    await tester.tap(
      find.bySemanticsLabel(app.l10n.favoriteButtonSemanticLabel).first,
    );
    await settle(tester);

    await tester.tap(
      find.bySemanticsLabel(app.l10n.backButtonSemanticLabel).first,
    );
    await settle(tester);
    await tester.tap(find.text(app.l10n.libraryFavoritesTab));
    await settle(tester);

    expect(find.text(SeedData.firstTrackTitle), findsWidgets);
    expect(find.text(app.l10n.favoritesEmptyTitle), findsNothing);
  });

  testWidgets('searching narrows the library to the matching track', (
    tester,
  ) async {
    final app = await launchSeededApp(tester);

    await tester.tap(find.text(app.l10n.searchTabLabel));
    await settle(tester);
    await tester.enterText(
      find.descendant(
        of: find.byType(AppSearchField),
        matching: find.byType(TextField),
      ),
      'Afterglow',
    );
    await settle(tester);

    expect(find.text(SeedData.secondTrackTitle), findsWidgets);
    expect(find.text(SeedData.firstTrackTitle), findsNothing);
  });

  testWidgets('choosing a language in Settings re-labels the app', (
    tester,
  ) async {
    final app = await launchSeededApp(tester);
    final portuguese = await appLocalizations('pt');

    await tester.tap(find.text(app.l10n.settingsTabLabel));
    await settle(tester);
    await tester.tap(find.text(app.l10n.settingsLanguageLabel));
    await settle(tester);
    await tester.tap(find.text('Português'));
    await settle(tester);

    expect(find.text(portuguese.libraryTabLabel), findsWidgets);
    expect(find.text(app.l10n.libraryTabLabel), findsNothing);
  });
}
