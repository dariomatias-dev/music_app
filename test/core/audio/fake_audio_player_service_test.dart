import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/audio/audio_player_service.dart';
import 'package:music_app/src/core/errors/app_exception.dart';

import '../../helpers/fake_audio_player_service.dart';

void main() {
  late FakeAudioPlayerService service;

  setUp(() => service = FakeAudioPlayerService());
  tearDown(() => service.dispose());

  test('starts idle with an empty queue', () {
    expect(service.snapshot.processingState, AudioProcessingState.idle);
    expect(service.snapshot.currentIndex, isNull);
    expect(service.snapshot.queueLength, 0);
  });

  test('setQueue loads the queue and becomes ready', () async {
    await service.setQueue(['a.mp3', 'b.mp3'], initialIndex: 1);

    expect(service.snapshot.processingState, AudioProcessingState.ready);
    expect(service.snapshot.currentIndex, 1);
    expect(service.snapshot.queueLength, 2);
  });

  test('play and pause toggle playing', () async {
    await service.setQueue(['a.mp3']);

    await service.play();
    expect(service.snapshot.playing, isTrue);

    await service.pause();
    expect(service.snapshot.playing, isFalse);
  });

  test('seekToNext advances the index and resets position', () async {
    await service.setQueue(['a.mp3', 'b.mp3']);
    await service.seek(const Duration(seconds: 30));

    await service.seekToNext();

    expect(service.snapshot.currentIndex, 1);
    expect(service.snapshot.position, Duration.zero);
  });

  test('seekToNext does nothing past the end of the queue', () async {
    await service.setQueue(['a.mp3']);

    await service.seekToNext();

    expect(service.snapshot.currentIndex, 0);
  });

  test('seekToPrevious does nothing before the start of the queue', () async {
    await service.setQueue(['a.mp3', 'b.mp3']);

    await service.seekToPrevious();

    expect(service.snapshot.currentIndex, 0);
  });

  test('insertNext places the item right after the current one', () async {
    await service.setQueue(['a.mp3', 'b.mp3']);

    await service.insertNext('c.mp3');

    expect(service.snapshot.queueLength, 3);
  });

  test('snapshotStream emits every change', () async {
    final emitted = <AudioPlaybackSnapshot>[];
    final subscription = service.snapshotStream.listen(emitted.add);

    await service.setQueue(['a.mp3']);
    await service.play();
    await service.pause();

    expect(emitted, hasLength(3));
    expect(emitted, service.snapshotHistory);

    await subscription.cancel();
  });

  test('setSpeed and setLoopMode update the snapshot', () async {
    await service.setSpeed(1.5);
    await service.setLoopMode(AudioLoopMode.queue);
    await service.setShuffleModeEnabled(enabled: true);

    expect(service.snapshot.speed, 1.5);
    expect(service.snapshot.loopMode, AudioLoopMode.queue);
    expect(service.snapshot.shuffleModeEnabled, isTrue);
  });

  test('emitError surfaces on errorStream', () async {
    final errors = <PlaybackException>[];
    final subscription = service.errorStream.listen(errors.add);

    service.emitError(const PlaybackException('Corrupt file.'));
    await Future<void>.delayed(Duration.zero);

    expect(errors, hasLength(1));
    expect(errors.single.message, 'Corrupt file.');

    await subscription.cancel();
  });
}
