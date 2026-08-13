import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/onboarding/presentation/view_models/onboarding_view_model.dart';

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

  test('defaults to not completed when nothing is stored', () async {
    final value = await container.read(onboardingViewModelProvider.future);
    expect(value, isFalse);
  });

  test('complete persists true and updates the state', () async {
    await container.read(onboardingViewModelProvider.future);

    await container.read(onboardingViewModelProvider.notifier).complete();

    expect(container.read(onboardingViewModelProvider).value, isTrue);
    expect(await storage.getBool('onboardingCompleted'), isTrue);
  });

  test('reset persists false and updates the state', () async {
    await storage.setBool('onboardingCompleted', value: true);
    await container.read(onboardingViewModelProvider.future);

    await container.read(onboardingViewModelProvider.notifier).reset();

    expect(container.read(onboardingViewModelProvider).value, isFalse);
    expect(await storage.getBool('onboardingCompleted'), isFalse);
  });
}
