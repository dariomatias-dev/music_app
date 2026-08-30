import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/library/presentation/widgets/artist_screen/artist_album_card.dart';
import 'package:music_app/src/features/library/presentation/widgets/artist_screen/artist_header.dart';
import 'package:music_app/src/features/library/presentation/widgets/artist_screen/artist_track_row.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_screen_view_model.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

/// An artist's details: albums and their full discography, with a
/// play-all button.
class ArtistScreen extends ConsumerWidget {
  /// Creates an [ArtistScreen].
  const ArtistScreen({required this.artistId, super.key});

  /// The artist to show.
  final String artistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final artist = ref.watch(artistByIdProvider(artistId));

    if (artist == null) {
      return AppScaffold(
        topBar: AppTopBar(
          backButtonSemanticLabel: l10n.backButtonSemanticLabel,
        ),
        body: AppEmptyState(
          icon: Icons.person_outline,
          title: l10n.artistNotFoundTitle,
          message: l10n.artistNotFoundMessage,
        ),
      );
    }

    final albums = ref.watch(artistAlbumsProvider(artistId));
    final tracks = ref.watch(artistTracksProvider(artistId));
    final currentTrackId = ref.watch(playbackScreenViewModelProvider)?.id;

    // Fixed rows (header, play button, and the horizontal albums strip
    // when there are any) come before the track list; offsetting by their
    // count lets a single ListView.builder lazily build the whole screen,
    // so a large discography doesn't build every row upfront.
    final fixedRowCount = albums.isEmpty ? 2 : 4;

    return AppScaffold(
      topBar: AppTopBar(
        title: artist.name,
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
        itemCount: fixedRowCount + tracks.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ArtistHeader(artist: artist, albumCount: albums.length);
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
          if (albums.isNotEmpty && index == 2) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Text(
                l10n.libraryAlbumsTab,
                style: AppTypography.section.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
            );
          }
          if (albums.isNotEmpty && index == 3) {
            return SizedBox(
              height: 168,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                itemCount: albums.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: AppSpacing.smMd),
                itemBuilder: (context, index) =>
                    ArtistAlbumCard(album: albums[index]),
              ),
            );
          }
          final trackIndex = index - fixedRowCount;
          final track = tracks[trackIndex];
          return ArtistTrackRow(
            track: track,
            current: track.id == currentTrackId,
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
