import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/core/navigation/route_names.dart';
import 'package:music_app/src/features/history/data/providers/history_data_providers.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/statistics/data/providers/statistics_data_providers.dart';
import 'package:music_app/src/features/statistics/domain/entities/listening_streak.dart';
import 'package:music_app/src/features/statistics/domain/entities/track_play_count.dart';
import 'package:music_app/src/features/statistics/presentation/screens/statistics_screen.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fake_play_history_repository.dart';
import '../../../../helpers/fake_statistics_repository.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository({
    this.tracks = const [],
    this.artists = const [],
  });

  final List<Track> tracks;
  final List<Artist> artists;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(artists);

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

Track _track(String id, {required String artistId}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: '/music/$id.mp3',
    title: 'Track $id',
    artistId: artistId,
    albumId: 'album-1',
    duration: const Duration(minutes: 3),
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
  );
}

Widget _app({
  FakeStatisticsRepository? statisticsRepository,
  FakePlayHistoryRepository? playHistoryRepository,
  List<Track> tracks = const [],
  List<Artist> artists = const [],
  FakeAudioPlayerService? audioService,
  GoRouter? router,
}) {
  final service = audioService ?? FakeAudioPlayerService();
  final handler = MusicAudioHandler(service);
  addTearDown(handler.dispose);

  return ProviderScope(
    overrides: [
      audioPlayerServiceProvider.overrideWithValue(service),
      audioHandlerProvider.overrideWithValue(handler),
      statisticsRepositoryProvider.overrideWithValue(
        statisticsRepository ?? FakeStatisticsRepository(),
      ),
      playHistoryRepositoryProvider.overrideWithValue(
        playHistoryRepository ?? FakePlayHistoryRepository(),
      ),
      libraryRepositoryProvider.overrideWithValue(
        _FakeLibraryRepository(tracks: tracks, artists: artists),
      ),
    ],
    child: router == null
        ? MaterialApp(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const StatisticsScreen(),
          )
        : MaterialApp.router(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
  );
}

/// The fixture the ranked lists render from.
FakeStatisticsRepository _populatedStatistics() => FakeStatisticsRepository(
  trackPlayCounts: const [TrackPlayCount(trackId: 'track-1', playCount: 3)],
  totalListenedDuration: const Duration(hours: 2, minutes: 5),
  listeningStreak: const ListeningStreak(currentDays: 2, longestDays: 5),
);

const _artist = Artist(
  id: 'artist-1',
  sourceId: 'artist-1',
  name: 'Charcoal',
  albumCount: 1,
  trackCount: 1,
);

void main() {
  testWidgets('shows the empty state when nothing was ever played', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.text('Nothing to show yet'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline_rounded), findsNothing);
  });

  testWidgets('shows totals, streak and ranked lists when there is history', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        statisticsRepository: FakeStatisticsRepository(
          trackPlayCounts: const [
            TrackPlayCount(trackId: 'track-1', playCount: 3),
          ],
          totalListenedDuration: const Duration(hours: 2, minutes: 5),
          listeningStreak: const ListeningStreak(
            currentDays: 2,
            longestDays: 5,
          ),
        ),
        tracks: [_track('track-1', artistId: 'artist-1')],
        artists: const [
          Artist(
            id: 'artist-1',
            sourceId: 'artist-1',
            name: 'Charcoal',
            albumCount: 1,
            trackCount: 1,
          ),
        ],
      ),
    );
    await tester.pump();
    await tester.pump();
    await tester.pump();

    expect(find.text('2h 5m'), findsOneWidget);
    expect(find.text('2 days'), findsOneWidget);
    expect(find.text('5 days'), findsOneWidget);
    expect(find.text('Track track-1'), findsOneWidget);
    // Once as the track's subtitle, once as the most-played-artist row.
    expect(find.text('Charcoal'), findsNWidgets(2));
    expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);
  });

  testWidgets('tapping a period segment switches the selection', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        statisticsRepository: FakeStatisticsRepository(
          trackPlayCounts: const [
            TrackPlayCount(trackId: 'track-1', playCount: 1),
          ],
        ),
        tracks: [_track('track-1', artistId: 'artist-1')],
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Month'));
    await tester.pump();

    final segmentedBar = tester.widget<AppSegmentedBar>(
      find.byType(AppSegmentedBar),
    );
    expect(segmentedBar.index, 1);
  });

  testWidgets('clearing history calls clearHistory after confirming', (
    tester,
  ) async {
    final playHistoryRepository = FakePlayHistoryRepository();
    await tester.pumpWidget(
      _app(
        statisticsRepository: FakeStatisticsRepository(
          trackPlayCounts: const [
            TrackPlayCount(trackId: 'track-1', playCount: 1),
          ],
        ),
        playHistoryRepository: playHistoryRepository,
        tracks: [_track('track-1', artistId: 'artist-1')],
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.delete_outline_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(playHistoryRepository.historyCleared, isTrue);
  });

  testWidgets('tapping a most played track plays it', (tester) async {
    final service = FakeAudioPlayerService();

    await tester.pumpWidget(
      _app(
        statisticsRepository: _populatedStatistics(),
        tracks: [_track('track-1', artistId: 'artist-1')],
        artists: const [_artist],
        audioService: service,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Track track-1'));
    await tester.pump(const Duration(milliseconds: 50));

    expect(service.snapshot.queueLength, 1);
    expect(service.snapshot.playing, isTrue);
  });

  testWidgets('tapping a most played artist opens their screen', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const StatisticsScreen(),
        ),
        GoRoute(
          name: RouteNames.artist,
          path: '/artists/:artistId',
          builder: (context, state) => Scaffold(
            body: Text('Artist ${state.pathParameters['artistId']}'),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      _app(
        statisticsRepository: _populatedStatistics(),
        tracks: [_track('track-1', artistId: 'artist-1')],
        artists: const [_artist],
        router: router,
      ),
    );
    await tester.pumpAndSettle();

    final artistRow = find.text('Charcoal').last;
    await tester.ensureVisible(artistRow);
    await tester.pumpAndSettle();
    await tester.tap(artistRow);
    await tester.pumpAndSettle();

    expect(find.text('Artist artist-1'), findsOneWidget);
  });
}
