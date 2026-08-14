import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';

/// Title and artist for the current track, left-aligned opposite the
/// favorite button, with title and artist each navigating to their album
/// or artist.
class PlaybackTrackInfo extends StatelessWidget {
  /// Creates a [PlaybackTrackInfo].
  const PlaybackTrackInfo({required this.item, super.key});

  /// The track to describe.
  final QueueMediaItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(child: _TrackLabel(item: item)),
        const SizedBox(width: AppSpacing.smMd),
        AppIconButton(
          icon: Icons.favorite_border,
          // Wired to real persistence in a later stage.
          onPressed: () {},
          semanticLabel: l10n.favoriteButtonSemanticLabel,
        ),
      ],
    );
  }
}

class _TrackLabel extends StatelessWidget {
  const _TrackLabel({required this.item});

  final QueueMediaItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final albumId = item.albumId;
    final artistId = item.artistId;

    return AnimatedSwitcher(
      duration: AppDurations.base,
      switchInCurve: AppCurves.emphasized,
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.centerLeft,
        children: [...previous, ?current],
      ),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.4),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: Column(
        key: ValueKey(item.id),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Pressable(
            scale: 0.97,
            onTap: albumId == null
                ? null
                : () => context.push(RoutePaths.album(albumId)),
            child: Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.header.copyWith(color: colors.textPrimary),
            ),
          ),
          const SizedBox(height: 3),
          Pressable(
            scale: 0.97,
            onTap: artistId == null
                ? null
                : () => context.push(RoutePaths.artist(artistId)),
            child: Text(
              item.artist ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.rowSubtitle.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
