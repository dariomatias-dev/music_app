import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/library/presentation/widgets/playlists_tab.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';

import '../../../../helpers/fake_playlist_repository.dart';

Future<ProviderContainer> _pumpPlaylistsTab(
  WidgetTester tester,
  FakePlaylistRepository repository,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [playlistRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: PlaylistsTab()),
      ),
    ),
  );
  await tester.pump();

  final element = tester.element(find.byType(PlaylistsTab));
  return ProviderScope.containerOf(element);
}

void main() {
  testWidgets('shows the empty state when there are no playlists', (
    tester,
  ) async {
    await _pumpPlaylistsTab(tester, FakePlaylistRepository());

    expect(find.text('No playlists yet'), findsOneWidget);
  });

  testWidgets('lists playlists with their track count', (tester) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1', 'track-2']);

    await _pumpPlaylistsTab(tester, repository);
    await tester.pump();

    expect(find.text('Road Trip'), findsOneWidget);
    expect(find.text('2 tracks'), findsOneWidget);
  });

  testWidgets('creating a playlist adds it to the list', (tester) async {
    await _pumpPlaylistsTab(tester, FakePlaylistRepository());

    await tester.tap(find.text('New playlist'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Focus');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('Focus'), findsOneWidget);
  });

  testWidgets('renaming a playlist updates its name', (tester) async {
    final repository = FakePlaylistRepository();
    await repository.createPlaylist('Road Trip');

    await _pumpPlaylistsTab(tester, repository);
    await tester.pump();

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rename'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Long Drive');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Long Drive'), findsOneWidget);
    expect(find.text('Road Trip'), findsNothing);
  });

  testWidgets('duplicating a playlist copies its tracks', (tester) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1']);

    await _pumpPlaylistsTab(tester, repository);
    await tester.pump();

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Duplicate'));
    await tester.pumpAndSettle();

    expect(find.text('Road Trip copy'), findsOneWidget);
    expect(find.text('1 track'), findsNWidgets(2));
  });

  testWidgets('deleting a playlist requires confirmation', (tester) async {
    final repository = FakePlaylistRepository();
    await repository.createPlaylist('Road Trip');

    await _pumpPlaylistsTab(tester, repository);
    await tester.pump();

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Delete playlist?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Road Trip'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Road Trip'), findsNothing);
    expect(find.text('No playlists yet'), findsOneWidget);
  });
}
