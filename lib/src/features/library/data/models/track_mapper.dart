import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';

/// Converts a persisted [TrackRow] into a [Track] domain entity.
extension TrackRowMapper on TrackRow {
  /// Maps this row to its domain [Track], converting the stored duration
  /// (milliseconds) into a [Duration].
  Track toEntity() {
    return Track(
      id: id,
      sourceId: sourceId,
      filePath: filePath,
      title: title,
      artistId: artistId,
      albumId: albumId,
      duration: Duration(milliseconds: duration),
      format: format,
      fileSize: fileSize,
      hasEmbeddedArtwork: hasEmbeddedArtwork,
      dateAdded: dateAdded,
      dateModified: dateModified,
      trackNumber: trackNumber,
      discNumber: discNumber,
      year: year,
      genre: genre,
      bitrate: bitrate,
      sampleRate: sampleRate,
    );
  }
}

/// Converts a [Track] domain entity into a persistable companion.
extension TrackEntityMapper on Track {
  /// Maps this entity to a [TrackTableCompanion], converting [duration]
  /// into milliseconds for storage.
  TrackTableCompanion toCompanion() {
    return TrackTableCompanion.insert(
      id: id,
      sourceId: sourceId,
      filePath: filePath,
      title: title,
      artistId: artistId,
      albumId: albumId,
      duration: duration.inMilliseconds,
      format: format,
      fileSize: fileSize,
      hasEmbeddedArtwork: hasEmbeddedArtwork,
      dateAdded: dateAdded,
      dateModified: dateModified,
      trackNumber: Value(trackNumber),
      discNumber: Value(discNumber),
      year: Value(year),
      genre: Value(genre),
      bitrate: Value(bitrate),
      sampleRate: Value(sampleRate),
    );
  }
}
