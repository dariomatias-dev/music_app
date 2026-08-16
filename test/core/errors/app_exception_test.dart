import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/errors/app_exception.dart';

void main() {
  group('AppException.toString', () {
    test('shows only the message when there is no cause', () {
      const exception = FileException('could not read file');

      expect(exception.toString(), 'could not read file');
    });

    test('appends the cause when one is present', () {
      const exception = PlaybackException('playback failed', cause: 'oops');

      expect(exception.toString(), 'playback failed (cause: oops)');
    });
  });

  test('PermissionException carries its message and cause', () {
    const exception = PermissionException('denied', cause: 'oops');

    expect(exception.message, 'denied');
    expect(exception.cause, 'oops');
  });
}
