import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/storage/shared_preferences_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferencesStorage storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = SharedPreferencesStorage(await SharedPreferences.getInstance());
  });

  group('strings', () {
    test('reads back what was written', () async {
      await storage.setString('name', 'Dario');

      expect(await storage.getString('name'), 'Dario');
    });

    test('returns null for a key that was never written', () async {
      expect(await storage.getString('missing'), isNull);
    });

    test('overwrites a previous value', () async {
      await storage.setString('name', 'Dario');
      await storage.setString('name', 'Ana');

      expect(await storage.getString('name'), 'Ana');
    });
  });

  group('bools', () {
    test('reads back what was written', () async {
      await storage.setBool('onboarded', value: true);

      expect(await storage.getBool('onboarded'), isTrue);
    });

    test('keeps false apart from absent', () async {
      await storage.setBool('onboarded', value: false);

      expect(await storage.getBool('onboarded'), isFalse);
      expect(await storage.getBool('other'), isNull);
    });
  });

  group('ints', () {
    test('reads back what was written', () async {
      await storage.setInt('count', 7);

      expect(await storage.getInt('count'), 7);
    });

    test('returns null for a key that was never written', () async {
      expect(await storage.getInt('missing'), isNull);
    });
  });

  group('doubles', () {
    test('reads back what was written', () async {
      await storage.setDouble('speed', 1.25);

      expect(await storage.getDouble('speed'), 1.25);
    });

    test('returns null for a key that was never written', () async {
      expect(await storage.getDouble('missing'), isNull);
    });
  });

  group('remove', () {
    test('drops a stored value', () async {
      await storage.setString('name', 'Dario');
      await storage.remove('name');

      expect(await storage.getString('name'), isNull);
    });

    test('is a no-op for a key that was never written', () async {
      await expectLater(storage.remove('missing'), completes);
    });
  });

  test('keys of different types do not collide', () async {
    await storage.setString('a', 'text');
    await storage.setInt('b', 1);
    await storage.setBool('c', value: true);
    await storage.setDouble('d', 0.5);

    expect(await storage.getString('a'), 'text');
    expect(await storage.getInt('b'), 1);
    expect(await storage.getBool('c'), isTrue);
    expect(await storage.getDouble('d'), 0.5);
  });

  test('starts empty when the platform has nothing stored', () async {
    expect(await storage.getString('anything'), isNull);
    expect(await storage.getBool('anything'), isNull);
    expect(await storage.getInt('anything'), isNull);
    expect(await storage.getDouble('anything'), isNull);
  });
}
