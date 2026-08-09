import 'package:drift/drift.dart';

/// Indexed artists.
@DataClassName('ArtistRow')
class ArtistTable extends Table {
  /// Primary key (UUID v7).
  TextColumn get id => text()();

  /// Stable key from the source (MediaStore/filesystem) used to reconcile
  /// re-scans.
  TextColumn get sourceId => text()();

  /// Artist name.
  TextColumn get name => text()();

  /// Number of albums by this artist.
  IntColumn get albumCount => integer()();

  /// Number of tracks by this artist.
  IntColumn get trackCount => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
