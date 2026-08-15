import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/history/presentation/providers/history_providers.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/library/presentation/widgets/media_card.dart';
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
            itemBuilder: (context, index) => MediaCard(
              seed: tracks[index].id,
              title: tracks[index].title,
              subtitle: artistNames[tracks[index].artistId],
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
