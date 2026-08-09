/// Abstraction over simple key-value persistence.
abstract interface class KeyValueStorage {
  /// Reads a [String] stored under [key].
  Future<String?> getString(String key);

  /// Stores a [String] under [key].
  Future<void> setString(String key, String value);

  /// Reads a [bool] stored under [key].
  Future<bool?> getBool(String key);

  /// Stores a [bool] under [key].
  Future<void> setBool(String key, {required bool value});

  /// Reads an [int] stored under [key].
  Future<int?> getInt(String key);

  /// Stores an [int] under [key].
  Future<void> setInt(String key, int value);

  /// Reads a [double] stored under [key].
  Future<double?> getDouble(String key);

  /// Stores a [double] under [key].
  Future<void> setDouble(String key, double value);

  /// Removes the value stored under [key].
  Future<void> remove(String key);
}
