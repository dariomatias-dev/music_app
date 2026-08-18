import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/playlist/domain/entities/playlist.dart';
import 'package:music_app/src/features/playlist/presentation/providers/playlist_providers.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_more_sheet.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_name_sheet.dart';

/// Every playlist, with create/rename/duplicate/delete management.
class PlaylistsTab extends ConsumerWidget {
  /// Creates a [PlaylistsTab].
  const PlaylistsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final playlists = ref.watch(playlistsProvider).value ?? const [];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xxs,
            AppSpacing.smMd,
            AppSpacing.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Pressable(
                scale: 0.95,
                onTap: () => unawaited(_createPlaylist(context, ref)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.xxs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 18,
                        color: colors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(
                        l10n.newPlaylistLabel,
                        style: AppTypography.meta.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: playlists.isEmpty
              ? AppEmptyState(
                  icon: Icons.queue_music_rounded,
                  title: l10n.playlistsEmptyTitle,
                  message: l10n.playlistsEmptyMessage,
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.smMd,
                  ),
                  itemCount: playlists.length,
                  itemBuilder: (context, index) =>
                      _PlaylistRow(playlist: playlists[index]),
                ),
        ),
      ],
    );
  }

  Future<void> _createPlaylist(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showPlaylistNameSheet(
      context,
      title: l10n.newPlaylistLabel,
      confirmLabel: l10n.createLabel,
    );
    if (result == null) return;
    await ref.read(playlistRepositoryProvider).createPlaylist(result.name);
  }
}

class _PlaylistRow extends ConsumerWidget {
  const _PlaylistRow({required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final trackIds = ref.watch(playlistTrackIdsProvider(playlist.id));

    return Pressable(
      scale: 0.99,
      onTap: () => context.push(RoutePaths.playlist(playlist.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.smMd,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            AppArtwork(seed: playlist.id, size: 48, radius: AppRadius.small),
            const SizedBox(width: AppSpacing.smMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    playlist.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.rowTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.trackCountLabel(trackIds.value?.length ?? 0),
                    style: AppTypography.rowSubtitle.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            AppIconButton(
              icon: Icons.more_horiz,
              color: colors.textSecondary,
              semanticLabel: l10n.playlistOptionsSemanticLabel,
              onPressed: () =>
                  unawaited(showPlaylistMoreSheet(context, ref, playlist)),
            ),
          ],
        ),
      ),
    );
  }
}
