// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the user has completed the onboarding flow, persisting the
/// choice so it survives app restarts.

@ProviderFor(OnboardingViewModel)
const onboardingViewModelProvider = OnboardingViewModelProvider._();

/// Whether the user has completed the onboarding flow, persisting the
/// choice so it survives app restarts.
final class OnboardingViewModelProvider
    extends $AsyncNotifierProvider<OnboardingViewModel, bool> {
  /// Whether the user has completed the onboarding flow, persisting the
  /// choice so it survives app restarts.
  const OnboardingViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingViewModelHash();

  @$internal
  @override
  OnboardingViewModel create() => OnboardingViewModel();
}

String _$onboardingViewModelHash() =>
    r'f7317eafa7d5361cbffec68dc81b3a950611be06';

/// Whether the user has completed the onboarding flow, persisting the
/// choice so it survives app restarts.

abstract class _$OnboardingViewModel extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
