// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_permission_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Current status of the notification permission, for the settings row
/// that reports it.
///
/// Re-read whenever the app comes back to the foreground: the permission
/// is the system settings' to change, so the answer this holds can go
/// stale while the user is outside the app.

@ProviderFor(NotificationPermissionViewModel)
const notificationPermissionViewModelProvider =
    NotificationPermissionViewModelProvider._();

/// Current status of the notification permission, for the settings row
/// that reports it.
///
/// Re-read whenever the app comes back to the foreground: the permission
/// is the system settings' to change, so the answer this holds can go
/// stale while the user is outside the app.
final class NotificationPermissionViewModelProvider
    extends
        $AsyncNotifierProvider<
          NotificationPermissionViewModel,
          NotificationPermissionStatus
        > {
  /// Current status of the notification permission, for the settings row
  /// that reports it.
  ///
  /// Re-read whenever the app comes back to the foreground: the permission
  /// is the system settings' to change, so the answer this holds can go
  /// stale while the user is outside the app.
  const NotificationPermissionViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationPermissionViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationPermissionViewModelHash();

  @$internal
  @override
  NotificationPermissionViewModel create() => NotificationPermissionViewModel();
}

String _$notificationPermissionViewModelHash() =>
    r'dd873a11a14c1287d7da1e7c049c3775cf4ad6cd';

/// Current status of the notification permission, for the settings row
/// that reports it.
///
/// Re-read whenever the app comes back to the foreground: the permission
/// is the system settings' to change, so the answer this holds can go
/// stale while the user is outside the app.

abstract class _$NotificationPermissionViewModel
    extends $AsyncNotifier<NotificationPermissionStatus> {
  FutureOr<NotificationPermissionStatus> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<NotificationPermissionStatus>,
              NotificationPermissionStatus
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NotificationPermissionStatus>,
                NotificationPermissionStatus
              >,
              AsyncValue<NotificationPermissionStatus>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
