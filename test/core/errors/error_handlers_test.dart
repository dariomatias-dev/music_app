import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/errors/error_handlers.dart';

import '../../helpers/fake_error_reporter.dart';

/// Silences [FlutterError.presentError] for the rest of the current test.
///
/// The installed handler still calls it, and its default would dump the
/// details to the console and fail the test on the way out; what these
/// tests assert on is the reporting the handler adds around it.
void _silencePresentError() {
  FlutterError.presentError = (_) {};
  addTearDown(
    () => FlutterError.presentError = FlutterError.dumpErrorToConsole,
  );
}

void main() {
  late FakeErrorReporter reporter;
  late FlutterExceptionHandler? previousFlutterHandler;
  late ErrorCallback? previousPlatformHandler;

  setUp(() {
    reporter = FakeErrorReporter();
    previousFlutterHandler = FlutterError.onError;
    previousPlatformHandler = PlatformDispatcher.instance.onError;
    installErrorHandlers(reporter);
  });

  tearDown(() {
    FlutterError.onError = previousFlutterHandler;
    PlatformDispatcher.instance.onError = previousPlatformHandler;
  });

  group('FlutterError.onError', () {
    test('reports the exception, its stack and its context', () {
      _silencePresentError();
      final stackTrace = StackTrace.fromString('#0 somewhere');

      FlutterError.onError!(
        FlutterErrorDetails(
          exception: 'boom',
          stack: stackTrace,
          context: ErrorDescription('while building'),
        ),
      );

      expect(reporter.reports, hasLength(1));
      expect(reporter.reports.single.error, 'boom');
      expect(reporter.reports.single.stackTrace, stackTrace);
      expect(reporter.reports.single.context, contains('while building'));
    });

    test('substitutes a stack trace when the details carry none', () {
      _silencePresentError();

      FlutterError.onError!(const FlutterErrorDetails(exception: 'boom'));

      expect(reporter.reports.single.stackTrace, isNotNull);
      expect(reporter.reports.single.context, isNull);
    });

    test('still presents the error after reporting it', () {
      final presented = <FlutterErrorDetails>[];
      FlutterError.presentError = presented.add;
      addTearDown(
        () => FlutterError.presentError = FlutterError.dumpErrorToConsole,
      );

      FlutterError.onError!(const FlutterErrorDetails(exception: 'boom'));

      expect(presented, hasLength(1));
    });
  });

  group('PlatformDispatcher.onError', () {
    test('reports the error and marks it handled', () {
      final stackTrace = StackTrace.fromString('#0 somewhere');

      final handled = PlatformDispatcher.instance.onError!('boom', stackTrace);

      expect(handled, isTrue);
      expect(reporter.reports.single.error, 'boom');
      expect(reporter.reports.single.stackTrace, stackTrace);
      expect(reporter.reports.single.context, 'Uncaught platform error');
    });
  });
}
