import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_play_event.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_playlist.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_settings.dart';

part 'backup_snapshot.freezed.dart';
part 'backup_snapshot.g.dart';

/// A portable snapshot of every user-created piece of data: playlists,
/// favorites, playback history, excluded folders, search history and
/// preferences.
///
/// Deliberately excludes the indexed library (tracks, albums, artists),
/// which is rebuilt by scanning the device.
@freezed
abstract class BackupSnapshot with _$BackupSnapshot {
  /// Creates a [BackupSnapshot].
  const factory BackupSnapshot({
    required int formatVersion,
    required DateTime createdAt,
    required List<BackupPlaylist> playlists,
    required List<String> favoriteTrackSourceIds,
    required List<BackupPlayEvent> playHistory,
    required List<String> excludedFolders,
    required List<String> searchHistoryTerms,
    required BackupSettings settings,
  }) = _BackupSnapshot;

  /// Creates a [BackupSnapshot] from its JSON representation.
  factory BackupSnapshot.fromJson(Map<String, dynamic> json) =>
      _$BackupSnapshotFromJson(json);
}
