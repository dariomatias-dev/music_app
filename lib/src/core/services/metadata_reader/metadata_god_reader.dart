import 'package:metadata_god/metadata_god.dart' as metadata_god;
import 'package:music_app/src/core/services/metadata_reader/metadata_reader.dart';

/// Reads the raw tags of the file at `file`.
typedef RawMetadataReader =
    Future<metadata_god.Metadata> Function({required String file});

/// [MetadataReader] implementation backed by `metadata_god`.
class MetadataGodReader implements MetadataReader {
  /// Creates a [MetadataGodReader], optionally over an existing [readRaw]
  /// (useful for tests).
  const MetadataGodReader({
    RawMetadataReader readRaw = metadata_god.MetadataGod.readMetadata,
  }) : _readRaw = readRaw;

  final RawMetadataReader _readRaw;

  @override
  Future<TrackMetadata> read(String filePath) async {
    final metadata_god.Metadata metadata;
    try {
      metadata = await _readRaw(file: filePath);
    } on Exception {
      return const TrackMetadata();
    }

    return TrackMetadata(
      title: metadata.title,
      artist: metadata.artist,
      album: metadata.album,
      albumArtist: metadata.albumArtist,
      trackNumber: metadata.trackNumber,
      discNumber: metadata.discNumber,
      year: metadata.year,
      genre: metadata.genre,
      duration: metadata.duration,
      artwork: _toEmbeddedArtwork(metadata.picture),
    );
  }

  EmbeddedArtwork? _toEmbeddedArtwork(metadata_god.Picture? picture) {
    if (picture == null) return null;
    return EmbeddedArtwork(data: picture.data, mimeType: picture.mimeType);
  }
}
