/// Keys used to read and write values in the key-value storage.
abstract final class PreferenceKeys {
  /// Stores the user's selected locale.
  static const locale = 'locale';

  /// Stores whether the user has completed onboarding.
  static const onboardingCompleted = 'onboardingCompleted';

  /// Stores the last playback session (queue, current index and position).
  static const playbackSession = 'playbackSession';

  /// Stores the user's display name, shown in the Home greeting.
  static const userDisplayName = 'userDisplayName';

  /// Stores the user's selected theme mode.
  static const themeMode = 'themeMode';
}
