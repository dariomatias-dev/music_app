import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/audio/audio_player_service.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_state.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';

import '../../../../helpers/fake_audio_player_service.dart';

void main() {
  late FakeAudioPlayerService service;
  late ProviderContainer container;

  setUp(() {
    service = FakeAudioPlayerService();
    container = ProviderContainer(
      overrides: [audioPlayerServiceProvider.overrideWithValue(service)],
    );
    // Keep the provider alive for the duration of the test; otherwise it
    // disposes itself as soon as nothing is watching it.
    addTearDown(
      container.listen(playbackViewModelProvider, (_, _) {}).close,
    );
  });

  tearDown(() => container.dispose());

  test('starts with the service current snapshot', () async {
    final state = await container.read(playbackViewModelProvider.future);

    expect(state, PlaybackState.initial());
  });

  test('reflects the latest snapshot after service changes', () async {
    await container.read(playbackViewModelProvider.future);

    await service.setQueue(['a.mp3', 'b.mp3']);
    await service.play();
    // Let the provider's internal stream subscription process the new
    // snapshots before reading the state again.
    await Future<void>.delayed(Duration.zero);

    final state = await container.read(playbackViewModelProvider.future);

    expect(state.queueLength, 2);
    expect(state.processingState, AudioProcessingState.ready);
    expect(state.playing, isTrue);
  });

  test('equal states compare equal, enabling select', () async {
    final a = PlaybackState.fromSnapshot(service.snapshot);
    final b = PlaybackState.fromSnapshot(service.snapshot);

    expect(a, b);
  });
}
