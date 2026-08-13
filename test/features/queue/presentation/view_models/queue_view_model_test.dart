import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/audio/audio_player_service.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

import '../../../../helpers/fake_audio_player_service.dart';

class _FakeLibraryRepository implements LibraryRepository {
  _FakeLibraryRepository({this.artists = const [], this.albums = const []});

  final List<Artist> artists;
  final List<Album> albums;

  @override
  Stream<List<Track>> watchTracks() => const Stream.empty();

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(albums);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(artists);

  @override
  Stream<IndexingProgress> reindex() => const Stream.empty();

  @override
  Future<void> purgeMissingTracks() async {}
}

Track _track(
  String id, {
  String artistId = 'artist-1',
  String albumId = 'album-1',
}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: '/music/$id.mp3',
    title: 'Track $id',
    artistId: artistId,
    albumId: albumId,
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
  late ProviderContainer container;

  setUp(() {
    playerService = FakeAudioPlayerService();
    handler = MusicAudioHandler(playerService);
    container = ProviderContainer(
      overrides: [
        audioPlayerServiceProvider.overrideWithValue(playerService),
        audioHandlerProvider.overrideWithValue(handler),
        libraryRepositoryProvider.overrideWithValue(
          _FakeLibraryRepository(
            artists: const [
              Artist(
                id: 'artist-1',
                sourceId: 'artist-1',
                name: 'Charcoal',
                albumCount: 1,
                trackCount: 2,
              ),
            ],
            albums: const [
              Album(
                id: 'album-1',
                sourceId: 'album-1',
                title: 'Chill Vibes',
                artistId: 'artist-1',
                trackCount: 2,
                totalDuration: Duration(minutes: 6),
                artworkPath: '/cache/album-1.jpg',
              ),
            ],
          ),
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
    return handler.dispose();
  });

  test('playFromSource loads the queue and starts playing', () async {
    final tracks = [_track('a'), _track('b')];

    await container
        .read(queueViewModelProvider.notifier)
        .playFromSource(tracks, startIndex: 1);

    expect(container.read(queueViewModelProvider), tracks);
    expect(playerService.snapshot.queueLength, 2);
    expect(playerService.snapshot.currentIndex, 1);
    expect(playerService.snapshot.playing, isTrue);
    expect(handler.queue.value.map((m) => m.artist), ['Charcoal', 'Charcoal']);
    expect(handler.queue.value.map((m) => m.album), [
      'Chill Vibes',
      'Chill Vibes',
    ]);
  });

  test('addToEnd appends the track to state and the engine queue', () async {
    await container.read(queueViewModelProvider.notifier).playFromSource([
      _track('a'),
    ], startIndex: 0);

    await container.read(queueViewModelProvider.notifier).addToEnd(_track('b'));

    expect(
      container.read(queueViewModelProvider).map((t) => t.id),
      ['a', 'b'],
    );
    expect(playerService.snapshot.queueLength, 2);
  });

  test('playNext inserts right after the current index', () async {
    await container.read(queueViewModelProvider.notifier).playFromSource([
      _track('a'),
      _track('b'),
    ], startIndex: 0);

    await container.read(queueViewModelProvider.notifier).playNext(_track('c'));

    expect(
      container.read(queueViewModelProvider).map((t) => t.id),
      ['a', 'c', 'b'],
    );
  });

  test('setShuffleModeEnabled and setLoopMode reach the player', () async {
    await container
        .read(queueViewModelProvider.notifier)
        .setShuffleModeEnabled(enabled: true);
    await container
        .read(queueViewModelProvider.notifier)
        .setLoopMode(AudioLoopMode.queue);

    expect(playerService.snapshot.shuffleModeEnabled, isTrue);
    expect(playerService.snapshot.loopMode, AudioLoopMode.queue);
  });
}
