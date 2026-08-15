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
import 'package:music_app/src/features/queue/presentation/screens/queue_screen.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

import '../../../../helpers/fake_audio_player_service.dart';

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

Widget _app(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

void main() {
  testWidgets('shows the empty state when the queue is empty', (
    tester,
  ) async {
    final service = FakeAudioPlayerService();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [audioPlayerServiceProvider.overrideWithValue(service)],
        child: _app(const QueueScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Queue is empty'), findsOneWidget);
  });

  testWidgets('lists queue tracks and highlights the current one', (
    tester,
  ) async {
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
        ],
        child: _app(const QueueScreen()),
      ),
    );

    final element = tester.element(find.byType(QueueScreen));
    final container = ProviderScope.containerOf(element);
    await container.read(queueViewModelProvider.notifier).playFromSource([
      _track(id: 'track-1', title: 'Night Drive'),
      _track(id: 'track-2', title: 'Sunset'),
    ], startIndex: 0);
    await tester.pump();

    expect(find.text('Night Drive'), findsOneWidget);
    expect(find.text('Sunset'), findsOneWidget);
    expect(find.byType(AppPlaybackIndicator), findsOneWidget);
  });

  testWidgets('tapping a track jumps playback to it', (tester) async {
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
        ],
        child: _app(const QueueScreen()),
      ),
    );

    final element = tester.element(find.byType(QueueScreen));
    final container = ProviderScope.containerOf(element);
    await container.read(queueViewModelProvider.notifier).playFromSource([
      _track(id: 'track-1', title: 'Night Drive'),
      _track(id: 'track-2', title: 'Sunset'),
    ], startIndex: 0);
    await tester.pump();

    await tester.tap(find.text('Sunset'));
    await tester.pump();

    expect(service.snapshot.currentIndex, 1);
  });

  testWidgets('editing lets a track be removed from the queue', (
    tester,
  ) async {
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
        ],
        child: _app(const QueueScreen()),
      ),
    );

    final element = tester.element(find.byType(QueueScreen));
    final container = ProviderScope.containerOf(element);
    await container.read(queueViewModelProvider.notifier).playFromSource([
      _track(id: 'track-1', title: 'Night Drive'),
      _track(id: 'track-2', title: 'Sunset'),
    ], startIndex: 0);
    await tester.pump();

    await tester.tap(find.text('Edit'));
    await tester.pump();

    expect(find.byIcon(Icons.remove_circle_outline), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.remove_circle_outline).first);
    await tester.pump();

    expect(find.text('Night Drive'), findsNothing);
    expect(find.text('Sunset'), findsOneWidget);
    expect(container.read(queueViewModelProvider).map((t) => t.id), [
      'track-2',
    ]);
  });

  testWidgets('clearing the queue empties it after confirmation', (
    tester,
  ) async {
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
        ],
        child: _app(const QueueScreen()),
      ),
    );

    final element = tester.element(find.byType(QueueScreen));
    final container = ProviderScope.containerOf(element);
    await container.read(queueViewModelProvider.notifier).playFromSource([
      _track(id: 'track-1', title: 'Night Drive'),
    ], startIndex: 0);
    await tester.pump();

    await tester.tap(find.text('Edit'));
    await tester.pump();
    await tester.tap(find.text('Clear queue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(find.text('Queue is empty'), findsOneWidget);
    expect(container.read(queueViewModelProvider), isEmpty);
  });
}
