import 'dart:typed_data';

import 'package:app_ui/src/animations/pressable.dart';
import 'package:app_ui/src/components/artwork/app_artwork.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_radius.dart';
import 'package:app_ui/src/tokens/app_spacing.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// The standard cover + title + subtitle + trailing row.
///
/// Used for tracks, albums, artists and playlists alike, so a row looks
/// identical wherever it appears.
class AppMediaRow extends StatelessWidget {
  /// Creates an [AppMediaRow].
  const AppMediaRow({
    required this.artworkSeed,
    required this.title,
    required this.subtitle,
    this.artworkBytes,
    this.onTap,
    this.circle = false,
    this.artworkSize = 46,
    this.trailing = const [],
    super.key,
  });

  /// Identifier used to derive the procedural artwork when [artworkBytes]
  /// is not provided (e.g. a track, album or artist id).
  final String artworkSeed;

  /// Bytes of an embedded cover image, if any.
  final Uint8List? artworkBytes;

  /// The row's primary text.
  final String title;

  /// The row's secondary text.
  final String subtitle;

  /// Called when the row is tapped.
  final VoidCallback? onTap;

  /// Whether the artwork is clipped as a circle (e.g. for an artist).
  final bool circle;

  /// The artwork's size.
  final double artworkSize;

  /// Widgets shown after the text, e.g. a playback indicator or actions.
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Pressable(
      scale: 0.99,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            AppArtwork(
              seed: artworkSeed,
              imageBytes: artworkBytes,
              size: artworkSize,
              radius: AppRadius.small,
              circle: circle,
            ),
            const SizedBox(width: 13),
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
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.rowSubtitle.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            ...trailing,
          ],
        ),
      ),
    );
  }
}
