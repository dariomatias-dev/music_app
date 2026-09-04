import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:music_app/src/core/permissions/notification_permission_service.dart';
import 'package:music_app/src/core/permissions/permission_providers.dart';
import 'package:music_app/src/core/services/app_lifecycle/app_lifecycle_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_permission_view_model.g.dart';

/// Current status of the notification permission, for the settings row
/// that reports it.
///
/// Re-read whenever the app comes back to the foreground: the permission
/// is the system settings' to change, so the answer this holds can go
/// stale while the user is outside the app.
@riverpod
class NotificationPermissionViewModel
    extends _$NotificationPermissionViewModel {
  @override
  Future<NotificationPermissionStatus> build() {
    ref.listen(appLifecycleStateProvider, (previous, current) {
      if (current.value == AppLifecycleState.resumed) unawaited(refresh());
    });
    return ref.read(notificationPermissionServiceProvider).check();
  }

  /// Prompts for the permission, or opens the system settings when the
  /// answer is no longer the app's to ask for.
  ///
  /// One action for every state, so the row does not ask the user to know
  /// which of them they are in.
  Future<void> requestOrOpenSettings() async {
    final service = ref.read(notificationPermissionServiceProvider);
    if (state.value == NotificationPermissionStatus.permanentlyDenied) {
      await service.openSystemSettings();
      return;
    }
    final status = await service.request();
    if (!ref.mounted) return;
    state = AsyncData(status);
  }

  /// Re-reads the status from the platform.
  Future<void> refresh() async {
    final status = await ref
        .read(notificationPermissionServiceProvider)
        .check();
    if (!ref.mounted) return;
    state = AsyncData(status);
  }
}
