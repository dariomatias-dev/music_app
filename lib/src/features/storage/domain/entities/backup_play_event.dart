import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_playlist.dart';

part 'backup_play_event.freezed.dart';
part 'backup_play_event.g.dart';

/// A single recorded play's portable representation inside a backup
/// snapshot.
///
/// The played track is referenced by [trackSourceId] rather than an
/// internal track id, since ids are only stable within one install; see
/// [BackupPlaylist] for the same reasoning.
@freezed
abstract class BackupPlayEvent with _$BackupPlayEvent {
  /// Creates a [BackupPlayEvent].
  const factory BackupPlayEvent({
    required String trackSourceId,
    required DateTime startedAt,
    required int playedDurationMs,
    required bool completed,
  }) = _BackupPlayEvent;

  /// Creates a [BackupPlayEvent] from its JSON representation.
  factory BackupPlayEvent.fromJson(Map<String, dynamic> json) =>
      _$BackupPlayEventFromJson(json);
}
