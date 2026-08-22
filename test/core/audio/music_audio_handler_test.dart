import 'package:audio_service/audio_service.dart' as audio_service;
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';

import '../../helpers/fake_audio_player_service.dart';

void main() {
  late FakeAudioPlayerService playerService;
  late MusicAudioHandler handler;

  setUp(() {
    playerService = FakeAudioPlayerService();
    handler = MusicAudioHandler(playerService);
  });

  tearDown(() => handler.dispose());

  test('setQueue publishes the queue and loads it into the player', () async {
    await handler.setQueue(const [
      QueueMediaItem(id: 'track-1', filePath: '/music/a.mp3', title: 'A'),
      QueueMediaItem(id: 'track-2', filePath: '/music/b.mp3', title: 'B'),
    ]);

    expect(handler.queue.value, hasLength(2));
    expect(handler.queue.value.first.id, 'track-1');
    expect(playerService.snapshot.queueLength, 2);
  });

  test('setQueue publishes the current media item', () async {
    await handler.setQueue(const [
      QueueMediaItem(id: 'track-1', filePath: '/music/a.mp3', title: 'A'),
    ]);

    expect(handler.mediaItem.value?.id, 'track-1');
  });

  test('play and pause forward to the player service', () async {
    await handler.play();
    expect(playerService.snapshot.playing, isTrue);
    expect(handler.playbackState.value.playing, isTrue);

    await handler.pause();
    expect(playerService.snapshot.playing, isFalse);
    expect(handler.playbackState.value.playing, isFalse);
  });

  test('skipToNext forwards to the player service', () async {
    await handler.setQueue(const [
      QueueMediaItem(id: 'track-1', filePath: '/music/a.mp3', title: 'A'),
      QueueMediaItem(id: 'track-2', filePath: '/music/b.mp3', title: 'B'),
    ]);

    await handler.skipToNext();

    expect(playerService.snapshot.currentIndex, 1);
    expect(handler.mediaItem.value?.id, 'track-2');
  });

  test('stop forwards to the player service', () async {
    await handler.setQueue(const [
      QueueMediaItem(id: 'track-1', filePath: '/music/a.mp3', title: 'A'),
    ]);
    await handler.play();

    await handler.stop();

    expect(playerService.snapshot.playing, isFalse);
  });

  test('seek forwards the position to the player service', () async {
    await handler.setQueue(const [
      QueueMediaItem(id: 'track-1', filePath: '/music/a.mp3', title: 'A'),
    ]);

    await handler.seek(const Duration(seconds: 45));

    expect(playerService.snapshot.position, const Duration(seconds: 45));
  });

  test('skipToPrevious forwards to the player service', () async {
    await handler.setQueue(const [
      QueueMediaItem(id: 'track-1', filePath: '/music/a.mp3', title: 'A'),
      QueueMediaItem(id: 'track-2', filePath: '/music/b.mp3', title: 'B'),
    ], initialIndex: 1);

    await handler.skipToPrevious();

    expect(playerService.snapshot.currentIndex, 0);
    expect(handler.mediaItem.value?.id, 'track-1');
  });

  test('setSpeed forwards to the player service', () async {
    await handler.setSpeed(1.5);

    expect(playerService.snapshot.speed, 1.5);
  });

  test('setRepeatMode maps every mode the OS can send', () async {
    const cases = {
      audio_service.AudioServiceRepeatMode.none: 'off',
      audio_service.AudioServiceRepeatMode.one: 'track',
      audio_service.AudioServiceRepeatMode.all: 'queue',
      audio_service.AudioServiceRepeatMode.group: 'queue',
    };

    for (final entry in cases.entries) {
      await handler.setRepeatMode(entry.key);

      expect(playerService.snapshot.loopMode.name, entry.value);
    }
  });

  test('setRepeatMode forwards the mapped loop mode', () async {
    await handler.setRepeatMode(audio_service.AudioServiceRepeatMode.one);

    expect(playerService.snapshot.loopMode.name, 'track');
    expect(
      handler.playbackState.value.repeatMode,
      audio_service.AudioServiceRepeatMode.one,
    );
  });

  test('setShuffleMode forwards enabled state', () async {
    await handler.setShuffleMode(audio_service.AudioServiceShuffleMode.all);

    expect(playerService.snapshot.shuffleModeEnabled, isTrue);
    expect(
      handler.playbackState.value.shuffleMode,
      audio_service.AudioServiceShuffleMode.all,
    );
  });

  test('playbackState mirrors the player snapshot on changes', () async {
    await handler.setQueue(const [
      QueueMediaItem(id: 'track-1', filePath: '/music/a.mp3', title: 'A'),
    ]);
    await handler.play();

    expect(
      handler.playbackState.value.processingState,
      audio_service.AudioProcessingState.ready,
    );
    expect(handler.playbackState.value.queueIndex, 0);
  });

  test('does not rebroadcast to the OS on ordinary position ticks', () async {
    await handler.setQueue(const [
      QueueMediaItem(id: 'track-1', filePath: '/music/a.mp3', title: 'A'),
    ]);
    await handler.play();
    final positionAfterPlay = handler.playbackState.value.updatePosition;

    // Ordinary ticks, matching the engine's real ~200ms granularity.
    await playerService.seek(const Duration(milliseconds: 200));
    await playerService.seek(const Duration(milliseconds: 400));
    await playerService.seek(const Duration(milliseconds: 600));

    expect(handler.playbackState.value.updatePosition, positionAfterPlay);
    expect(playerService.snapshot.position, const Duration(milliseconds: 600));
  });

  test('rebroadcasts to the OS on a real seek', () async {
    await handler.setQueue(const [
      QueueMediaItem(id: 'track-1', filePath: '/music/a.mp3', title: 'A'),
    ]);
    await handler.play();

    await playerService.seek(const Duration(seconds: 30));

    expect(
      handler.playbackState.value.updatePosition,
      const Duration(seconds: 30),
    );
  });
}
