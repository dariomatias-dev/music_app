/// Keys used to read and write values in the key-value storage.
abstract final class PreferenceKeys {
  /// Stores the user's selected locale.
  static const locale = 'locale';

  /// Stores whether the user has completed onboarding.
  static const onboardingCompleted = 'onboardingCompleted';

  /// Stores the last playback session (queue, current index and position).
  static const playbackSession = 'playbackSession';
}
