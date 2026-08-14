import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/utils/stable_hash.dart';

void main() {
  test('is deterministic for the same input', () {
    expect(stableHash('track-1'), stableHash('track-1'));
  });

  test('differs for different inputs', () {
    expect(stableHash('track-1'), isNot(stableHash('track-2')));
  });
}
