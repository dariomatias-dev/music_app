/// Generates identifiers for persisted entities.
abstract interface class IdGenerator {
  /// Generates a new identifier.
  String generate();
}
