import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:mocktail/mocktail.dart';
import 'package:music_app/src/core/audio/audio_player_service.dart';
import 'package:music_app/src/core/audio/just_audio_player_service.dart';
import 'package:music_app/src/core/errors/app_exception.dart';

class _MockAudioPlayer extends Mock implements ja.AudioPlayer {}

class _FakeAudioSource extends Fake implements ja.AudioSource {}

/// Drives a [ja.AudioPlayer] mock through the streams the service listens to.
class _PlayerStreams {
  final playbackEvent = StreamController<ja.PlaybackEvent>.broadcast();
  final playing = StreamController<bool>.broadcast();
  final speed = StreamController<double>.broadcast();
  final loopMode = StreamController<ja.LoopMode>.broadcast();
  final shuffle = StreamController<bool>.broadcast();
  final position = StreamController<Duration>.broadcast();
  final error = StreamController<ja.PlayerException>.broadcast();

  Future<void> close() async {
    await playbackEvent.close();
    await playing.close();
    await speed.close();
    await loopMode.close();
    await shuffle.close();
    await position.close();
    await error.close();
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeAudioSource());
    registerFallbackValue(ja.LoopMode.off);
    registerFallbackValue(Duration.zero);
  });

  late _MockAudioPlayer player;
  late _PlayerStreams streams;
  late JustAudioPlayerService service;

  setUp(() {
    player = _MockAudioPlayer();
    streams = _PlayerStreams();

    when(() => player.playbackEventStream).thenAnswer(
      (_) => streams.playbackEvent.stream,
    );
    when(() => player.playingStream).thenAnswer((_) => streams.playing.stream);
    when(() => player.speedStream).thenAnswer((_) => streams.speed.stream);
    when(() => player.loopModeStream).thenAnswer(
      (_) => streams.loopMode.stream,
    );
    when(() => player.shuffleModeEnabledStream).thenAnswer(
      (_) => streams.shuffle.stream,
    );
    when(() => player.positionStream).thenAnswer(
      (_) => streams.position.stream,
    );
    when(() => player.errorStream).thenAnswer((_) => streams.error.stream);
    when(() => player.audioSources).thenReturn(const []);
    when(() => player.currentIndex).thenReturn(null);

    service = JustAudioPlayerService(player);
  });

  tearDown(() async {
    await streams.close();
  });

  /// Emits [event] and lets the service's listener run.
  Future<void> emit<T>(StreamController<T> controller, T event) async {
    controller.add(event);
    await Future<void>.delayed(Duration.zero);
  }

  group('snapshot', () {
    test('starts empty', () {
      expect(service.snapshot.playing, isFalse);
      expect(service.snapshot.position, Duration.zero);
      expect(service.snapshot.queueLength, 0);
      expect(service.snapshot.processingState, AudioProcessingState.idle);
    });

    test('follows the playing stream', () async {
      await emit(streams.playing, true);

      expect(service.snapshot.playing, isTrue);
    });

    test('follows the position stream', () async {
      await emit(streams.position, const Duration(seconds: 42));

      expect(service.snapshot.position, const Duration(seconds: 42));
    });

    test('follows the speed stream', () async {
      await emit(streams.speed, 1.5);

      expect(service.snapshot.speed, 1.5);
    });

    test('follows the shuffle stream', () async {
      await emit(streams.shuffle, true);

      expect(service.snapshot.shuffleModeEnabled, isTrue);
    });

    test('publishes every change on the snapshot stream', () async {
      final seen = <bool>[];
      final subscription = service.snapshotStream.listen(
        (snapshot) => seen.add(snapshot.playing),
      );
      addTearDown(subscription.cancel);

      await emit(streams.playing, true);
      await emit(streams.playing, false);

      expect(seen, [true, false]);
    });
  });

  group('playback events', () {
    test('carry duration, buffer and index into the snapshot', () async {
      await emit(
        streams.playbackEvent,
        ja.PlaybackEvent(
          processingState: ja.ProcessingState.ready,
          duration: const Duration(minutes: 3),
          bufferedPosition: const Duration(seconds: 90),
          currentIndex: 2,
        ),
      );

      expect(service.snapshot.processingState, AudioProcessingState.ready);
      expect(service.snapshot.duration, const Duration(minutes: 3));
      expect(service.snapshot.bufferedPosition, const Duration(seconds: 90));
      expect(service.snapshot.currentIndex, 2);
    });

    test('leave the values owned by other streams alone', () async {
      await emit(streams.playing, true);
      await emit(streams.position, const Duration(seconds: 10));
      await emit<double>(streams.speed, 2);

      await emit(
        streams.playbackEvent,
        ja.PlaybackEvent(processingState: ja.ProcessingState.buffering),
      );

      expect(service.snapshot.playing, isTrue);
      expect(service.snapshot.position, const Duration(seconds: 10));
      expect(service.snapshot.speed, 2);
    });

    test('map every processing state', () async {
      const cases = {
        ja.ProcessingState.idle: AudioProcessingState.idle,
        ja.ProcessingState.loading: AudioProcessingState.loading,
        ja.ProcessingState.buffering: AudioProcessingState.buffering,
        ja.ProcessingState.ready: AudioProcessingState.ready,
        ja.ProcessingState.completed: AudioProcessingState.completed,
      };

      for (final entry in cases.entries) {
        await emit(
          streams.playbackEvent,
          ja.PlaybackEvent(processingState: entry.key),
        );

        expect(service.snapshot.processingState, entry.value);
      }
    });
  });

  group('errors', () {
    test('a player failure surfaces as a PlaybackException', () async {
      final errors = <PlaybackException>[];
      final subscription = service.errorStream.listen(errors.add);
      addTearDown(subscription.cancel);

      await emit(streams.error, ja.PlayerException(1, 'boom', 0));

      expect(errors, hasLength(1));
      expect(errors.single.message, 'Playback failed.');
      expect(errors.single.cause, isA<ja.PlayerException>());
    });
  });

  group('loop mode', () {
    test('translates every mode to just_audio', () async {
      when(() => player.setLoopMode(any())).thenAnswer((_) async {});

      await service.setLoopMode(AudioLoopMode.off);
      await service.setLoopMode(AudioLoopMode.track);
      await service.setLoopMode(AudioLoopMode.queue);

      verify(() => player.setLoopMode(ja.LoopMode.off)).called(1);
      verify(() => player.setLoopMode(ja.LoopMode.one)).called(1);
      verify(() => player.setLoopMode(ja.LoopMode.all)).called(1);
    });

    test('translates every mode back from just_audio', () async {
      const cases = {
        ja.LoopMode.off: AudioLoopMode.off,
        ja.LoopMode.one: AudioLoopMode.track,
        ja.LoopMode.all: AudioLoopMode.queue,
      };

      for (final entry in cases.entries) {
        await emit(streams.loopMode, entry.key);

        expect(service.snapshot.loopMode, entry.value);
      }
    });
  });

  group('queue', () {
    test('setQueue loads the sources and records the length', () async {
      when(
        () => player.setAudioSources(
          any(),
          initialIndex: any(named: 'initialIndex'),
          initialPosition: any(named: 'initialPosition'),
        ),
      ).thenAnswer((_) async => null);

      await service.setQueue(
        ['/music/a.mp3', '/music/b.mp3'],
        initialIndex: 1,
        initialPosition: const Duration(seconds: 5),
      );

      expect(service.snapshot.queueLength, 2);
      verify(
        () => player.setAudioSources(
          any(that: hasLength(2)),
          initialIndex: 1,
          initialPosition: const Duration(seconds: 5),
        ),
      ).called(1);
    });

    test('setQueue passes a null index for an empty queue', () async {
      when(
        () => player.setAudioSources(
          any(),
          initialIndex: any(named: 'initialIndex'),
          initialPosition: any(named: 'initialPosition'),
        ),
      ).thenAnswer((_) async => null);

      await service.setQueue(const []);

      expect(service.snapshot.queueLength, 0);
      verify(
        () => player.setAudioSources(
          any(),
          initialIndex: any(named: 'initialIndex', that: isNull),
          initialPosition: any(named: 'initialPosition', that: isNull),
        ),
      ).called(1);
    });

    test('setQueue reports a load failure as a PlaybackException', () async {
      when(
        () => player.setAudioSources(
          any(),
          initialIndex: any(named: 'initialIndex'),
          initialPosition: any(named: 'initialPosition'),
        ),
      ).thenThrow(Exception('unreadable'));

      await expectLater(
        () => service.setQueue(['/music/a.mp3']),
        throwsA(isA<PlaybackException>()),
      );
    });

    test('addToQueue appends and re-reads the length', () async {
      when(() => player.addAudioSource(any())).thenAnswer((_) async {});
      when(() => player.audioSources).thenReturn([_FakeAudioSource()]);

      await service.addToQueue('/music/a.mp3');

      expect(service.snapshot.queueLength, 1);
    });

    test('insertNext inserts right after the current item', () async {
      when(() => player.currentIndex).thenReturn(2);
      when(() => player.insertAudioSource(any(), any())).thenAnswer(
        (_) async {},
      );
      when(() => player.audioSources).thenReturn([_FakeAudioSource()]);

      await service.insertNext('/music/a.mp3');

      verify(() => player.insertAudioSource(3, any())).called(1);
    });

    test('insertNext inserts at the front when nothing is playing', () async {
      when(() => player.currentIndex).thenReturn(null);
      when(() => player.insertAudioSource(any(), any())).thenAnswer(
        (_) async {},
      );
      when(() => player.audioSources).thenReturn([_FakeAudioSource()]);

      await service.insertNext('/music/a.mp3');

      verify(() => player.insertAudioSource(0, any())).called(1);
    });

    test('removeFromQueue removes and re-reads the length', () async {
      when(() => player.removeAudioSourceAt(any())).thenAnswer((_) async {});
      when(() => player.audioSources).thenReturn([_FakeAudioSource()]);

      await service.removeFromQueue(1);

      verify(() => player.removeAudioSourceAt(1)).called(1);
      expect(service.snapshot.queueLength, 1);
    });

    test('moveInQueue forwards both positions', () async {
      when(() => player.moveAudioSource(any(), any())).thenAnswer((_) async {});
      when(() => player.audioSources).thenReturn([_FakeAudioSource()]);

      await service.moveInQueue(0, 2);

      verify(() => player.moveAudioSource(0, 2)).called(1);
    });
  });

  group('transport', () {
    test('forwards the simple commands to the player', () async {
      when(() => player.play()).thenAnswer((_) async {});
      when(() => player.pause()).thenAnswer((_) async {});
      when(() => player.stop()).thenAnswer((_) async {});
      when(() => player.seekToNext()).thenAnswer((_) async {});
      when(() => player.seekToPrevious()).thenAnswer((_) async {});
      when(() => player.setSpeed(any())).thenAnswer((_) async {});
      when(() => player.setVolume(any())).thenAnswer((_) async {});
      when(() => player.setShuffleModeEnabled(any())).thenAnswer((_) async {});

      await service.play();
      await service.pause();
      await service.stop();
      await service.seekToNext();
      await service.seekToPrevious();
      await service.setSpeed(1.25);
      await service.setVolume(0.5);
      await service.setShuffleModeEnabled(enabled: true);

      verify(() => player.play()).called(1);
      verify(() => player.pause()).called(1);
      verify(() => player.stop()).called(1);
      verify(() => player.seekToNext()).called(1);
      verify(() => player.seekToPrevious()).called(1);
      verify(() => player.setSpeed(1.25)).called(1);
      verify(() => player.setVolume(0.5)).called(1);
      verify(() => player.setShuffleModeEnabled(true)).called(1);
    });

    test('seek forwards the position and the target index', () async {
      when(() => player.seek(any(), index: any(named: 'index'))).thenAnswer(
        (_) async {},
      );

      await service.seek(const Duration(seconds: 30), index: 4);

      verify(
        () => player.seek(const Duration(seconds: 30), index: 4),
      ).called(1);
    });
  });

  group('dispose', () {
    test('closes the streams and the player', () async {
      when(() => player.dispose()).thenAnswer((_) async {});

      await service.dispose();

      verify(() => player.dispose()).called(1);
      await expectLater(service.snapshotStream, emitsDone);
      await expectLater(service.errorStream, emitsDone);
    });

    test('stops following the player after disposal', () async {
      when(() => player.dispose()).thenAnswer((_) async {});

      await service.dispose();
      await emit(streams.playing, true);

      expect(service.snapshot.playing, isFalse);
    });
  });
}
