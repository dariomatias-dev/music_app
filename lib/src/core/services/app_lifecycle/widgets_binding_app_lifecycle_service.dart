import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:music_app/src/core/services/app_lifecycle/app_lifecycle_service.dart';

/// [AppLifecycleService] implementation backed by [AppLifecycleListener].
class WidgetsBindingAppLifecycleService implements AppLifecycleService {
  /// Creates a [WidgetsBindingAppLifecycleService], listening from now on.
  WidgetsBindingAppLifecycleService() {
    _listener = AppLifecycleListener(onStateChange: _controller.add);
  }

  final _controller = StreamController<AppLifecycleState>.broadcast();
  late final AppLifecycleListener _listener;

  @override
  Stream<AppLifecycleState> get states => _controller.stream;

  /// Stops listening and closes [states].
  void dispose() {
    _listener.dispose();
    unawaited(_controller.close());
  }
}
