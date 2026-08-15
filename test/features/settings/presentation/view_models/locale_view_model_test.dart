import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/settings/presentation/view_models/locale_view_model.dart';

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

  test('defaults to null when nothing is stored', () async {
    final value = await container.read(localeViewModelProvider.future);
    expect(value, isNull);
  });

  test('reads a previously stored locale', () async {
    await storage.setString('locale', 'pt_BR');

    final value = await container.read(localeViewModelProvider.future);
    expect(value, const Locale('pt', 'BR'));
  });

  test('reads a previously stored locale without a country code', () async {
    await storage.setString('locale', 'en');

    final value = await container.read(localeViewModelProvider.future);
    expect(value, const Locale('en'));
  });

  test('setLocale persists the choice', () async {
    await container.read(localeViewModelProvider.future);

    await container
        .read(localeViewModelProvider.notifier)
        .setLocale(const Locale('pt', 'BR'));

    expect(
      container.read(localeViewModelProvider).value,
      const Locale('pt', 'BR'),
    );
    expect(await storage.getString('locale'), 'pt_BR');
  });

  test('resetToSystemLocale clears the stored choice', () async {
    await storage.setString('locale', 'es');
    await container.read(localeViewModelProvider.future);

    await container
        .read(localeViewModelProvider.notifier)
        .resetToSystemLocale();

    expect(container.read(localeViewModelProvider).value, isNull);
    expect(await storage.getString('locale'), isNull);
  });
}
