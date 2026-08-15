import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/settings/presentation/view_models/theme_mode_view_model.dart';

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

  tearDown(() => container.dispose());

  test('defaults to system when nothing is stored', () async {
    final value = await container.read(themeModeViewModelProvider.future);
    expect(value, ThemeMode.system);
  });

  test('reads a previously stored theme mode', () async {
    await storage.setString('themeMode', 'dark');

    final value = await container.read(themeModeViewModelProvider.future);
    expect(value, ThemeMode.dark);
  });

  test('setThemeMode persists the choice', () async {
    await container.read(themeModeViewModelProvider.future);

    await container
        .read(themeModeViewModelProvider.notifier)
        .setThemeMode(ThemeMode.light);

    expect(container.read(themeModeViewModelProvider).value, ThemeMode.light);
    expect(await storage.getString('themeMode'), 'light');
  });
}
