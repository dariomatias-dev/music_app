import 'package:freezed_annotation/freezed_annotation.dart';

part 'playback_preferences.freezed.dart';

/// The user's playback preferences.
@freezed
abstract class PlaybackPreferences with _$PlaybackPreferences {
  /// Creates a [PlaybackPreferences].
  const factory PlaybackPreferences({
    /// Whether tracks advance into each other with no silence between them.
    /// Only relevant when [crossfadeDuration] is zero.
    @Default(true) bool gaplessEnabled,

    /// How long each track fades in from silence when it starts. Zero
    /// means no crossfade.
    @Default(Duration.zero) Duration crossfadeDuration,

    /// Playback speed applied whenever a new queue starts playing.
    @Default(1.0) double defaultSpeed,

    /// Whether playback controls give haptic feedback when tapped.
    @Default(true) bool hapticsEnabled,
  }) = _PlaybackPreferences;
}
