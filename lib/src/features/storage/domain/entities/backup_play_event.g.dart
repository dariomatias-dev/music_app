// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_play_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BackupPlayEvent _$BackupPlayEventFromJson(Map<String, dynamic> json) =>
    _BackupPlayEvent(
      trackSourceId: json['trackSourceId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      playedDurationMs: (json['playedDurationMs'] as num).toInt(),
      completed: json['completed'] as bool,
    );

Map<String, dynamic> _$BackupPlayEventToJson(_BackupPlayEvent instance) =>
    <String, dynamic>{
      'trackSourceId': instance.trackSourceId,
      'startedAt': instance.startedAt.toIso8601String(),
      'playedDurationMs': instance.playedDurationMs,
      'completed': instance.completed,
    };
