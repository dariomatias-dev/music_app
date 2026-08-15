import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/settings/presentation/view_models/user_profile_view_model.dart';

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
    final value = await container.read(userProfileViewModelProvider.future);
    expect(value, isNull);
  });

  test('reads a previously stored name', () async {
    await storage.setString('userDisplayName', 'Dário');

    final value = await container.read(userProfileViewModelProvider.future);
    expect(value, 'Dário');
  });

  test('setDisplayName trims and persists the name', () async {
    await container.read(userProfileViewModelProvider.future);

    await container
        .read(userProfileViewModelProvider.notifier)
        .setDisplayName('  Dário  ');

    expect(container.read(userProfileViewModelProvider).value, 'Dário');
    expect(await storage.getString('userDisplayName'), 'Dário');
  });

  test('setDisplayName with an empty name clears it', () async {
    await storage.setString('userDisplayName', 'Dário');
    await container.read(userProfileViewModelProvider.future);

    await container
        .read(userProfileViewModelProvider.notifier)
        .setDisplayName('   ');

    expect(container.read(userProfileViewModelProvider).value, isNull);
    expect(await storage.getString('userDisplayName'), isNull);
  });
}
