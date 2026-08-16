import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/core/widgets/cached_square_image.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_screen_view_model.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

/// An album's details: cover, artist, track list, and a play-all button.
class AlbumScreen extends ConsumerWidget {
  /// Creates an [AlbumScreen].
  const AlbumScreen({required this.albumId, super.key});

  /// The album to show.
  final String albumId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final album = ref.watch(albumByIdProvider(albumId));

    if (album == null) {
      return AppScaffold(
        topBar: AppTopBar(
          backButtonSemanticLabel: l10n.backButtonSemanticLabel,
        ),
        body: AppEmptyState(
          icon: Icons.album_outlined,
          title: l10n.albumNotFoundTitle,
          message: l10n.albumNotFoundMessage,
        ),
      );
    }

    final tracks = ref.watch(albumTracksProvider(albumId));
    final artistName = ref.watch(artistNamesProvider)[album.artistId];
    final currentTrackId = ref.watch(playbackScreenViewModelProvider)?.id;
    final playing =
        ref.watch(
          playbackViewModelProvider.select((state) => state.value?.playing),
        ) ??
        false;

    return AppScaffold(
      topBar: AppTopBar(
        title: album.title,
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
        itemCount: tracks.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _AlbumHeader(album: album, artistName: artistName);
          }
          if (index == 1) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: AppPrimaryButton(
                label: l10n.playLabel,
                icon: Icons.play_arrow_rounded,
                onPressed: tracks.isEmpty
                    ? null
                    : () => unawaited(
                        ref
                            .read(queueViewModelProvider.notifier)
                            .playFromSource(tracks, startIndex: 0),
                      ),
              ),
            );
          }
          final trackIndex = index - 2;
          final track = tracks[trackIndex];
          return _AlbumTrackRow(
            track: track,
            number: trackIndex + 1,
            current: track.id == currentTrackId,
            playing: playing,
            onTap: () => unawaited(
              ref
                  .read(queueViewModelProvider.notifier)
                  .playFromSource(tracks, startIndex: trackIndex),
            ),
          );
        },
      ),
    );
  }
}

class _AlbumHeader extends StatelessWidget {
  const _AlbumHeader({required this.album, required this.artistName});

  final Album album;
  final String? artistName;

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
              onTap: () => context.push(RoutePaths.artist(album.artistId)),
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
            '${l10n.trackCountLabel(album.trackCount)} · '
            '${formatDuration(album.totalDuration)}',
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

class _AlbumTrackRow extends StatelessWidget {
  const _AlbumTrackRow({
    required this.track,
    required this.number,
    required this.current,
    required this.playing,
    required this.onTap,
  });

  final Track track;
  final int number;
  final bool current;
  final bool playing;
  final VoidCallback onTap;

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
            SizedBox(
              width: 24,
              child: Text(
                '$number',
                style: AppTypography.caption.copyWith(
                  color: colors.textTertiary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.smMd),
            Expanded(
              child: Text(
                track.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.rowTitle.copyWith(
                  color: current ? colors.accent : colors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            if (current)
              AppPlaybackIndicator(playing: playing, color: colors.accent)
            else
              Text(
                formatDuration(track.duration),
                style: AppTypography.meta.copyWith(
                  color: colors.textTertiary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
