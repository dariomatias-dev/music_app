import 'package:app_ui/app_ui.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/core/navigation/route_names.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/queue/data/playback_session_storage.dart';
import 'package:music_app/src/features/queue/domain/playback_session.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';
import 'package:music_app/src/features/splash/presentation/screens/splash_screen.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fake_key_value_storage.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository(this.tracks);

  final List<Track> tracks;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const []);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const []);

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

Track _track({required String id, bool isMissing = false}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: '/music/$id.mp3',
    title: 'Track $id',
    artistId: 'artist-1',
    albumId: 'album-1',
    duration: const Duration(minutes: 3),
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    isMissing: isMissing,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
  );
}

Future<ProviderContainer> _pumpSplash(
  WidgetTester tester, {
  List<Track> tracks = const [],
  PlaybackSession? savedSession,
}) async {
  final database = AppDatabase(NativeDatabase.memory());
  addTearDown(database.close);

  final service = FakeAudioPlayerService();
  final handler = MusicAudioHandler(service);
  addTearDown(handler.dispose);

  final storage = FakeKeyValueStorage();
  if (savedSession != null) {
    await PlaybackSessionStorage(storage).save(savedSession);
  }

  final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: RouteNames.home,
        path: '/home',
        builder: (context, state) => const Scaffold(body: Text('Home screen')),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        keyValueStorageProvider.overrideWithValue(storage),
        audioPlayerServiceProvider.overrideWithValue(service),
        audioHandlerProvider.overrideWithValue(handler),
        libraryRepositoryProvider.overrideWithValue(
          _FakeLibraryRepository(tracks),
        ),
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

  return ProviderScope.containerOf(
    tester.element(find.byType(MaterialApp).first),
  );
}

void main() {
  testWidgets('shows the app name while it prepares', (tester) async {
    await _pumpSplash(tester);

    expect(find.text('Music App'), findsOneWidget);
    expect(find.byType(AppLoadingIndicator), findsOneWidget);

    await tester.pumpAndSettle();
  });

  testWidgets('hands off to home once preparation finishes', (tester) async {
    await _pumpSplash(tester);
    await tester.pumpAndSettle();

    expect(find.text('Home screen'), findsOneWidget);
    expect(find.byType(SplashScreen), findsNothing);
  });

  testWidgets('leaves the queue empty when no session was saved', (
    tester,
  ) async {
    final container = await _pumpSplash(
      tester,
      tracks: [_track(id: 'track-1')],
    );
    await tester.pumpAndSettle();

    expect(container.read(queueViewModelProvider), isEmpty);
  });

  testWidgets('restores the saved session into the queue', (tester) async {
    final container = await _pumpSplash(
      tester,
      tracks: [
        _track(id: 'track-1'),
        _track(id: 'track-2'),
      ],
      savedSession: const PlaybackSession(
        trackIds: ['track-1', 'track-2'],
        currentIndex: 1,
        position: Duration(seconds: 30),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      container.read(queueViewModelProvider).map((item) => item.id),
      ['track-1', 'track-2'],
    );
  });

  testWidgets('drops tracks that left the library when restoring', (
    tester,
  ) async {
    final container = await _pumpSplash(
      tester,
      tracks: [
        _track(id: 'track-1'),
        _track(id: 'track-2', isMissing: true),
      ],
      savedSession: const PlaybackSession(
        trackIds: ['track-1', 'track-2'],
        currentIndex: 0,
        position: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      container.read(queueViewModelProvider).map((item) => item.id),
      ['track-1'],
    );
  });
}
