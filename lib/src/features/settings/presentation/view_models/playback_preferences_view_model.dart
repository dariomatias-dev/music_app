import 'package:app_ui/app_ui.dart';
import 'package:music_app/src/core/constants/preference_keys.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/settings/domain/entities/playback_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playback_preferences_view_model.g.dart';

/// Manages the user's playback preferences, persisting each choice.
///
/// Kept alive (rather than the default per-widget lifetime) since it's
/// read from outside any UI subscription, when a new queue starts and on
/// every track transition. Also mirrors [PlaybackPreferences.hapticsEnabled]
/// onto `Pressable.hapticsEnabled`, since the design system has no access
/// to app-level preferences of its own.
@Riverpod(keepAlive: true)
class PlaybackPreferencesViewModel extends _$PlaybackPreferencesViewModel {
  @override
  Future<PlaybackPreferences> build() async {
    final storage = ref.read(keyValueStorageProvider);
    final gaplessEnabled =
        await storage.getBool(PreferenceKeys.gaplessEnabled) ?? true;
    final crossfadeSeconds =
        await storage.getInt(PreferenceKeys.crossfadeDurationSeconds) ?? 0;
    final defaultSpeed =
        await storage.getDouble(PreferenceKeys.defaultPlaybackSpeed) ?? 1.0;
    final hapticsEnabled =
        await storage.getBool(PreferenceKeys.hapticsEnabled) ?? true;
    Pressable.hapticsEnabled = hapticsEnabled;

    return PlaybackPreferences(
      gaplessEnabled: gaplessEnabled,
      crossfadeDuration: Duration(seconds: crossfadeSeconds),
      defaultSpeed: defaultSpeed,
      hapticsEnabled: hapticsEnabled,
    );
  }

  /// Enables or disables gapless playback.
  Future<void> setGaplessEnabled({required bool enabled}) async {
    await ref
        .read(keyValueStorageProvider)
        .setBool(PreferenceKeys.gaplessEnabled, value: enabled);
    state = AsyncData(state.requireValue.copyWith(gaplessEnabled: enabled));
  }

  /// Sets the crossfade duration; [Duration.zero] turns it off.
  Future<void> setCrossfadeDuration(Duration duration) async {
    await ref
        .read(keyValueStorageProvider)
        .setInt(PreferenceKeys.crossfadeDurationSeconds, duration.inSeconds);
    state = AsyncData(
      state.requireValue.copyWith(crossfadeDuration: duration),
    );
  }

  /// Sets the default playback speed applied when a new queue starts.
  Future<void> setDefaultSpeed(double speed) async {
    await ref
        .read(keyValueStorageProvider)
        .setDouble(PreferenceKeys.defaultPlaybackSpeed, speed);
    state = AsyncData(state.requireValue.copyWith(defaultSpeed: speed));
  }

  /// Enables or disables haptic feedback on playback controls.
  Future<void> setHapticsEnabled({required bool enabled}) async {
    await ref
        .read(keyValueStorageProvider)
        .setBool(PreferenceKeys.hapticsEnabled, value: enabled);
    Pressable.hapticsEnabled = enabled;
    state = AsyncData(state.requireValue.copyWith(hapticsEnabled: enabled));
  }
}
