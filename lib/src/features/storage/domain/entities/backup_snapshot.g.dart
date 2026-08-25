// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BackupSnapshot _$BackupSnapshotFromJson(Map<String, dynamic> json) =>
    _BackupSnapshot(
      formatVersion: (json['formatVersion'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      playlists: (json['playlists'] as List<dynamic>)
          .map((e) => BackupPlaylist.fromJson(e as Map<String, dynamic>))
          .toList(),
      favoriteTrackSourceIds: (json['favoriteTrackSourceIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      playHistory: (json['playHistory'] as List<dynamic>)
          .map((e) => BackupPlayEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      excludedFolders: (json['excludedFolders'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      searchHistoryTerms: (json['searchHistoryTerms'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      settings: BackupSettings.fromJson(
        json['settings'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$BackupSnapshotToJson(_BackupSnapshot instance) =>
    <String, dynamic>{
      'formatVersion': instance.formatVersion,
      'createdAt': instance.createdAt.toIso8601String(),
      'playlists': instance.playlists,
      'favoriteTrackSourceIds': instance.favoriteTrackSourceIds,
      'playHistory': instance.playHistory,
      'excludedFolders': instance.excludedFolders,
      'searchHistoryTerms': instance.searchHistoryTerms,
      'settings': instance.settings,
    };
