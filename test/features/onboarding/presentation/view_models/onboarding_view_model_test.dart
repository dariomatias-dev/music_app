import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/storage/key_value_storage.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/onboarding/presentation/view_models/onboarding_view_model.dart';

class _FakeKeyValueStorage implements KeyValueStorage {
  final Map<String, Object> _values = {};

  @override
  Future<String?> getString(String key) async => _values[key] as String?;

  @override
  Future<void> setString(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<bool?> getBool(String key) async => _values[key] as bool?;

  @override
  Future<void> setBool(String key, {required bool value}) async {
    _values[key] = value;
  }

  @override
  Future<int?> getInt(String key) async => _values[key] as int?;

  @override
  Future<void> setInt(String key, int value) async {
    _values[key] = value;
  }

  @override
  Future<double?> getDouble(String key) async => _values[key] as double?;

  @override
  Future<void> setDouble(String key, double value) async {
    _values[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }
}

void main() {
  late _FakeKeyValueStorage storage;
  late ProviderContainer container;

  setUp(() {
    storage = _FakeKeyValueStorage();
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
