import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/tables/artist_table.dart';

/// Indexed albums.
@DataClassName('AlbumRow')
class AlbumTable extends Table {
  /// Primary key (UUID v7).
  TextColumn get id => text()();

  /// Stable key from the source (MediaStore/filesystem) used to reconcile
  /// re-scans.
  TextColumn get sourceId => text()();

  /// Album title.
  TextColumn get title => text()();

  /// The album's artist.
  TextColumn get artistId => text().references(ArtistTable, #id)();

  /// Release year.
  IntColumn get year => integer().nullable()();

  /// Number of tracks in the album.
  IntColumn get trackCount => integer()();

  /// Total duration, in milliseconds.
  IntColumn get totalDuration => integer()();

  /// Path to the cached artwork, if any.
  TextColumn get artworkPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
