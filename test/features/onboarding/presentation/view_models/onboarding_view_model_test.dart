import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/storage/key_value_storage.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/onboarding/presentation/view_models/onboarding_view_model.dart';

import '../../../../helpers/fake_key_value_storage.dart';

/// Delays every write, so a caller can dispose the provider while one is
/// still in flight.
class _SlowKeyValueStorage implements KeyValueStorage {
  _SlowKeyValueStorage(this._delegate);

  final KeyValueStorage _delegate;

  @override
  Future<void> setBool(String key, {required bool value}) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await _delegate.setBool(key, value: value);
  }

  @override
  Future<bool?> getBool(String key) => _delegate.getBool(key);

  @override
  Future<String?> getString(String key) => _delegate.getString(key);

  @override
  Future<void> setString(String key, String value) =>
      _delegate.setString(key, value);

  @override
  Future<int?> getInt(String key) => _delegate.getInt(key);

  @override
  Future<void> setInt(String key, int value) => _delegate.setInt(key, value);

  @override
  Future<double?> getDouble(String key) => _delegate.getDouble(key);

  @override
  Future<void> setDouble(String key, double value) =>
      _delegate.setDouble(key, value);

  @override
  Future<void> remove(String key) => _delegate.remove(key);
}

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

  test(
    'complete does not throw if disposed while its write is pending',
    () async {
      final slowContainer = ProviderContainer(
        overrides: [
          keyValueStorageProvider.overrideWithValue(
            _SlowKeyValueStorage(storage),
          ),
        ],
      );
      await slowContainer.read(onboardingViewModelProvider.future);

      final complete = slowContainer
          .read(onboardingViewModelProvider.notifier)
          .complete();
      // Nothing is watching the provider (no container.listen was set up),
      // so disposing the container mid-write reproduces a real navigation
      // away from the only screen that reads it.
      slowContainer.dispose();

      await expectLater(complete, completes);
    },
  );
}
