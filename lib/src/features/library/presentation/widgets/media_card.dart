import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/core/widgets/cached_square_image.dart';

/// A square media card: artwork, title and an optional subtitle, tappable.
///
/// The shared card pattern for album, playlist, artist and track cards
/// shown in horizontal rows (Home, artist detail, …).
class MediaCard extends StatelessWidget {
  /// Creates a [MediaCard].
  const MediaCard({
    required this.seed,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.artworkPath,
    this.circle = false,
    this.size = 128,
    super.key,
  });

  /// Identifier used to seed the procedural cover when [artworkPath] is
  /// absent.
  final String seed;

  /// The card's title.
  final String title;

  /// Called when tapped.
  final VoidCallback onTap;

  /// Optional line shown below the title.
  final String? subtitle;

  /// Path to a cached artwork image on disk, if any.
  final String? artworkPath;

  /// Whether to clip the artwork as a circle (e.g. for an artist).
  final bool circle;

  /// The card's width and the artwork's side length.
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitleText = subtitle;

    return Pressable(
      scale: 0.98,
      onTap: onTap,
      child: SizedBox(
        width: size,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _artwork(),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.rowTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
            if (subtitleText != null && subtitleText.isNotEmpty)
              Text(
                subtitleText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.rowSubtitle.copyWith(
                  color: colors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _artwork() {
    final path = artworkPath;
    if (path == null) {
      return AppArtwork(seed: seed, size: size, circle: circle);
    }
    final image = CachedSquareImage(path: path, size: size);
    return circle
        ? ClipOval(child: image)
        : ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: image,
          );
  }
}
