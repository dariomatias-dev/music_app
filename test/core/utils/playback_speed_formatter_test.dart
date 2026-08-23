import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/utils/playback_speed_formatter.dart';

void main() {
  test('drops the decimal point for whole numbers', () {
    expect(formatPlaybackSpeed(1), '1x');
    expect(formatPlaybackSpeed(2), '2x');
    expect(formatPlaybackSpeed(0.5 * 2), '1x');
  });

  test('keeps the decimal point for fractional speeds', () {
    expect(formatPlaybackSpeed(1.5), '1.5x');
    expect(formatPlaybackSpeed(0.75), '0.75x');
  });
}
