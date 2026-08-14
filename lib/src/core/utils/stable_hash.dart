/// Deterministic 32-bit FNV-1a hash, since [String.hashCode] is not
/// guaranteed to be stable across runs.
int stableHash(String input) {
  var hash = 0x811c9dc5;
  for (final codeUnit in input.codeUnits) {
    hash ^= codeUnit;
    hash = (hash * 0x01000193) & 0xFFFFFFFF;
  }
  return hash;
}
