import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';

/// The artist screen's header: artwork, name and a track/album count line.
class ArtistHeader extends StatelessWidget {
  /// Creates an [ArtistHeader].
  const ArtistHeader({
    required this.artist,
    required this.trackCount,
    required this.albumCount,
    super.key,
  });

  /// The artist being shown.
  final Artist artist;

  /// How many of the artist's tracks are still on the device.
  ///
  /// Passed in rather than read off [artist], whose stored total is only
  /// recomputed by a scan and so still counts files deleted since.
  final int trackCount;

  /// Number of albums attributed to the artist.
  final int albumCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Column(
        children: [
          AppArtwork(seed: artist.id, size: 140, circle: true),
          const SizedBox(height: AppSpacing.md),
          Text(
            artist.name,
            textAlign: TextAlign.center,
            style: AppTypography.header.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            '${l10n.trackCountLabel(trackCount)} · '
            '${l10n.albumCountLabel(albumCount)}',
            style: AppTypography.caption.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}
