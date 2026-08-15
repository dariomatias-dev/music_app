/// A single supported audio file discovered on the device.
class ScannedAudioFile {
  /// Creates a [ScannedAudioFile].
  const ScannedAudioFile({
    required this.mediaStoreId,
    required this.filePath,
    required this.title,
    required this.duration,
    required this.fileExtension,
    required this.fileSize,
    required this.dateAdded,
    required this.dateModified,
    this.artist,
    this.album,
  });

  /// Identifier assigned by the platform's media store (e.g. used to query
  /// embedded artwork later).
  final int mediaStoreId;

  /// Path to the file on disk.
  final String filePath;

  /// Title reported by the media store.
  final String title;

  /// Duration reported by the media store.
  final Duration duration;

  /// Lowercase file extension, without the leading dot.
  final String fileExtension;

  /// File size, in bytes.
  final int fileSize;

  /// When the file was added to the device's media store.
  final DateTime dateAdded;

  /// When the file was last modified.
  final DateTime dateModified;

  /// Artist name reported by the media store, if any.
  final String? artist;

  /// Album title reported by the media store, if any.
  final String? album;
}

/// Scans the device for supported audio files.
abstract interface class MediaScanner {
  /// Requests the media permission if needed, then returns every supported
  /// audio file, respecting [includedFolders] and [excludedFolders] and
  /// ignoring files shorter than [minimumDuration].
  ///
  /// An empty [includedFolders] means no folder restriction (everything not
  /// excluded is included).
  Future<List<ScannedAudioFile>> scan({
    List<String> includedFolders,
    List<String> excludedFolders,
    Duration minimumDuration,
  });

  /// Notifies the platform's media store that the file at [path] changed
  /// (or no longer exists), so it's dropped from or refreshed in future
  /// scans.
  Future<void> notifyFileRemoved(String path);
}
