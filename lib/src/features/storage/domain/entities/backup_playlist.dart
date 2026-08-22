import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_playlist.freezed.dart';
part 'backup_playlist.g.dart';

/// A playlist's portable representation inside a backup snapshot.
///
/// Tracks are referenced by [trackSourceIds] rather than internal track
/// ids, since ids are only stable within one install; the source id
/// survives a re-scan on a fresh install and is what restoring resolves
/// against.
@freezed
abstract class BackupPlaylist with _$BackupPlaylist {
  /// Creates a [BackupPlaylist].
  const factory BackupPlaylist({
    required String name,
    required bool isFavorite,
    required List<String> trackSourceIds,
    String? description,
  }) = _BackupPlaylist;

  /// Creates a [BackupPlaylist] from its JSON representation.
  factory BackupPlaylist.fromJson(Map<String, dynamic> json) =>
      _$BackupPlaylistFromJson(json);
}
