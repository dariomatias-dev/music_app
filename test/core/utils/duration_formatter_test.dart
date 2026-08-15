import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';

void main() {
  test('formats minutes and zero-padded seconds', () {
    expect(formatDuration(const Duration(minutes: 3, seconds: 5)), '3:05');
    expect(formatDuration(const Duration(minutes: 12, seconds: 30)), '12:30');
    expect(formatDuration(Duration.zero), '0:00');
  });

  test('formatLongDuration omits hours under an hour', () {
    expect(formatLongDuration(const Duration(minutes: 45)), '45m');
    expect(formatLongDuration(Duration.zero), '0m');
  });

  test('formatLongDuration includes hours and minutes above an hour', () {
    expect(
      formatLongDuration(const Duration(hours: 4, minutes: 12)),
      '4h 12m',
    );
    expect(formatLongDuration(const Duration(hours: 2)), '2h 0m');
  });
}
