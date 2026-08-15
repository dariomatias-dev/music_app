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
import 'package:music_app/src/features/player/presentation/screens/playback_screen.dart';
import 'package:music_app/src/features/player/presentation/widgets/playback_cover.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fake_favorite_repository.dart';

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
  Future<void> clearArtworkCache() async {}
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
          home: const PlaybackScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Nothing playing'), findsOneWidget);
  });

  testWidgets('shows the cover once a track is playing', (tester) async {
    final service = FakeAudioPlayerService();
    final handler = MusicAudioHandler(service);
    addTearDown(handler.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioPlayerServiceProvider.overrideWithValue(service),
          audioHandlerProvider.overrideWithValue(handler),
          libraryRepositoryProvider.overrideWithValue(
            const _FakeLibraryRepository(),
          ),
          favoriteRepositoryProvider.overrideWithValue(
            FakeFavoriteRepository(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PlaybackScreen(),
        ),
      ),
    );

    final element = tester.element(find.byType(PlaybackScreen));
    final container = ProviderScope.containerOf(element);
    await container.read(queueViewModelProvider.notifier).playFromSource([
      Track(
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
      ),
    ], startIndex: 0);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(PlaybackCover), findsOneWidget);
    expect(find.text('Nothing playing'), findsNothing);
  });
}
