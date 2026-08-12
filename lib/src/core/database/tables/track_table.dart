import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/tables/album_table.dart';
import 'package:music_app/src/core/database/tables/artist_table.dart';

/// Indexed tracks.
@DataClassName('TrackRow')
class TrackTable extends Table {
  /// Primary key (UUID v7).
  TextColumn get id => text()();

  /// Stable key from the source (MediaStore/filesystem) used to reconcile
  /// re-scans.
  TextColumn get sourceId => text()();

  /// Path to the audio file on disk.
  TextColumn get filePath => text()();

  /// Track title.
  TextColumn get title => text()();

  /// The track's artist.
  TextColumn get artistId => text().references(ArtistTable, #id)();

  /// The track's album.
  TextColumn get albumId => text().references(AlbumTable, #id)();

  /// Position within the album, if known.
  IntColumn get trackNumber => integer().nullable()();

  /// Disc number within the album, if known.
  IntColumn get discNumber => integer().nullable()();

  /// Duration, in milliseconds.
  IntColumn get duration => integer()();

  /// Release year, if known.
  IntColumn get year => integer().nullable()();

  /// Genre, if known.
  TextColumn get genre => text().nullable()();

  /// Bitrate, in bits per second, if known.
  IntColumn get bitrate => integer().nullable()();

  /// Sample rate, in Hz, if known.
  IntColumn get sampleRate => integer().nullable()();

  /// File format (e.g. mp3, flac).
  TextColumn get format => text()();

  /// File size, in bytes.
  IntColumn get fileSize => integer()();

  /// Whether the file has an embedded artwork image.
  BoolColumn get hasEmbeddedArtwork => boolean()();

  /// Whether the file was not found by the most recent scan.
  BoolColumn get isMissing => boolean().withDefault(const Constant(false))();

  /// When the track was added to the library.
  DateTimeColumn get dateAdded => dateTime()();

  /// When the file was last modified.
  DateTimeColumn get dateModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
