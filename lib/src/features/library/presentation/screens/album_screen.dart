import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/library/presentation/widgets/album_screen/album_header.dart';
import 'package:music_app/src/features/library/presentation/widgets/album_screen/album_track_row.dart';
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
            return AlbumHeader(album: album, artistName: artistName);
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
          return AlbumTrackRow(
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
