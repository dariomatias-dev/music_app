import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/playlist/presentation/screens/playlist_screen.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_cover_art.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fake_playlist_repository.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository(this.tracks);

  final List<Track> tracks;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const [
    Artist(
      id: 'artist-1',
      sourceId: 'artist-1',
      name: 'Charcoal',
      albumCount: 1,
      trackCount: 2,
    ),
    Artist(
      id: 'artist-2',
      sourceId: 'artist-2',
      name: 'Amber',
      albumCount: 1,
      trackCount: 1,
    ),
  ]);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const []);

  @override
  Stream<IndexingProgress> reindex() => const Stream.empty();

  @override
  Future<void> purgeMissingTracks() async {}

  @override
  Future<void> updateTrackTags(
    String trackId, {
    required String title,
    required String artist,
    required String album,
  }) async {}

  @override
  Future<void> clearArtworkCache() async {}
}

Track _track({
  required String id,
  required String title,
  String artistId = 'artist-1',
  Duration duration = const Duration(minutes: 3),
}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: '/music/$id.mp3',
    title: title,
    artistId: artistId,
    albumId: 'album-1',
    duration: duration,
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
  );
}

Future<ProviderContainer> _pumpPlaylistScreen(
  WidgetTester tester, {
  required FakePlaylistRepository playlistRepository,
  required List<Track> tracks,
  required String playlistId,
}) async {
  final service = FakeAudioPlayerService();
  final handler = MusicAudioHandler(service);
  addTearDown(handler.dispose);

  final router = GoRouter(
    initialLocation: '/playlists/$playlistId',
    routes: [
      GoRoute(
        name: 'playlist',
        path: '/playlists/:playlistId',
        builder: (context, state) =>
            PlaylistScreen(playlistId: state.pathParameters['playlistId']!),
      ),
      GoRoute(
        name: 'player',
        path: '/player',
        builder: (context, state) =>
            const Scaffold(body: Text('Player screen reached')),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        audioPlayerServiceProvider.overrideWithValue(service),
        audioHandlerProvider.overrideWithValue(handler),
        libraryRepositoryProvider.overrideWithValue(
          _FakeLibraryRepository(tracks),
        ),
        playlistRepositoryProvider.overrideWithValue(playlistRepository),
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
  await tester.pump();

  final element = tester.element(find.byType(PlaylistScreen));
  return ProviderScope.containerOf(element);
}

void main() {
  testWidgets('shows the empty state for a playlist with no tracks', (
    tester,
  ) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');

    await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: const [],
      playlistId: id,
    );

    expect(find.text('This playlist is empty'), findsOneWidget);
  });

  testWidgets('shows tracks and the total duration', (tester) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1', 'track-2']);

    await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      playlistId: id,
    );

    expect(find.text('Night Drive'), findsOneWidget);
    expect(find.text('Sunset'), findsOneWidget);
    expect(find.text('2 tracks · 6:00'), findsOneWidget);
  });

  testWidgets('tapping a track plays from that position', (tester) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1', 'track-2']);

    final container = await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      playlistId: id,
    );

    await tester.tap(find.text('Sunset'));
    await tester.pump(const Duration(milliseconds: 50));

    final service = container.read(audioPlayerServiceProvider);
    expect(service.snapshot.currentIndex, 1);
  });

  testWidgets('removing a track requires confirmation', (tester) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1', 'track-2']);

    await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      playlistId: id,
    );

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reorder tracks'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.remove_circle_outline), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.remove_circle_outline).first);
    await tester.pumpAndSettle();

    expect(find.text('Remove track?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(await repository.watchPlaylistTrackIds(id).first, ['track-2']);
  });

  testWidgets('tapping Play plays the whole playlist from the start', (
    tester,
  ) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1', 'track-2']);

    final container = await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      playlistId: id,
    );

    await tester.tap(find.text('Play'));
    await tester.pump(const Duration(milliseconds: 50));

    final service = container.read(audioPlayerServiceProvider);
    expect(service.snapshot.currentIndex, 0);
    expect(service.snapshot.queueLength, 2);
  });

  testWidgets('tapping Shuffle plays the playlist in some order', (
    tester,
  ) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1', 'track-2']);

    final container = await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      playlistId: id,
    );

    await tester.tap(find.text('Shuffle'));
    await tester.pump(const Duration(milliseconds: 50));

    final service = container.read(audioPlayerServiceProvider);
    expect(service.snapshot.currentIndex, 0);
    expect(service.snapshot.queueLength, 2);
  });

  testWidgets('shows a composed cover for the playlist', (tester) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1', 'track-2']);

    await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      playlistId: id,
    );

    expect(find.byType(PlaylistCoverArt), findsOneWidget);
  });

  testWidgets('shows a playback indicator on the currently playing row', (
    tester,
  ) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1', 'track-2']);

    await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      playlistId: id,
    );

    expect(find.byType(AppPlaybackIndicator), findsNothing);

    await tester.tap(find.text('Sunset'));
    await tester.pump(const Duration(milliseconds: 50));

    // One in the track row, one in the mini player docked below.
    expect(find.byType(AppPlaybackIndicator), findsWidgets);
  });

  testWidgets('shows the playlist description when set', (tester) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.updatePlaylistDescription(id, 'Songs for the highway');

    await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: const [],
      playlistId: id,
    );

    expect(find.text('Songs for the highway'), findsOneWidget);
  });

  testWidgets('tapping the favorite icon favorites the playlist', (
    tester,
  ) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');

    await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: const [],
      playlistId: id,
    );

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect((await repository.watchPlaylist(id).first)?.isFavorite, isTrue);
  });

  testWidgets('searching filters the track list by title', (tester) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1', 'track-2']);

    await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      playlistId: id,
    );

    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'sun');
    await tester.pump();

    expect(find.text('Sunset'), findsOneWidget);
    expect(find.text('Night Drive'), findsNothing);
  });

  testWidgets('switching sort order re-sorts the track list', (tester) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1', 'track-2']);

    await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: [
        _track(id: 'track-1', title: 'Zebra'),
        _track(id: 'track-2', title: 'Apple'),
      ],
      playlistId: id,
    );

    final titlesBefore = tester
        .widgetList<Text>(find.byType(Text))
        .map((widget) => widget.data)
        .whereType<String>();
    expect(
      titlesBefore.toList().indexOf('Zebra') <
          titlesBefore.toList().indexOf('Apple'),
      isTrue,
    );

    await tester.tap(find.text('Playlist order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Title'));
    await tester.pumpAndSettle();

    final titlesAfter = tester
        .widgetList<Text>(find.byType(Text))
        .map((widget) => widget.data)
        .whereType<String>()
        .toList();
    expect(titlesAfter.indexOf('Apple') < titlesAfter.indexOf('Zebra'), isTrue);
  });

  testWidgets(
    'removing a track from its more menu takes it out of the playlist',
    (tester) async {
      final repository = FakePlaylistRepository();
      final id = await repository.createPlaylist('Road Trip');
      await repository.setPlaylistTracks(id, ['track-1', 'track-2']);

      await _pumpPlaylistScreen(
        tester,
        playlistRepository: repository,
        tracks: [
          _track(id: 'track-1', title: 'Night Drive'),
          _track(id: 'track-2', title: 'Sunset'),
        ],
        playlistId: id,
      );

      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove from playlist'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(await repository.watchPlaylistTrackIds(id).first, ['track-2']);
    },
  );

  /// The visible track titles, in the order the list renders them.
  List<String> visibleTitles(WidgetTester tester, List<String> candidates) {
    final texts = tester
        .widgetList<Text>(find.byType(Text))
        .map((widget) => widget.data)
        .whereType<String>()
        .toList();
    return texts.where(candidates.contains).toList();
  }

  Future<String> seedTwoTracks(
    WidgetTester tester,
    FakePlaylistRepository repository,
    List<Track> tracks,
  ) async {
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(
      id,
      tracks.map((track) => track.id).toList(),
    );

    await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: tracks,
      playlistId: id,
    );
    return id;
  }

  Future<void> pickSort(WidgetTester tester, String label) async {
    await tester.tap(find.text('Playlist order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  testWidgets('sorting by artist orders the tracks by artist name', (
    tester,
  ) async {
    await seedTwoTracks(tester, FakePlaylistRepository(), [
      _track(id: 'track-1', title: 'Zebra'),
      _track(id: 'track-2', title: 'Apple', artistId: 'artist-2'),
    ]);

    await pickSort(tester, 'Artist');

    expect(visibleTitles(tester, ['Zebra', 'Apple']), ['Apple', 'Zebra']);
  });

  testWidgets('sorting by duration puts the longest track first', (
    tester,
  ) async {
    await seedTwoTracks(tester, FakePlaylistRepository(), [
      _track(
        id: 'track-1',
        title: 'Short',
        duration: const Duration(minutes: 2),
      ),
      _track(
        id: 'track-2',
        title: 'Long',
        duration: const Duration(minutes: 9),
      ),
    ]);

    await pickSort(tester, 'Duration');

    expect(visibleTitles(tester, ['Short', 'Long']), ['Long', 'Short']);
  });

  testWidgets('clearing the search field restores every track', (tester) async {
    await seedTwoTracks(tester, FakePlaylistRepository(), [
      _track(id: 'track-1', title: 'Night Drive'),
      _track(id: 'track-2', title: 'Sunset'),
    ]);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'sun');
    await tester.pumpAndSettle();
    expect(find.text('Night Drive'), findsNothing);

    await tester.tap(find.bySemanticsLabel('Clear search'));
    await tester.pumpAndSettle();

    expect(find.text('Night Drive'), findsOneWidget);
    expect(find.text('Sunset'), findsOneWidget);
  });

  testWidgets('closing the search bar drops the term with it', (tester) async {
    await seedTwoTracks(tester, FakePlaylistRepository(), [
      _track(id: 'track-1', title: 'Night Drive'),
      _track(id: 'track-2', title: 'Sunset'),
    ]);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'sun');
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.search).first);
    await tester.pumpAndSettle();

    expect(find.text('Night Drive'), findsOneWidget);
    expect(find.text('Sunset'), findsOneWidget);
  });

  group('reordering', () {
    Future<void> enterReorderMode(WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reorder tracks'));
      await tester.pumpAndSettle();
    }

    testWidgets('the more menu switches the list into reorder mode', (
      tester,
    ) async {
      await seedTwoTracks(tester, FakePlaylistRepository(), [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ]);

      await enterReorderMode(tester);

      expect(find.byType(ReorderableListView), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('Done leaves reorder mode', (tester) async {
      await seedTwoTracks(tester, FakePlaylistRepository(), [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ]);
      await enterReorderMode(tester);

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(find.byType(ReorderableListView), findsNothing);
    });

    testWidgets('dragging a track persists the new order', (tester) async {
      final repository = FakePlaylistRepository();
      final id = await seedTwoTracks(tester, repository, [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ]);
      await enterReorderMode(tester);

      final handles = find.byIcon(Icons.drag_handle_rounded);
      final rowHeight =
          tester.getCenter(handles.at(1)).dy -
          tester.getCenter(handles.first).dy;

      final drag = await tester.startGesture(tester.getCenter(handles.first));
      await tester.pump(const Duration(milliseconds: 100));
      for (var moved = 0.0; moved < rowHeight; moved += rowHeight / 4) {
        await drag.moveBy(Offset(0, rowHeight / 4));
        await tester.pump(const Duration(milliseconds: 20));
      }
      await drag.up();
      await tester.pumpAndSettle();

      expect(await repository.watchPlaylistTrackIds(id).first, [
        'track-2',
        'track-1',
      ]);
    });
  });
}
