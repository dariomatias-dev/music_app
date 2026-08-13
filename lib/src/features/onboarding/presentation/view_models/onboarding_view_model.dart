import 'package:music_app/src/core/constants/preference_keys.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_view_model.g.dart';

/// Whether the user has completed the onboarding flow, persisting the
/// choice so it survives app restarts.
@riverpod
class OnboardingViewModel extends _$OnboardingViewModel {
  @override
  Future<bool> build() async {
    return await ref
            .read(keyValueStorageProvider)
            .getBool(PreferenceKeys.onboardingCompleted) ??
        false;
  }

  /// Marks onboarding as completed.
  Future<void> complete() async {
    await ref
        .read(keyValueStorageProvider)
        .setBool(PreferenceKeys.onboardingCompleted, value: true);
    state = const AsyncData(true);
  }

  /// Marks onboarding as not completed, so it is shown again.
  ///
  /// Meant to be called from Settings ("replay onboarding").
  Future<void> reset() async {
    await ref
        .read(keyValueStorageProvider)
        .setBool(PreferenceKeys.onboardingCompleted, value: false);
    state = const AsyncData(false);
  }
}
