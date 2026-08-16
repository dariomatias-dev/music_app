import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/features/player/presentation/view_models/sleep_timer_view_model.dart';

import '../../../../helpers/fake_audio_player_service.dart';

void main() {
  late FakeAudioPlayerService service;
  late ProviderContainer container;

  setUp(() async {
    service = FakeAudioPlayerService();
    await service.setQueue(['a.mp3']);
    await service.play();
    container = ProviderContainer(
      overrides: [audioPlayerServiceProvider.overrideWithValue(service)],
    );
    addTearDown(
      container.listen(sleepTimerViewModelProvider, (_, _) {}).close,
    );
  });

  tearDown(() => container.dispose());

  test('starts inactive', () {
    expect(container.read(sleepTimerViewModelProvider), isFalse);
  });

  test('start marks the timer active until it fires', () async {
    container
        .read(sleepTimerViewModelProvider.notifier)
        .start(const Duration(milliseconds: 10));

    expect(container.read(sleepTimerViewModelProvider), isTrue);

    await Future<void>.delayed(const Duration(milliseconds: 30));

    expect(container.read(sleepTimerViewModelProvider), isFalse);
    expect(service.snapshot.playing, isFalse);
  });

  test('cancel stops the timer without pausing playback', () async {
    container
        .read(sleepTimerViewModelProvider.notifier)
        .start(const Duration(milliseconds: 10));

    container.read(sleepTimerViewModelProvider.notifier).cancel();

    expect(container.read(sleepTimerViewModelProvider), isFalse);

    await Future<void>.delayed(const Duration(milliseconds: 30));

    expect(service.snapshot.playing, isTrue);
  });

  test('starting again replaces a pending timer', () async {
    container.read(sleepTimerViewModelProvider.notifier)
      ..start(const Duration(milliseconds: 10))
      ..start(const Duration(milliseconds: 200));
    await Future<void>.delayed(const Duration(milliseconds: 30));

    // The first, shorter timer must not have fired.
    expect(service.snapshot.playing, isTrue);
    expect(container.read(sleepTimerViewModelProvider), isTrue);
  });
}
