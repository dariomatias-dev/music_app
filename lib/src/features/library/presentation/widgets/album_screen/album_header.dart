import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/navigators/library_navigator.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/core/widgets/cached_square_image.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';

/// The album screen's header: cover, title, artist link and a track
/// count/duration line.
class AlbumHeader extends StatelessWidget {
  /// Creates an [AlbumHeader].
  const AlbumHeader({
    required this.album,
    required this.artistName,
    required this.trackCount,
    required this.totalDuration,
    super.key,
  });

  /// The album being shown.
  final Album album;

  /// The album's artist name, if resolved.
  final String? artistName;

  /// How many of the album's tracks are still on the device.
  ///
  /// Passed in rather than read off [album]: its stored total is only
  /// recomputed by a scan, so it would keep counting files deleted since
  /// and disagree with the list right below this header.
  final int trackCount;

  /// Total playing time of those tracks.
  final Duration totalDuration;

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
          _artwork(),
          const SizedBox(height: AppSpacing.md),
          Text(
            album.title,
            textAlign: TextAlign.center,
            style: AppTypography.header.copyWith(color: colors.textPrimary),
          ),
          if (artistName != null) ...[
            const SizedBox(height: 4),
            Pressable(
              onTap: () => LibraryNavigator.openArtist(
                context,
                artistId: album.artistId,
              ),
              child: Text(
                artistName!,
                style: AppTypography.rowSubtitle.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            '${l10n.trackCountLabel(trackCount)} · '
            '${formatDuration(totalDuration)}',
            style: AppTypography.caption.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _artwork() {
    final artworkPath = album.artworkPath;
    if (artworkPath == null) {
      return AppArtwork(seed: album.id, size: 160, radius: AppRadius.large);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: CachedSquareImage(path: artworkPath, size: 160),
    );
  }
}
