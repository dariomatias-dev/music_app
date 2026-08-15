import 'dart:async';
import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

/// Every favorited track, most recently favorited first, with
/// tap-to-play-from-here and an unfavorite action per row.
class FavoritesTab extends ConsumerWidget {
  /// Creates a [FavoritesTab].
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final tracks = ref.watch(favoriteTracksProvider);
    final artistNames = ref.watch(artistNamesProvider);
    final albumArtwork = ref.watch(albumArtworkProvider);

    if (tracks.isEmpty) {
      return AppEmptyState(
        icon: Icons.favorite_border,
        title: l10n.favoritesEmptyTitle,
        message: l10n.favoritesEmptyMessage,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.smMd),
      itemCount: tracks.length,
      itemBuilder: (context, index) => _FavoriteRow(
        track: tracks[index],
        artistName: artistNames[tracks[index].artistId],
        artworkPath: albumArtwork[tracks[index].albumId],
        onTap: () => unawaited(
          ref
              .read(queueViewModelProvider.notifier)
              .playFromSource(tracks, startIndex: index),
        ),
      ),
    );
  }
}

class _FavoriteRow extends ConsumerWidget {
  const _FavoriteRow({
    required this.track,
    required this.artistName,
    required this.artworkPath,
    required this.onTap,
  });

  final Track track;
  final String? artistName;
  final String? artworkPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

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
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.rowTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    artistName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.rowSubtitle.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            AppIconButton(
              icon: Icons.favorite,
              color: colors.textPrimary,
              semanticLabel: l10n.unfavoriteButtonSemanticLabel,
              onPressed: () => unawaited(
                ref
                    .read(favoriteRepositoryProvider)
                    .setFavorite(track.id, isFavorite: false),
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
      return AppArtwork(seed: track.id, size: 44, radius: AppRadius.small);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: Image.file(File(path), width: 44, height: 44, fit: BoxFit.cover),
    );
  }
}
