import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';

/// Every indexed album, tapping through to its detail screen.
class AlbumsTab extends ConsumerWidget {
  /// Creates an [AlbumsTab].
  const AlbumsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final albums = ref.watch(sortedAlbumsProvider);
    final artistNames = ref.watch(artistNamesProvider);

    if (albums.isEmpty) {
      return AppEmptyState(
        icon: Icons.album_outlined,
        title: l10n.albumsEmptyTitle,
        message: l10n.albumsEmptyMessage,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.smMd),
      itemCount: albums.length,
      itemBuilder: (context, index) => _AlbumRow(
        album: albums[index],
        artistName: artistNames[albums[index].artistId],
      ),
    );
  }
}

class _AlbumRow extends StatelessWidget {
  const _AlbumRow({required this.album, required this.artistName});

  final Album album;
  final String? artistName;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Pressable(
      scale: 0.99,
      onTap: () => context.push(RoutePaths.album(album.id)),
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
                    album.title,
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
            Icon(Icons.chevron_right_rounded, color: colors.textTertiary),
          ],
        ),
      ),
    );
  }

  Widget _artwork() {
    final artworkPath = album.artworkPath;
    if (artworkPath == null) {
      return AppArtwork(seed: album.id, size: 48, radius: AppRadius.small);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: Image.file(
        File(artworkPath),
        width: 48,
        height: 48,
        fit: BoxFit.cover,
      ),
    );
  }
}
