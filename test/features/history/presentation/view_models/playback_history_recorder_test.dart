import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/features/history/data/providers/history_data_providers.dart';
import 'package:music_app/src/features/history/presentation/view_models/playback_history_recorder.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/queue/data/playback_session_storage.dart';
import 'package:music_app/src/features/queue/data/providers/queue_data_providers.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fake_key_value_storage.dart';
import '../../../../helpers/fake_play_history_repository.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository();

  @override
  Stream<List<Track>> watchTracks() => const Stream.empty();

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const []);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const []);

  @override
  Stream<IndexingProgress> reindex() => const Stream.empty();

  @override
  Future<void> purgeMissingTracks() async {}
}

Track _track(String id) {
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
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
  );
}

void main() {
  late FakeAudioPlayerService playerService;
  late MusicAudioHandler handler;
  late FakePlayHistoryRepository historyRepository;
  late ProviderContainer container;
  late DateTime now;

  // Flushes pending microtasks so the just-driven playerService snapshot
  // finishes propagating through PlaybackViewModel into the recorder's
  // `ref.listen` callback before `now` moves again. Without this, several
  // driving calls made back-to-back would all be processed later, in a
  // batch, using whatever `now` happens to be by then, rather than the
  // value at the moment each one conceptually happened.
  Future<void> flush() => Future<void>.delayed(Duration.zero);

  setUp(() async {
    now = DateTime(2026);
    playerService = FakeAudioPlayerService();
    handler = MusicAudioHandler(playerService);
    historyRepository = FakePlayHistoryRepository();
    container = ProviderContainer(
      overrides: [
        audioPlayerServiceProvider.overrideWithValue(playerService),
        audioHandlerProvider.overrideWithValue(handler),
        playHistoryRepositoryProvider.overrideWithValue(historyRepository),
        libraryRepositoryProvider.overrideWithValue(
          const _FakeLibraryRepository(),
        ),
        playbackSessionStorageProvider.overrideWithValue(
          PlaybackSessionStorage(FakeKeyValueStorage()),
        ),
      ],
    );
    container.read(playbackHistoryRecorderProvider.notifier).clock = () => now;
    // Keeps the provider chain (recorder -> playback state -> queue)
    // flowing between updates; see the identical note in
    // queue_view_model_test.dart.
    addTearDown(
      container.listen(playbackViewModelProvider, (_, _) {}).close,
    );
    await flush();
  });

  tearDown(() {
    container.dispose();
    return handler.dispose();
  });

  test('does not record a play that ends before the minimum time', () async {
    await container.read(queueViewModelProvider.notifier).playFromSource([
      _track('a'),
      _track('b'),
    ], startIndex: 0);
    await flush();

    now = now.add(const Duration(seconds: 10));
    await playerService.seekToNext();
    await flush();

    expect(historyRepository.recordedPlays, isEmpty);
  });

  test('records a play once played time crosses the minimum', () async {
    await container.read(queueViewModelProvider.notifier).playFromSource([
      _track('a'),
      _track('b'),
    ], startIndex: 0);
    await flush();

    now = now.add(const Duration(seconds: 31));
    await playerService.seekToNext();
    await flush();

    expect(historyRepository.recordedPlays, ['a']);
  });

  test('records a short play that reaches completion', () async {
    await container.read(queueViewModelProvider.notifier).playFromSource([
      _track('a'),
    ], startIndex: 0);
    await flush();

    now = now.add(const Duration(seconds: 5));
    playerService.completeCurrentItemForTesting();
    await flush();

    expect(historyRepository.recordedPlays, ['a']);
  });

  test('does not accumulate time while paused', () async {
    await container.read(queueViewModelProvider.notifier).playFromSource([
      _track('a'),
      _track('b'),
    ], startIndex: 0);
    await flush();

    now = now.add(const Duration(seconds: 20));
    await playerService.pause();
    await flush();

    now = now.add(const Duration(seconds: 40));
    await playerService.play();
    await flush();

    now = now.add(const Duration(seconds: 5));
    await playerService.seekToNext();
    await flush();

    // 20s (before pause) + 5s (after resume) = 25s: still under the
    // minimum, since the 40s spent paused shouldn't count.
    expect(historyRepository.recordedPlays, isEmpty);
  });

  test('starts a fresh session for the next track', () async {
    await container.read(queueViewModelProvider.notifier).playFromSource([
      _track('a'),
      _track('b'),
    ], startIndex: 0);
    await flush();

    now = now.add(const Duration(seconds: 31));
    await playerService.seekToNext();
    await flush();

    now = now.add(const Duration(seconds: 31));
    await playerService.seekToPrevious();
    await flush();

    expect(historyRepository.recordedPlays, ['a', 'b']);
  });
}
