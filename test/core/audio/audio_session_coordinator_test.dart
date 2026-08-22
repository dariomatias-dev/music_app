import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_app/src/core/audio/audio_session_coordinator.dart';

import '../../helpers/fake_audio_player_service.dart';

class _MockAudioSession extends Mock implements AudioSession {}

class _FakeAudioSessionConfiguration extends Fake
    implements AudioSessionConfiguration {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeAudioSessionConfiguration());
  });

  late _MockAudioSession session;
  late StreamController<AudioInterruptionEvent> interruptions;
  late StreamController<void> becomingNoisy;
  late FakeAudioPlayerService player;
  late AudioSessionCoordinator coordinator;

  setUp(() {
    session = _MockAudioSession();
    interruptions = StreamController<AudioInterruptionEvent>.broadcast();
    becomingNoisy = StreamController<void>.broadcast();
    player = FakeAudioPlayerService();

    when(() => session.configure(any())).thenAnswer((_) async => true);
    when(() => session.interruptionEventStream).thenAnswer(
      (_) => interruptions.stream,
    );
    when(() => session.becomingNoisyEventStream).thenAnswer(
      (_) => becomingNoisy.stream,
    );

    coordinator = AudioSessionCoordinator(
      player,
      session: Future.value(session),
    );
  });

  tearDown(() async {
    await coordinator.dispose();
    await interruptions.close();
    await becomingNoisy.close();
  });

  /// Emits [event] and lets the coordinator's listener run.
  Future<void> emitInterruption({required bool begin}) async {
    interruptions.add(
      AudioInterruptionEvent(begin, AudioInterruptionType.pause),
    );
    await Future<void>.delayed(Duration.zero);
  }

  /// Puts the player in a playing state, so a pause is observable.
  Future<void> startPlaying() async {
    await player.setQueue(['/music/a.mp3']);
    await player.play();
    expect(player.snapshot.playing, isTrue);
  }

  group('initialize', () {
    test('configures the session for music playback', () async {
      await coordinator.initialize();

      final configuration =
          verify(() => session.configure(captureAny())).captured.single
              as AudioSessionConfiguration;

      expect(
        configuration.avAudioSessionCategory,
        AVAudioSessionCategory.playback,
      );
      expect(
        configuration.androidAudioAttributes?.contentType,
        AndroidAudioContentType.music,
      );
      expect(configuration.androidWillPauseWhenDucked, isTrue);
    });

    test('subscribes to both platform event streams', () async {
      await coordinator.initialize();

      expect(interruptions.hasListener, isTrue);
      expect(becomingNoisy.hasListener, isTrue);
    });
  });

  group('interruptions', () {
    test('pause playback when one begins', () async {
      await coordinator.initialize();
      await startPlaying();

      await emitInterruption(begin: true);

      expect(player.snapshot.playing, isFalse);
    });

    test('do not resume playback when one ends', () async {
      await coordinator.initialize();
      await coordinator.dispose();
      await startPlaying();
      await coordinator.initialize();

      await emitInterruption(begin: false);

      expect(player.snapshot.playing, isTrue);
    });
  });

  test('an audio output disconnect pauses playback', () async {
    await coordinator.initialize();
    await startPlaying();

    becomingNoisy.add(null);
    await Future<void>.delayed(Duration.zero);

    expect(player.snapshot.playing, isFalse);
  });

  group('dispose', () {
    test('stops listening to both streams', () async {
      await coordinator.initialize();

      await coordinator.dispose();

      expect(interruptions.hasListener, isFalse);
      expect(becomingNoisy.hasListener, isFalse);
    });

    test('leaves playback alone after an interruption arrives', () async {
      await coordinator.initialize();
      await startPlaying();
      await coordinator.dispose();

      await emitInterruption(begin: true);

      expect(player.snapshot.playing, isTrue);
    });

    test('is safe before initialize was ever called', () async {
      await expectLater(coordinator.dispose(), completes);
    });
  });
}
