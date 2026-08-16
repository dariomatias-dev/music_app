import 'package:app_ui/app_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/settings/presentation/view_models/playback_preferences_view_model.dart';

import '../../../../helpers/fake_key_value_storage.dart';

void main() {
  late FakeKeyValueStorage storage;
  late ProviderContainer container;

  setUp(() {
    storage = FakeKeyValueStorage();
    container = ProviderContainer(
      overrides: [keyValueStorageProvider.overrideWithValue(storage)],
    );
  });

  tearDown(() {
    container.dispose();
    Pressable.hapticsEnabled = true;
  });

  test('defaults to gapless on, no crossfade, 1.0x, haptics on', () async {
    final value = await container.read(
      playbackPreferencesViewModelProvider.future,
    );

    expect(value.gaplessEnabled, isTrue);
    expect(value.crossfadeDuration, Duration.zero);
    expect(value.defaultSpeed, 1.0);
    expect(value.hapticsEnabled, isTrue);
  });

  test('reads previously stored preferences', () async {
    await storage.setBool('gaplessEnabled', value: false);
    await storage.setInt('crossfadeDurationSeconds', 6);
    await storage.setDouble('defaultPlaybackSpeed', 1.5);
    await storage.setBool('hapticsEnabled', value: false);

    final value = await container.read(
      playbackPreferencesViewModelProvider.future,
    );

    expect(value.gaplessEnabled, isFalse);
    expect(value.crossfadeDuration, const Duration(seconds: 6));
    expect(value.defaultSpeed, 1.5);
    expect(value.hapticsEnabled, isFalse);
  });

  test('build mirrors hapticsEnabled onto Pressable.hapticsEnabled', () async {
    await storage.setBool('hapticsEnabled', value: false);

    await container.read(playbackPreferencesViewModelProvider.future);

    expect(Pressable.hapticsEnabled, isFalse);
  });

  test('setGaplessEnabled persists and updates state', () async {
    await container.read(playbackPreferencesViewModelProvider.future);

    await container
        .read(playbackPreferencesViewModelProvider.notifier)
        .setGaplessEnabled(enabled: false);

    expect(
      container
          .read(playbackPreferencesViewModelProvider)
          .value
          ?.gaplessEnabled,
      isFalse,
    );
    expect(await storage.getBool('gaplessEnabled'), isFalse);
  });

  test('setCrossfadeDuration persists and updates state', () async {
    await container.read(playbackPreferencesViewModelProvider.future);

    await container
        .read(playbackPreferencesViewModelProvider.notifier)
        .setCrossfadeDuration(const Duration(seconds: 8));

    expect(
      container
          .read(playbackPreferencesViewModelProvider)
          .value
          ?.crossfadeDuration,
      const Duration(seconds: 8),
    );
    expect(await storage.getInt('crossfadeDurationSeconds'), 8);
  });

  test('setDefaultSpeed persists and updates state', () async {
    await container.read(playbackPreferencesViewModelProvider.future);

    await container
        .read(playbackPreferencesViewModelProvider.notifier)
        .setDefaultSpeed(1.25);

    expect(
      container.read(playbackPreferencesViewModelProvider).value?.defaultSpeed,
      1.25,
    );
    expect(await storage.getDouble('defaultPlaybackSpeed'), 1.25);
  });

  test('setHapticsEnabled persists, updates state and Pressable', () async {
    await container.read(playbackPreferencesViewModelProvider.future);

    await container
        .read(playbackPreferencesViewModelProvider.notifier)
        .setHapticsEnabled(enabled: false);

    expect(
      container
          .read(playbackPreferencesViewModelProvider)
          .value
          ?.hapticsEnabled,
      isFalse,
    );
    expect(await storage.getBool('hapticsEnabled'), isFalse);
    expect(Pressable.hapticsEnabled, isFalse);
  });
}
