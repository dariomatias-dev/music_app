import 'dart:async';
import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
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

    return AppScaffold(
      topBar: AppTopBar(
        title: artist.name,
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
        children: [
          _ArtistHeader(artist: artist, albumCount: albums.length),
          Padding(
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
          ),
          if (albums.isNotEmpty) ...[
            Padding(
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
            ),
            SizedBox(
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
                    _ArtistAlbumCard(album: albums[index]),
              ),
            ),
          ],
          for (var i = 0; i < tracks.length; i++)
            _ArtistTrackRow(
              track: tracks[i],
              onTap: () => unawaited(
                ref
                    .read(queueViewModelProvider.notifier)
                    .playFromSource(tracks, startIndex: i),
              ),
            ),
        ],
      ),
    );
  }
}

class _ArtistHeader extends StatelessWidget {
  const _ArtistHeader({required this.artist, required this.albumCount});

  final Artist artist;
  final int albumCount;

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
          AppArtwork(seed: artist.id, size: 140, circle: true),
          const SizedBox(height: AppSpacing.md),
          Text(
            artist.name,
            textAlign: TextAlign.center,
            style: AppTypography.header.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            '${l10n.trackCountLabel(artist.trackCount)} · '
            '${l10n.albumCountLabel(albumCount)}',
            style: AppTypography.caption.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _ArtistAlbumCard extends StatelessWidget {
  const _ArtistAlbumCard({required this.album});

  final Album album;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Pressable(
      scale: 0.98,
      onTap: () => context.push(RoutePaths.album(album.id)),
      child: SizedBox(
        width: 128,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _artwork(),
            const SizedBox(height: AppSpacing.xs),
            Text(
              album.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.rowTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _artwork() {
    final artworkPath = album.artworkPath;
    if (artworkPath == null) {
      return AppArtwork(seed: album.id, size: 128);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Image.file(
        File(artworkPath),
        width: 128,
        height: 128,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _ArtistTrackRow extends StatelessWidget {
  const _ArtistTrackRow({required this.track, required this.onTap});

  final Track track;
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
            Expanded(
              child: Text(
                track.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.rowTitle.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              formatDuration(track.duration),
              style: AppTypography.meta.copyWith(color: colors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}
