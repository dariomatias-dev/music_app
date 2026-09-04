import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:music_app/src/core/services/app_lifecycle/app_lifecycle_service.dart';

/// [AppLifecycleService] for tests, driven by [emit] instead of by the
/// platform.
class FakeAppLifecycleService implements AppLifecycleService {
  final _controller = StreamController<AppLifecycleState>.broadcast();

  @override
  Stream<AppLifecycleState> get states => _controller.stream;

  /// Emits [state] to every listener.
  void emit(AppLifecycleState state) => _controller.add(state);

  /// Closes [states].
  ///
  /// Not awaited: Riverpod pauses the subscription behind a provider that
  /// nothing is listening to, and a paused subscription never lets the
  /// controller's close complete.
  void dispose() => unawaited(_controller.close());
}
