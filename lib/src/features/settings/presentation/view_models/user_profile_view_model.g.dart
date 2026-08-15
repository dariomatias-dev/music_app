// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The user's display name, shown in the Home greeting.
///
/// A `null` value means none was ever set (editing it is built in
/// Etapa 91); Home falls back to a name-less greeting.

@ProviderFor(UserProfileViewModel)
const userProfileViewModelProvider = UserProfileViewModelProvider._();

/// The user's display name, shown in the Home greeting.
///
/// A `null` value means none was ever set (editing it is built in
/// Etapa 91); Home falls back to a name-less greeting.
final class UserProfileViewModelProvider
    extends $AsyncNotifierProvider<UserProfileViewModel, String?> {
  /// The user's display name, shown in the Home greeting.
  ///
  /// A `null` value means none was ever set (editing it is built in
  /// Etapa 91); Home falls back to a name-less greeting.
  const UserProfileViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileViewModelHash();

  @$internal
  @override
  UserProfileViewModel create() => UserProfileViewModel();
}

String _$userProfileViewModelHash() =>
    r'92599754b3a8d5eacfa4659a9bbb8f9e705df471';

/// The user's display name, shown in the Home greeting.
///
/// A `null` value means none was ever set (editing it is built in
/// Etapa 91); Home falls back to a name-less greeting.

abstract class _$UserProfileViewModel extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
