import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/route_names.dart';
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

/// Pumps the tab behind a router, so a playlist row has somewhere to go.
Future<void> _pumpRoutedPlaylistsTab(
  WidgetTester tester,
  FakePlaylistRepository repository,
) async {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: PlaylistsTab()),
      ),
      GoRoute(
        name: RouteNames.playlist,
        path: '/playlists/:playlistId',
        builder: (context, state) => Scaffold(
          body: Text('Playlist ${state.pathParameters['playlistId']}'),
        ),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [playlistRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await tester.pump();
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
    final repository = FakePlaylistRepository();
    await _pumpPlaylistsTab(tester, repository);

    await tester.tap(find.text('New playlist'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Focus');
    // The confirm button stays disabled until the field reports a name, so
    // without this frame the tap below is a no-op and the sheet's own text
    // field satisfies the assertion instead of the created playlist.
    await tester.pump();
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(
      (await repository.watchPlaylists().first).map((p) => p.name),
      ['Focus'],
    );
    expect(find.text('Focus'), findsOneWidget);
  });

  testWidgets('dismissing the sheet creates nothing', (tester) async {
    final repository = FakePlaylistRepository();
    await _pumpPlaylistsTab(tester, repository);

    await tester.tap(find.text('New playlist'));
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.byType(TextField))).pop();
    await tester.pumpAndSettle();

    expect(await repository.watchPlaylists().first, isEmpty);
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
    await tester.enterText(find.byType(TextField).first, 'Long Drive');
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

  testWidgets('tapping a playlist opens it', (tester) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');

    await _pumpRoutedPlaylistsTab(tester, repository);
    await tester.pump();

    await tester.tap(find.text('Road Trip'));
    await tester.pumpAndSettle();

    expect(find.text('Playlist $id'), findsOneWidget);
  });
}
