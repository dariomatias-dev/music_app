/// Reads lyrics text directly from an audio file or its sidecar.
abstract interface class LyricsReader {
  /// Reads lyrics embedded in the audio file's own tags, if supported for
  /// its format and present.
  ///
  /// Unsupported formats, missing tags or unparseable data yield `null`
  /// instead of throwing.
  Future<String?> readEmbedded(String filePath);

  /// Reads a sidecar `.lrc` file next to the audio file at [filePath], if
  /// one exists.
  Future<String?> readSidecar(String filePath);
}
