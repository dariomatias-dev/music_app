import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/core/widgets/cached_square_image.dart';

/// A media list row: artwork, title, an optional subtitle, and an optional
/// trailing widget, tappable.
///
/// The shared row pattern for track, album, artist and playlist rows shown
/// in vertical lists (search results, …).
class MediaRow extends StatelessWidget {
  /// Creates a [MediaRow].
  const MediaRow({
    required this.seed,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.artworkPath,
    this.circle = false,
    this.trailing,
    super.key,
  });

  /// Identifier used to seed the procedural cover when [artworkPath] is
  /// absent.
  final String seed;

  /// The row's title.
  final String title;

  /// Called when tapped.
  final VoidCallback onTap;

  /// Optional line shown below the title.
  final String? subtitle;

  /// Path to a cached artwork image on disk, if any.
  final String? artworkPath;

  /// Whether to clip the artwork as a circle (e.g. for an artist).
  final bool circle;

  /// Optional trailing content (e.g. a duration, a chevron, a button).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitleText = subtitle;

    return Pressable(
      scale: 0.99,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.smMd,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            _artwork(),
            const SizedBox(width: AppSpacing.smMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.rowTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  if (subtitleText != null && subtitleText.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitleText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.rowSubtitle.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Flexible(child: trailing!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _artwork() {
    const size = 44.0;
    final path = artworkPath;
    if (path == null) {
      return AppArtwork(seed: seed, size: size, circle: circle);
    }
    final image = CachedSquareImage(path: path, size: size);
    return circle
        ? ClipOval(child: image)
        : ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.small),
            child: image,
          );
  }
}
