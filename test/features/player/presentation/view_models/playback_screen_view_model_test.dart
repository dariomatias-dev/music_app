import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_screen_view_model.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fake_key_value_storage.dart';

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
}

void main() {
  late FakeAudioPlayerService service;
  late MusicAudioHandler handler;
  late ProviderContainer container;

  setUp(() {
    service = FakeAudioPlayerService();
    handler = MusicAudioHandler(service);
    container = ProviderContainer(
      overrides: [
        audioPlayerServiceProvider.overrideWithValue(service),
        audioHandlerProvider.overrideWithValue(handler),
        libraryRepositoryProvider.overrideWithValue(
          const _FakeLibraryRepository(),
        ),
        keyValueStorageProvider.overrideWithValue(FakeKeyValueStorage()),
      ],
    );
    addTearDown(
      container.listen(playbackScreenViewModelProvider, (_, _) {}).close,
    );
  });

  tearDown(() {
    container.dispose();
    return handler.dispose();
  });

  test('is null when nothing is playing', () {
    expect(container.read(playbackScreenViewModelProvider), isNull);
  });

  test('reflects the current queue item once playing', () async {
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
    await Future<void>.delayed(Duration.zero);

    final current = container.read(playbackScreenViewModelProvider);
    expect(current?.title, 'Night Drive');
    expect(current?.artist, 'Charcoal');
  });

  test('is null again once the queue is cleared', () async {
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
    await Future<void>.delayed(Duration.zero);
    expect(container.read(playbackScreenViewModelProvider), isNotNull);

    await service.setQueue(const []);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(playbackScreenViewModelProvider), isNull);
  });
}
