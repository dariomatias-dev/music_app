import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/errors/error_reporter.dart';

void main() {
  group('LogErrorReporter', () {
    test('reports an error with a context without throwing', () {
      expect(
        () => const LogErrorReporter().report(
          Exception('boom'),
          StackTrace.fromString('#0 somewhere'),
          context: 'while starting',
        ),
        returnsNormally,
      );
    });

    test('reports an error without a context without throwing', () {
      expect(
        () => const LogErrorReporter().report('boom', StackTrace.empty),
        returnsNormally,
      );
    });
  });
}
