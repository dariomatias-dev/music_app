import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/utils/file_size_formatter.dart';

void main() {
  test('formats bytes with no decimal place', () {
    expect(formatFileSize(0), '0 B');
    expect(formatFileSize(512), '512 B');
    expect(formatFileSize(1023), '1023 B');
  });

  test('switches to KB at exactly 1024 bytes', () {
    expect(formatFileSize(1024), '1.0 KB');
  });

  test('formats larger units with one decimal place', () {
    expect(formatFileSize(1536), '1.5 KB');
    expect(formatFileSize(5 * 1024 * 1024), '5.0 MB');
  });

  test('stops scaling at GB, the largest supported unit', () {
    const threeGib = 3 * 1024 * 1024 * 1024;
    const overflowing = 2048 * 1024 * 1024 * 1024;
    expect(formatFileSize(threeGib), '3.0 GB');
    expect(formatFileSize(overflowing), '2048.0 GB');
  });
}
