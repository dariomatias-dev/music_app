import 'dart:async';
import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/history/presentation/providers/history_providers.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

/// Recently played tracks, as a horizontal row of cards. Hidden entirely
/// once there's no history yet.
class HomeRecentlyPlayed extends ConsumerWidget {
  /// Creates a [HomeRecentlyPlayed].
  const HomeRecentlyPlayed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final tracks = ref.watch(recentTracksProvider);
    final artistNames = ref.watch(artistNamesProvider);
    final albumArtwork = ref.watch(albumArtworkProvider);

    if (tracks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: Text(
            l10n.recentlyPlayedLabel,
            style: AppTypography.section.copyWith(color: colors.textPrimary),
          ),
        ),
        SizedBox(
          height: 184,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: tracks.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.smMd),
            itemBuilder: (context, index) => _RecentTrackCard(
              track: tracks[index],
              artistName: artistNames[tracks[index].artistId],
              artworkPath: albumArtwork[tracks[index].albumId],
              onTap: () => unawaited(
                ref
                    .read(queueViewModelProvider.notifier)
                    .playFromSource(tracks, startIndex: index),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentTrackCard extends StatelessWidget {
  const _RecentTrackCard({
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
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Pressable(
      scale: 0.98,
      onTap: onTap,
      child: SizedBox(
        width: 128,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _artwork(),
            const SizedBox(height: AppSpacing.xs),
            Text(
              track.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.rowTitle.copyWith(color: colors.textPrimary),
            ),
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
    );
  }

  Widget _artwork() {
    final path = artworkPath;
    if (path == null) {
      return AppArtwork(seed: track.id, size: 128);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Image.file(
        File(path),
        width: 128,
        height: 128,
        fit: BoxFit.cover,
      ),
    );
  }
}
