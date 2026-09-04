import 'package:flutter/widgets.dart';

/// Abstraction over the app's lifecycle transitions.
///
/// Exists so the work that has to happen before the process can be killed
/// (persisting the playback session, flushing the play being recorded) can
/// be driven from a plain provider and substituted in tests, instead of
/// each caller wiring its own [WidgetsBindingObserver].
abstract interface class AppLifecycleService {
  /// Emits every lifecycle state the app moves through.
  Stream<AppLifecycleState> get states;
}
