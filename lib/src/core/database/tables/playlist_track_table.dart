import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/tables/playlist_table.dart';
import 'package:music_app/src/core/database/tables/track_table.dart';

/// Ordered membership of tracks within a playlist.
///
/// Implements [PlaylistTable]'s `trackIds`, which SQLite cannot represent
/// as a native column, and is what enables reordering.
// Every read and rewrite of a playlist filters on `playlistId` and
// orders by `position`; deleting a track filters on `trackId`.
@TableIndex(name: 'playlist_track_playlist', columns: {#playlistId, #position})
@TableIndex(name: 'playlist_track_track', columns: {#trackId})
@DataClassName('PlaylistTrackRow')
class PlaylistTrackTable extends Table {
  /// Primary key.
  IntColumn get id => integer().autoIncrement()();

  /// The playlist this entry belongs to.
  TextColumn get playlistId => text().references(PlaylistTable, #id)();

  /// The referenced track.
  TextColumn get trackId => text().references(TrackTable, #id)();

  /// Position of the track within the playlist.
  IntColumn get position => integer()();
}
