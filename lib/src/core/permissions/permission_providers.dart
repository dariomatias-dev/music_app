import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/permissions/media_permission_service.dart';
import 'package:music_app/src/core/permissions/media_permission_service_impl.dart';
import 'package:music_app/src/core/permissions/notification_permission_service.dart';
import 'package:music_app/src/core/permissions/notification_permission_service_impl.dart';

/// Provides the [MediaPermissionService] used across the app.
final mediaPermissionServiceProvider = Provider<MediaPermissionService>(
  (ref) => const MediaPermissionServiceImpl(),
);

/// Provides the [NotificationPermissionService] used across the app.
final notificationPermissionServiceProvider =
    Provider<NotificationPermissionService>(
      (ref) => const NotificationPermissionServiceImpl(),
    );
