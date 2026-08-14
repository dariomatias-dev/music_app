import 'package:audio_service/audio_service.dart' as audio_service;

/// Metadata published to the OS media notification and lock screen for a
/// single queue item.
class QueueMediaItem {
  /// Creates a [QueueMediaItem].
  const QueueMediaItem({
    required this.id,
    required this.filePath,
    required this.title,
    this.artist,
    this.artistId,
    this.album,
    this.albumId,
    this.duration,
    this.artworkPath,
  });

  /// Stable identifier of the underlying track.
  final String id;

  /// Path to the audio file on disk.
  final String filePath;

  /// Track title.
  final String title;

  /// Artist name.
  final String? artist;

  /// Id of the artist, for navigating to their detail screen.
  final String? artistId;

  /// Album title.
  final String? album;

  /// Id of the album, for navigating to its detail screen.
  final String? albumId;

  /// Track duration, when known ahead of loading.
  final Duration? duration;

  /// Path to a cached artwork image on disk, if any.
  final String? artworkPath;

  /// Converts this item to the `audio_service` [audio_service.MediaItem]
  /// published to the OS.
  audio_service.MediaItem toMediaItem() {
    return audio_service.MediaItem(
      id: id,
      title: title,
      artist: artist,
      album: album,
      duration: duration,
      artUri: artworkPath == null ? null : Uri.file(artworkPath!),
    );
  }
}
