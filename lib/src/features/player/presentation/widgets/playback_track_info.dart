import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/core/navigation/navigators/library_navigator.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/presentation/providers/favorite_providers.dart';

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
    return Row(
      children: [
        Expanded(child: _TrackLabel(item: item)),
        const SizedBox(width: AppSpacing.smMd),
        _FavoriteButton(trackId: item.id),
      ],
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.trackId});

  final String trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isFavorited = ref.watch(isFavoriteProvider(trackId)).value ?? false;

    return AppIconButton(
      icon: isFavorited ? Icons.favorite : Icons.favorite_border,
      color: isFavorited ? context.colors.textPrimary : null,
      onPressed: () => unawaited(
        ref
            .read(favoriteRepositoryProvider)
            .setFavorite(trackId, isFavorite: !isFavorited),
      ),
      semanticLabel: isFavorited
          ? l10n.unfavoriteButtonSemanticLabel
          : l10n.favoriteButtonSemanticLabel,
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
                : () => LibraryNavigator.openAlbum(context, albumId: albumId),
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
                : () =>
                      LibraryNavigator.openArtist(context, artistId: artistId),
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
