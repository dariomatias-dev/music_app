import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/add_to_playlist_sheet.dart';

import '../../../../helpers/fake_playlist_repository.dart';

Widget _app(FakePlaylistRepository repository, {String trackId = 'track-1'}) {
  return ProviderScope(
    overrides: [playlistRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: Consumer(
            builder: (context, ref, _) => TextButton(
              onPressed: () => showAddToPlaylistSheet(context, ref, trackId),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows the empty state when there are no playlists', (
    tester,
  ) async {
    await tester.pumpWidget(_app(FakePlaylistRepository()));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(
      find.text('Tap New playlist to create your first one.'),
      findsOneWidget,
    );
  });

  testWidgets('lists every playlist', (tester) async {
    final repository = FakePlaylistRepository();
    await repository.createPlaylist('Road Trip');
    await repository.createPlaylist('Focus');

    await tester.pumpWidget(_app(repository));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Road Trip'), findsOneWidget);
    expect(find.text('Focus'), findsOneWidget);
  });

  testWidgets('tapping a playlist adds the track and shows a toast', (
    tester,
  ) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');

    await tester.pumpWidget(_app(repository));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Road Trip'));
    await tester.pumpAndSettle();

    expect(find.text('Added to playlist'), findsOneWidget);
    expect(await repository.watchPlaylistTrackIds(id).first, ['track-1']);
  });

  testWidgets('adding an already-present track shows a different toast', (
    tester,
  ) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1']);

    await tester.pumpWidget(_app(repository));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Road Trip'));
    await tester.pumpAndSettle();

    expect(find.text('Already in this playlist'), findsOneWidget);
    expect(await repository.watchPlaylistTrackIds(id).first, ['track-1']);
  });
}
