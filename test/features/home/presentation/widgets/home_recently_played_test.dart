import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/features/history/data/providers/history_data_providers.dart';
import 'package:music_app/src/features/home/presentation/widgets/home_recently_played.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fake_play_history_repository.dart';

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

Track _track({required String id, required String title}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: '/music/$id.mp3',
    title: title,
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

Future<ProviderContainer> _pumpWidget(
  WidgetTester tester, {
  required List<Track> tracks,
  required List<String> recentTrackIds,
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
          _FakeLibraryRepository(tracks),
        ),
        playHistoryRepositoryProvider.overrideWithValue(
          FakePlayHistoryRepository(recentTrackIds),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: HomeRecentlyPlayed()),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();

  final element = tester.element(find.byType(HomeRecentlyPlayed));
  return ProviderScope.containerOf(element);
}

void main() {
  testWidgets('renders nothing when there is no history', (tester) async {
    await _pumpWidget(tester, tracks: const [], recentTrackIds: const []);

    expect(find.text('Recently played'), findsNothing);
  });

  testWidgets('lists recently played tracks in order', (tester) async {
    await _pumpWidget(
      tester,
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      recentTrackIds: ['track-2', 'track-1'],
    );

    expect(find.text('Recently played'), findsOneWidget);
    expect(find.text('Night Drive'), findsOneWidget);
    expect(find.text('Sunset'), findsOneWidget);
  });

  testWidgets('tapping a recent track plays from that position', (
    tester,
  ) async {
    final container = await _pumpWidget(
      tester,
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      recentTrackIds: ['track-2', 'track-1'],
    );

    await tester.tap(find.text('Sunset'));
    await tester.pump(const Duration(milliseconds: 50));

    final service = container.read(audioPlayerServiceProvider);
    expect(service.snapshot.currentIndex, 0);
  });
}
