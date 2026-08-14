import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';

void main() {
  test('formats minutes and zero-padded seconds', () {
    expect(formatDuration(const Duration(minutes: 3, seconds: 5)), '3:05');
    expect(formatDuration(const Duration(minutes: 12, seconds: 30)), '12:30');
    expect(formatDuration(Duration.zero), '0:00');
  });
}
