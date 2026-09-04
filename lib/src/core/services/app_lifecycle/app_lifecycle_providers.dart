import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/services/app_lifecycle/app_lifecycle_service.dart';
import 'package:music_app/src/core/services/app_lifecycle/widgets_binding_app_lifecycle_service.dart';

/// Provides the [AppLifecycleService] used across the app.
final appLifecycleServiceProvider = Provider<AppLifecycleService>((ref) {
  final service = WidgetsBindingAppLifecycleService();
  ref.onDispose(service.dispose);
  return service;
});

/// The app's lifecycle states as they happen.
///
/// A stream rather than a value: the listeners (the playback session, the
/// play being recorded) act on the transition into the background, and a
/// state they read after the fact would already be too late.
final appLifecycleStateProvider = StreamProvider<AppLifecycleState>(
  (ref) => ref.watch(appLifecycleServiceProvider).states,
);
