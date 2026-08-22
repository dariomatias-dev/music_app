// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BackupSettings _$BackupSettingsFromJson(Map<String, dynamic> json) =>
    _BackupSettings(
      gaplessEnabled: json['gaplessEnabled'] as bool,
      crossfadeDurationSeconds: (json['crossfadeDurationSeconds'] as num)
          .toInt(),
      defaultPlaybackSpeed: (json['defaultPlaybackSpeed'] as num).toDouble(),
      hapticsEnabled: json['hapticsEnabled'] as bool,
      locale: json['locale'] as String?,
      themeMode: json['themeMode'] as String?,
      userDisplayName: json['userDisplayName'] as String?,
    );

Map<String, dynamic> _$BackupSettingsToJson(_BackupSettings instance) =>
    <String, dynamic>{
      'gaplessEnabled': instance.gaplessEnabled,
      'crossfadeDurationSeconds': instance.crossfadeDurationSeconds,
      'defaultPlaybackSpeed': instance.defaultPlaybackSpeed,
      'hapticsEnabled': instance.hapticsEnabled,
      'locale': instance.locale,
      'themeMode': instance.themeMode,
      'userDisplayName': instance.userDisplayName,
    };
