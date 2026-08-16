import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_transition_effects.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/settings/presentation/view_models/playback_preferences_view_model.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fake_key_value_storage.dart';

void main() {
  late FakeAudioPlayerService playerService;
  late FakeKeyValueStorage storage;
  late ProviderContainer container;

  // Flushes pending microtasks so the effects coordinator's fire-and-forget
  // async work (`unawaited(...)`) finishes before assertions run.
  Future<void> flush() => Future<void>.delayed(Duration.zero);

  Future<ProviderContainer> buildContainer() async {
    final providerContainer = ProviderContainer(
      overrides: [
        audioPlayerServiceProvider.overrideWithValue(playerService),
        keyValueStorageProvider.overrideWithValue(storage),
      ],
    );
    // Keeps the provider chain (effects -> playback state) flowing between
    // updates; see the identical note in playback_history_recorder_test.dart.
    addTearDown(
      providerContainer.listen(playbackViewModelProvider, (_, _) {}).close,
    );
    await providerContainer.read(playbackPreferencesViewModelProvider.future);
    providerContainer.read(playbackTransitionEffectsProvider.notifier).delay =
        (_) async {};
    return providerContainer;
  }

  setUp(() {
    playerService = FakeAudioPlayerService();
    storage = FakeKeyValueStorage();
  });

  tearDown(() {
    container.dispose();
    return playerService.dispose();
  });

  test(
    'does nothing on track change when gapless is on and crossfade is off',
    () async {
      container = await buildContainer();
      await playerService.setQueue(['a.mp3', 'b.mp3']);
      await playerService.play();
      await flush();

      await playerService.seekToNext();
      await flush();

      expect(playerService.volumeHistory, isEmpty);
      expect(playerService.snapshot.playing, isTrue);
    },
  );

  test('does nothing when the track change happens while paused', () async {
    await storage.setBool('gaplessEnabled', value: false);
    container = await buildContainer();
    await playerService.setQueue(['a.mp3', 'b.mp3']);
    await flush();

    await playerService.seekToNext();
    await flush();

    expect(playerService.snapshot.playing, isFalse);
  });

  test('pauses and resumes after a gap when gapless is disabled', () async {
    await storage.setBool('gaplessEnabled', value: false);
    container = await buildContainer();
    await playerService.setQueue(['a.mp3', 'b.mp3']);
    await playerService.play();
    await flush();

    await playerService.seekToNext();
    await flush();

    expect(playerService.snapshot.playing, isTrue);
  });

  test('fades volume in from silence when crossfade is enabled', () async {
    await storage.setInt('crossfadeDurationSeconds', 2);
    container = await buildContainer();
    await playerService.setQueue(['a.mp3', 'b.mp3']);
    await playerService.play();
    await flush();

    await playerService.seekToNext();
    await flush();

    expect(playerService.volumeHistory.first, 0);
    expect(playerService.volumeHistory.last, 1.0);
    expect(playerService.volumeHistory, hasLength(21));
  });

  test('a later track change supersedes an in-flight fade', () async {
    await storage.setInt('crossfadeDurationSeconds', 2);
    container = await buildContainer();
    await playerService.setQueue([
      'a.mp3',
      'b.mp3',
      'c.mp3',
    ]);
    await playerService.play();
    await flush();

    await playerService.seekToNext();
    await playerService.seekToNext();
    await flush();

    // Only the second fade should have run to completion; the first was
    // superseded after emitting its initial silence.
    expect(playerService.volumeHistory.first, 0);
    expect(playerService.volumeHistory.last, 1.0);
    expect(playerService.volumeHistory.where((v) => v == 0), hasLength(2));
  });
}
