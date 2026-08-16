import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/core/widgets/cached_square_image.dart';

/// A queue item's cover: the embedded artwork when cached on disk, or a
/// deterministic procedural cover otherwise.
class TrackArtwork extends StatelessWidget {
  /// Creates a [TrackArtwork].
  const TrackArtwork({
    required this.item,
    required this.size,
    required this.radius,
    super.key,
  });

  /// The item whose artwork to show.
  final QueueMediaItem item;

  /// The artwork's side length.
  final double size;

  /// Corner radius applied to the artwork.
  final double radius;

  @override
  Widget build(BuildContext context) {
    final artworkPath = item.artworkPath;
    if (artworkPath == null) {
      return AppArtwork(seed: item.id, size: size, radius: radius);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedSquareImage(path: artworkPath, size: size),
    );
  }
}
