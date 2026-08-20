import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/navigators/library_navigator.dart';
import 'package:music_app/src/core/navigation/navigators/playlist_navigator.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/library/presentation/widgets/media_row.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';
import 'package:music_app/src/features/search/presentation/providers/search_results_provider.dart';
import 'package:music_app/src/features/search/presentation/view_models/search_view_model.dart';

/// The current search term's matches, grouped by type, or an empty state
/// when there's a term but nothing matched. Renders nothing while the term
/// itself is empty.
class SearchResultsList extends ConsumerWidget {
  /// Creates a [SearchResultsList].
  const SearchResultsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final searchTerm = ref.watch(searchViewModelProvider);
    final results = ref.watch(searchResultsProvider);
    final artistNames = ref.watch(artistNamesProvider);
    final albumArtwork = ref.watch(albumArtworkProvider);

    if (searchTerm.isEmpty) return const SizedBox.shrink();

    if (results.isEmpty) {
      return AppEmptyState(
        icon: Icons.search_off_rounded,
        title: l10n.searchResultsEmptyTitle,
        message: l10n.searchResultsEmptyMessage,
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: [
        if (results.tracks.isNotEmpty)
          _ResultSection(
            title: l10n.libraryTracksTab,
            children: [
              for (var i = 0; i < results.tracks.length; i++)
                MediaRow(
                  seed: results.tracks[i].id,
                  title: results.tracks[i].title,
                  subtitle: artistNames[results.tracks[i].artistId],
                  artworkPath: albumArtwork[results.tracks[i].albumId],
                  trailing: Text(
                    formatDuration(results.tracks[i].duration),
                    style: AppTypography.meta.copyWith(
                      color: context.colors.textTertiary,
                    ),
                  ),
                  onTap: () => unawaited(
                    ref
                        .read(queueViewModelProvider.notifier)
                        .playFromSource(results.tracks, startIndex: i),
                  ),
                ),
            ],
          ),
        if (results.albums.isNotEmpty)
          _ResultSection(
            title: l10n.libraryAlbumsTab,
            children: [
              for (final album in results.albums)
                MediaRow(
                  seed: album.id,
                  title: album.title,
                  artworkPath: album.artworkPath,
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: context.colors.textTertiary,
                  ),
                  onTap: () =>
                      LibraryNavigator.openAlbum(context, albumId: album.id),
                ),
            ],
          ),
        if (results.artists.isNotEmpty)
          _ResultSection(
            title: l10n.libraryArtistsTab,
            children: [
              for (final artist in results.artists)
                MediaRow(
                  seed: artist.id,
                  title: artist.name,
                  circle: true,
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: context.colors.textTertiary,
                  ),
                  onTap: () => LibraryNavigator.openArtist(
                    context,
                    artistId: artist.id,
                  ),
                ),
            ],
          ),
        if (results.playlists.isNotEmpty)
          _ResultSection(
            title: l10n.libraryPlaylistsTab,
            children: [
              for (final playlist in results.playlists)
                MediaRow(
                  seed: playlist.id,
                  title: playlist.name,
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: context.colors.textTertiary,
                  ),
                  onTap: () => PlaylistNavigator.openPlaylist(
                    context,
                    playlistId: playlist.id,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _ResultSection extends StatelessWidget {
  const _ResultSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.smMd,
            AppSpacing.sm,
            AppSpacing.smMd,
            AppSpacing.xs,
          ),
          child: Text(
            title,
            style: AppTypography.section.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
