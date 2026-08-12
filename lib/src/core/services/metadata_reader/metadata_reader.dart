import 'dart:typed_data';

/// Tag metadata and embedded artwork read directly from an audio file.
///
/// All fields are nullable: a file may have no tags at all, or only some of
/// them set.
class TrackMetadata {
  /// Creates a [TrackMetadata].
  const TrackMetadata({
    this.title,
    this.artist,
    this.album,
    this.albumArtist,
    this.trackNumber,
    this.discNumber,
    this.year,
    this.genre,
    this.duration,
    this.artwork,
  });

  /// Title tag.
  final String? title;

  /// Artist tag.
  final String? artist;

  /// Album title tag.
  final String? album;

  /// Album artist tag, distinct from the track [artist].
  final String? albumArtist;

  /// Track number within its album.
  final int? trackNumber;

  /// Disc number within a multi-disc album.
  final int? discNumber;

  /// Release year.
  final int? year;

  /// Genre tag.
  final String? genre;

  /// Duration reported by the tag reader.
  final Duration? duration;

  /// Embedded cover artwork, if any.
  final EmbeddedArtwork? artwork;
}

/// Raw bytes of a cover image embedded in an audio file.
class EmbeddedArtwork {
  /// Creates an [EmbeddedArtwork].
  const EmbeddedArtwork({required this.data, required this.mimeType});

  /// Encoded image bytes.
  final Uint8List data;

  /// MIME type of [data] (e.g. `image/jpeg`).
  final String mimeType;
}

/// Reads tag metadata and embedded artwork from audio files.
abstract interface class MetadataReader {
  /// Reads the metadata of the file at [filePath].
  ///
  /// Files with missing, unsupported or corrupt tags yield a
  /// [TrackMetadata] with null fields instead of throwing.
  Future<TrackMetadata> read(String filePath);
}
