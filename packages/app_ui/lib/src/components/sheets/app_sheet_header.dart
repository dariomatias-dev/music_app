import 'dart:typed_data';

import 'package:app_ui/src/components/artwork/app_artwork.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// Standard header of a bottom sheet showing which item (track, album,
/// artist or playlist) it acts on.
class AppSheetHeader extends StatelessWidget {
  /// Creates an [AppSheetHeader].
  const AppSheetHeader({
    required this.artworkSeed,
    required this.title,
    required this.subtitle,
    this.artworkBytes,
    super.key,
  });

  /// Identifier used to derive the procedural artwork when [artworkBytes]
  /// is not provided.
  final String artworkSeed;

  /// Bytes of an embedded cover image, if any.
  final Uint8List? artworkBytes;

  /// The header's primary text.
  final String title;

  /// The header's secondary text.
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 10),
      child: Row(
        children: [
          AppArtwork(
            seed: artworkSeed,
            imageBytes: artworkBytes,
            size: 52,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.section.copyWith(
                    fontSize: 16,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.rowSubtitle.copyWith(
                    fontSize: 13,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
