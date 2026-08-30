import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/core/widgets/cached_square_image.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/library/presentation/widgets/tracks_tab.dart';

import '../../../../helpers/fake_audio_player_service.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository(this.tracks, {this.albumArtworkPath});

  final List<Track> tracks;
  final String? albumArtworkPath;

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
  ]);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value([
    Album(
      id: 'album-1',
      sourceId: 'album-1',
      title: 'Chill Vibes',
      artistId: 'artist-1',
      trackCount: 2,
      totalDuration: const Duration(minutes: 6),
      artworkPath: albumArtworkPath,
    ),
  ]);

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
  Duration duration = const Duration(minutes: 3),
}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: '/music/$id.mp3',
    title: title,
    artistId: 'artist-1',
    albumId: 'album-1',
    duration: duration,
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
  );
}

Future<ProviderContainer> _pumpTracksTab(
  WidgetTester tester,
  List<Track> tracks, {
  String? albumArtworkPath,
}) async {
  final service = FakeAudioPlayerService();
  final handler = MusicAudioHandler(service);
  addTearDown(handler.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        audioPlayerServiceProvider.overrideWithValue(service),
        audioHandlerProvider.overrideWithValue(handler),
        libraryRepositoryProvider.overrideWithValue(
          _FakeLibraryRepository(tracks, albumArtworkPath: albumArtworkPath),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: TracksTab()),
      ),
    ),
  );
  await tester.pump();

  final element = tester.element(find.byType(TracksTab));
  return ProviderScope.containerOf(element);
}

void main() {
  testWidgets('lists tracks sorted by title', (tester) async {
    await _pumpTracksTab(tester, [
      _track(id: 'track-1', title: 'Zebra'),
      _track(id: 'track-2', title: 'Apple'),
    ]);

    final titles = tester
        .widgetList<Text>(find.textContaining(RegExp('Apple|Zebra')))
        .map((t) => t.data)
        .toList();
    expect(titles, ['Apple', 'Zebra']);
  });

  testWidgets('shows the empty state when there are no tracks', (
    tester,
  ) async {
    await _pumpTracksTab(tester, const []);

    expect(find.text('No tracks yet'), findsOneWidget);
  });

  testWidgets('tapping a track plays from that position', (tester) async {
    final container = await _pumpTracksTab(tester, [
      _track(id: 'track-1', title: 'Apple'),
      _track(id: 'track-2', title: 'Zebra'),
    ]);

    await tester.tap(find.text('Zebra'));
    await tester.pump();

    final service = container.read(audioPlayerServiceProvider);
    expect(service.snapshot.currentIndex, 1);
  });

  testWidgets('switching sort order re-sorts the list', (tester) async {
    await _pumpTracksTab(tester, [
      _track(
        id: 'track-1',
        title: 'Zebra',
        duration: const Duration(minutes: 5),
      ),
      _track(
        id: 'track-2',
        title: 'Apple',
        duration: const Duration(minutes: 2),
      ),
    ]);

    // Defaults to title order.
    expect(
      tester
          .widgetList<Text>(find.textContaining(RegExp('Apple|Zebra')))
          .map((t) => t.data),
      ['Apple', 'Zebra'],
    );

    await tester.tap(find.byIcon(Icons.swap_vert_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Duration'));
    await tester.pumpAndSettle();

    expect(
      tester
          .widgetList<Text>(find.textContaining(RegExp('Apple|Zebra')))
          .map((t) => t.data),
      ['Zebra', 'Apple'],
    );
  });

  testWidgets('shows a playback indicator on the currently playing row', (
    tester,
  ) async {
    await _pumpTracksTab(tester, [
      _track(id: 'track-1', title: 'Apple'),
      _track(id: 'track-2', title: 'Zebra'),
    ]);

    expect(find.byType(AppPlaybackIndicator), findsNothing);

    await tester.tap(find.text('Zebra'));
    await tester.pump();
    // A second frame: the indicator subscribes to the playback state
    // itself, one level below the row that mounts it.
    await tester.pump();

    expect(find.byType(AppPlaybackIndicator), findsOneWidget);
  });

  testWidgets('the sort button meets the minimum touch target size', (
    tester,
  ) async {
    await _pumpTracksTab(tester, [_track(id: 'track-1', title: 'Apple')]);

    final size = tester.getSize(
      find.ancestor(
        of: find.byIcon(Icons.swap_vert_rounded),
        matching: find.byType(ConstrainedBox),
      ),
    );

    expect(size.width, greaterThanOrEqualTo(AppSizes.minTouchTarget));
    expect(size.height, greaterThanOrEqualTo(AppSizes.minTouchTarget));
  });

  testWidgets('shows the album cover on a row whose album has one', (
    tester,
  ) async {
    await _pumpTracksTab(
      tester,
      [_track(id: 'track-1', title: 'Night Drive')],
      albumArtworkPath: '/covers/album-1.jpg',
    );

    expect(find.byType(CachedSquareImage), findsOneWidget);
    expect(find.byType(AppArtwork), findsNothing);
    tester.takeException();
  });

  testWidgets('falls back to a procedural cover without one', (tester) async {
    await _pumpTracksTab(tester, [
      _track(id: 'track-1', title: 'Night Drive'),
    ]);

    expect(find.byType(AppArtwork), findsOneWidget);
    expect(find.byType(CachedSquareImage), findsNothing);
  });
}
