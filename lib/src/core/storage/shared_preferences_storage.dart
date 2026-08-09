import 'package:music_app/src/core/storage/key_value_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [KeyValueStorage] implementation backed by [SharedPreferences].
class SharedPreferencesStorage implements KeyValueStorage {
  /// Creates a [SharedPreferencesStorage] wrapping [preferences].
  const SharedPreferencesStorage(this.preferences);

  /// The underlying [SharedPreferences] instance.
  final SharedPreferences preferences;

  @override
  Future<String?> getString(String key) async => preferences.getString(key);

  @override
  Future<void> setString(String key, String value) =>
      preferences.setString(key, value);

  @override
  Future<bool?> getBool(String key) async => preferences.getBool(key);

  @override
  Future<void> setBool(String key, {required bool value}) =>
      preferences.setBool(key, value);

  @override
  Future<int?> getInt(String key) async => preferences.getInt(key);

  @override
  Future<void> setInt(String key, int value) => preferences.setInt(key, value);

  @override
  Future<double?> getDouble(String key) async => preferences.getDouble(key);

  @override
  Future<void> setDouble(String key, double value) =>
      preferences.setDouble(key, value);

  @override
  Future<void> remove(String key) => preferences.remove(key);
}
