import 'package:metadata_god/metadata_god.dart' as metadata_god;
import 'package:music_app/src/core/services/metadata_reader/metadata_god_reader.dart'
    show RawMetadataReader;

/// Writes the raw tags of the file at `file`.
typedef RawMetadataWriter =
    Future<void> Function({
      required String file,
      required metadata_god.Metadata metadata,
    });

/// Writes tag metadata to audio files.
abstract interface class MetadataWriter {
  /// Updates [filePath]'s title/artist/album tags, leaving every other tag
  /// (genre, year, track number, embedded artwork, ...) untouched.
  Future<void> writeTags(
    String filePath, {
    required String title,
    required String artist,
    required String album,
  });
}

/// [MetadataWriter] implementation backed by `metadata_god`.
class MetadataGodWriter implements MetadataWriter {
  /// Creates a [MetadataGodWriter], optionally over existing [readRaw] and
  /// [writeRaw] functions (useful for tests).
  const MetadataGodWriter({
    RawMetadataReader readRaw = metadata_god.MetadataGod.readMetadata,
    RawMetadataWriter writeRaw = metadata_god.MetadataGod.writeMetadata,
  }) : _readRaw = readRaw,
       _writeRaw = writeRaw;

  final RawMetadataReader _readRaw;
  final RawMetadataWriter _writeRaw;

  @override
  Future<void> writeTags(
    String filePath, {
    required String title,
    required String artist,
    required String album,
  }) async {
    final existing = await _readRaw(file: filePath);
    await _writeRaw(
      file: filePath,
      metadata: metadata_god.Metadata(
        title: title,
        artist: artist,
        album: album,
        durationMs: existing.durationMs,
        albumArtist: existing.albumArtist,
        trackNumber: existing.trackNumber,
        trackTotal: existing.trackTotal,
        discNumber: existing.discNumber,
        discTotal: existing.discTotal,
        year: existing.year,
        genre: existing.genre,
        picture: existing.picture,
        fileSize: existing.fileSize,
      ),
    );
  }
}
