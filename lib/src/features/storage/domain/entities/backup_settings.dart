import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_settings.freezed.dart';
part 'backup_settings.g.dart';

/// The user's preferences inside a backup snapshot.
///
/// Excludes preferences tied to this specific install rather than to the
/// user's choices: onboarding completion and the resumed playback session
/// reference state that a restore on a fresh install cannot meaningfully
/// carry over.
@freezed
abstract class BackupSettings with _$BackupSettings {
  /// Creates a [BackupSettings].
  const factory BackupSettings({
    required bool gaplessEnabled,
    required int crossfadeDurationSeconds,
    required double defaultPlaybackSpeed,
    required bool hapticsEnabled,
    String? locale,
    String? themeMode,
    String? userDisplayName,
  }) = _BackupSettings;

  /// Creates a [BackupSettings] from its JSON representation.
  factory BackupSettings.fromJson(Map<String, dynamic> json) =>
      _$BackupSettingsFromJson(json);
}
