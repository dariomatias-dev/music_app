import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/player/data/providers/player_data_providers.dart';
import 'package:music_app/src/features/player/presentation/screens/lyrics_screen.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fake_lyrics_repository.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository();

  @override
  Stream<List<Track>> watchTracks() => const Stream.empty();

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const [
    Album(
      id: 'album-1',
      sourceId: 'album-1',
      title: 'Chill Vibes',
      artistId: 'artist-1',
      trackCount: 1,
      totalDuration: Duration(minutes: 3),
    ),
  ]);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const [
    Artist(
      id: 'artist-1',
      sourceId: 'artist-1',
      name: 'Charcoal',
      albumCount: 1,
      trackCount: 1,
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

Track _track() {
  return Track(
    id: 'track-1',
    sourceId: 'track-1',
    filePath: '/music/track-1.mp3',
    title: 'Night Drive',
    artistId: 'artist-1',
    albumId: 'album-1',
    duration: const Duration(minutes: 3),
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
  );
}

Future<ProviderContainer> _pumpWithTrack(
  WidgetTester tester, {
  String? lyricsContent,
  FakeLyricsRepository? lyricsRepository,
}) async {
  final service = FakeAudioPlayerService();
  final handler = MusicAudioHandler(service);
  addTearDown(handler.dispose);

  await tester.pumpWidget(
    ProviderScope(
      // Disables the default retry-with-backoff so a repository that
      // throws settles into AsyncError on the first attempt.
      retry: (retryCount, error) => null,
      overrides: [
        audioPlayerServiceProvider.overrideWithValue(service),
        audioHandlerProvider.overrideWithValue(handler),
        libraryRepositoryProvider.overrideWithValue(
          const _FakeLibraryRepository(),
        ),
        lyricsRepositoryProvider.overrideWithValue(
          lyricsRepository ?? FakeLyricsRepository(content: lyricsContent),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const LyricsScreen(),
      ),
    ),
  );

  final element = tester.element(find.byType(LyricsScreen));
  final container = ProviderScope.containerOf(element);
  await container.read(queueViewModelProvider.notifier).playFromSource([
    _track(),
  ], startIndex: 0);
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump();
  return container;
}

void main() {
  testWidgets('shows the empty state when nothing is playing', (
    tester,
  ) async {
    final service = FakeAudioPlayerService();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [audioPlayerServiceProvider.overrideWithValue(service)],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const LyricsScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Nothing playing'), findsOneWidget);
  });

  testWidgets('shows the empty state when there are no lyrics', (
    tester,
  ) async {
    await _pumpWithTrack(tester);

    expect(find.text('No lyrics found'), findsOneWidget);
  });

  testWidgets(
    'shows the empty state when resolving lyrics fails, instead of an '
    'unhandled error',
    (tester) async {
      await _pumpWithTrack(
        tester,
        lyricsRepository: FakeLyricsRepository.throwing(),
      );

      expect(find.text('No lyrics found'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('shows plain lyrics lines once resolved', (tester) async {
    await _pumpWithTrack(tester, lyricsContent: 'Line one\nLine two');

    expect(find.text('Line one'), findsOneWidget);
    expect(find.text('Line two'), findsOneWidget);
  });

  testWidgets('tapping a synced line seeks to its timestamp', (
    tester,
  ) async {
    final container = await _pumpWithTrack(
      tester,
      lyricsContent: '[00:01.00]One\n[00:05.00]Two',
    );

    await tester.tap(find.text('Two'));
    await tester.pump();

    final service = container.read(audioPlayerServiceProvider);
    expect(service.snapshot.position, const Duration(seconds: 5));
  });
}
