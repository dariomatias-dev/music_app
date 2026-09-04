import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/navigators/library_navigator.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';

/// Every indexed artist, tapping through to their detail screen.
class ArtistsTab extends ConsumerWidget {
  /// Creates an [ArtistsTab].
  const ArtistsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final artists = ref.watch(sortedArtistsProvider);
    final tracksByArtist = ref.watch(tracksByArtistProvider);

    if (artists.isEmpty) {
      return AppEmptyState(
        icon: Icons.person_outline,
        title: l10n.artistsEmptyTitle,
        message: l10n.artistsEmptyMessage,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.smMd),
      itemCount: artists.length,
      itemBuilder: (context, index) => _ArtistRow(
        artist: artists[index],
        trackCount: tracksByArtist[artists[index].id]?.length ?? 0,
      ),
    );
  }
}

class _ArtistRow extends StatelessWidget {
  const _ArtistRow({required this.artist, required this.trackCount});

  final Artist artist;

  /// How many of the artist's tracks are still on the device, which their
  /// stored total only catches up with on the next scan.
  final int trackCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Pressable(
      scale: 0.99,
      onTap: () => LibraryNavigator.openArtist(context, artistId: artist.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.smMd,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            AppArtwork(seed: artist.id, size: 48, circle: true),
            const SizedBox(width: AppSpacing.smMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    artist.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.rowTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.trackCountLabel(trackCount),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.rowSubtitle.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.textTertiary),
          ],
        ),
      ),
    );
  }
}
