// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BackupPlaylist _$BackupPlaylistFromJson(Map<String, dynamic> json) =>
    _BackupPlaylist(
      name: json['name'] as String,
      isFavorite: json['isFavorite'] as bool,
      trackSourceIds: (json['trackSourceIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$BackupPlaylistToJson(_BackupPlaylist instance) =>
    <String, dynamic>{
      'name': instance.name,
      'isFavorite': instance.isFavorite,
      'trackSourceIds': instance.trackSourceIds,
      'description': instance.description,
    };
