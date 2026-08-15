import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/library/presentation/widgets/media_card.dart';
import 'package:music_app/src/features/playlist/presentation/providers/playlist_providers.dart';

/// Up to 10 playlists and 10 albums, each as its own horizontal row of
/// cards. Either row is hidden entirely when there's nothing to show.
class HomePlaylistsAndAlbums extends ConsumerWidget {
  /// Creates a [HomePlaylistsAndAlbums].
  const HomePlaylistsAndAlbums({super.key});

  static const _maxCards = 10;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final playlists = ref.watch(playlistsProvider).value ?? const [];
    final albums = ref.watch(sortedAlbumsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (playlists.isNotEmpty)
          _CardRow(
            title: l10n.libraryPlaylistsTab,
            itemCount: playlists.length.clamp(0, _maxCards),
            itemBuilder: (context, index) => MediaCard(
              seed: playlists[index].id,
              title: playlists[index].name,
              onTap: () =>
                  context.push(RoutePaths.playlist(playlists[index].id)),
            ),
          ),
        if (albums.isNotEmpty)
          _CardRow(
            title: l10n.libraryAlbumsTab,
            itemCount: albums.length.clamp(0, _maxCards),
            itemBuilder: (context, index) => MediaCard(
              seed: albums[index].id,
              title: albums[index].title,
              artworkPath: albums[index].artworkPath,
              onTap: () => context.push(RoutePaths.album(albums[index].id)),
            ),
          ),
      ],
    );
  }
}

class _CardRow extends StatelessWidget {
  const _CardRow({
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
  });

  final String title;
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
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
            title,
            style: AppTypography.section.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 184,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: itemCount,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.smMd),
            itemBuilder: itemBuilder,
          ),
        ),
      ],
    );
  }
}
