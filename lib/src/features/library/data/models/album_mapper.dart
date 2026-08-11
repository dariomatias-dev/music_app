import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';

/// Converts a persisted [AlbumRow] into an [Album] domain entity.
extension AlbumRowMapper on AlbumRow {
  /// Maps this row to its domain [Album], converting the stored total
  /// duration (milliseconds) into a [Duration].
  Album toEntity() {
    return Album(
      id: id,
      sourceId: sourceId,
      title: title,
      artistId: artistId,
      trackCount: trackCount,
      totalDuration: Duration(milliseconds: totalDuration),
      year: year,
      artworkPath: artworkPath,
    );
  }
}

/// Converts an [Album] domain entity into a persistable companion.
extension AlbumEntityMapper on Album {
  /// Maps this entity to an [AlbumTableCompanion], converting
  /// [totalDuration] into milliseconds for storage.
  AlbumTableCompanion toCompanion() {
    return AlbumTableCompanion.insert(
      id: id,
      sourceId: sourceId,
      title: title,
      artistId: artistId,
      trackCount: trackCount,
      totalDuration: totalDuration.inMilliseconds,
      year: Value(year),
      artworkPath: Value(artworkPath),
    );
  }
}
