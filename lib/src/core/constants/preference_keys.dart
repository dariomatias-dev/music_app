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

  /// Stores whether gapless playback is enabled.
  static const gaplessEnabled = 'gaplessEnabled';

  /// Stores the crossfade duration, in seconds (0 means off).
  static const crossfadeDurationSeconds = 'crossfadeDurationSeconds';

  /// Stores the default playback speed applied when a new queue starts.
  static const defaultPlaybackSpeed = 'defaultPlaybackSpeed';

  /// Stores whether haptic feedback is enabled on playback controls.
  static const hapticsEnabled = 'hapticsEnabled';
}
