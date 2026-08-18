import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_screen_view_model.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/player/presentation/widgets/mini_player.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/playlist/presentation/providers/playlist_providers.dart';
import 'package:music_app/src/features/playlist/presentation/view_models/playlist_track_sort_view_model.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_cover_art.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_more_sheet.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_track_more_sheet.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_track_sort_sheet.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

/// A playlist's details: composed cover, description, favorite, search,
/// sort, play/shuffle, its tracks (reorder by drag, remove with
/// confirmation), and an empty state.
class PlaylistScreen extends ConsumerStatefulWidget {
  /// Creates a [PlaylistScreen].
  const PlaylistScreen({required this.playlistId, super.key});

  /// The playlist to show.
  final String playlistId;

  @override
  ConsumerState<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends ConsumerState<PlaylistScreen> {
  var _editing = false;
  var _searching = false;
  final _searchController = TextEditingController();
  var _searchTerm = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _searching = !_searching;
      _editing = false;
      if (!_searching) {
        _searchController.clear();
        _searchTerm = '';
      }
    });
  }

  List<Track> _sorted(
    List<Track> tracks,
    PlaylistTrackSort sort,
    Map<String, String?> artistNames,
  ) {
    switch (sort) {
      case PlaylistTrackSort.custom:
        return tracks;
      case PlaylistTrackSort.title:
        return [...tracks]..sort((a, b) => a.title.compareTo(b.title));
      case PlaylistTrackSort.artist:
        return [...tracks]..sort(
          (a, b) => (artistNames[a.artistId] ?? '').compareTo(
            artistNames[b.artistId] ?? '',
          ),
        );
      case PlaylistTrackSort.duration:
        return [...tracks]..sort((a, b) => b.duration.compareTo(a.duration));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final playlist = ref.watch(playlistByIdProvider(widget.playlistId)).value;
    final rawTracks = ref.watch(playlistTracksProvider(widget.playlistId));
    final albumArtwork = ref.watch(albumArtworkProvider);
    final artistNames = ref.watch(artistNamesProvider);
    final sort = ref.watch(playlistTrackSortViewModelProvider);
    final currentTrackId = ref.watch(playbackScreenViewModelProvider)?.id;
    final playing =
        ref.watch(
          playbackViewModelProvider.select((state) => state.value?.playing),
        ) ??
        false;

    if (rawTracks.isEmpty && _editing) _editing = false;

    final tracks = _sorted(rawTracks, sort, artistNames);
    final term = _searchTerm.trim().toLowerCase();
    final visibleTracks = term.isEmpty
        ? tracks
        : tracks
              .where(
                (track) =>
                    track.title.toLowerCase().contains(term) ||
                    (artistNames[track.artistId]?.toLowerCase().contains(
                          term,
                        ) ??
                        false),
              )
              .toList();

    Future<void> playFrom(List<Track> source, int startIndex) async {
      await ref
          .read(queueViewModelProvider.notifier)
          .playFromSource(source, startIndex: startIndex);
      if (!context.mounted) return;
      await context.push(RoutePaths.player);
    }

    final header = _PlaylistHeader(
      playlistId: widget.playlistId,
      playlistName: playlist?.name,
      description: playlist?.description,
      tracks: tracks,
      albumArtwork: albumArtwork,
      onPlay: tracks.isEmpty ? null : () => unawaited(playFrom(tracks, 0)),
      onShuffle: tracks.isEmpty ? null : () => unawaited(_playShuffled(tracks)),
    );

    final sortRow = tracks.isEmpty
        ? null
        : _SortRow(trackCount: tracks.length, sort: sort);

    return MiniPlayerDock(
      child: AppScaffold(
        topBar: AppTopBar(
          backButtonSemanticLabel: l10n.backButtonSemanticLabel,
          title: playlist?.name,
          trailing: _editing
              ? AppTextButton(
                  label: l10n.queueDoneLabel,
                  onPressed: () => setState(() => _editing = false),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIconButton(
                      icon: Icons.search,
                      semanticLabel: l10n.searchTracksSemanticLabel,
                      onPressed: _toggleSearch,
                    ),
                    if (playlist != null)
                      AppIconButton(
                        icon: playlist.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: playlist.isFavorite
                            ? context.colors.textPrimary
                            : null,
                        semanticLabel: playlist.isFavorite
                            ? l10n.unfavoriteButtonSemanticLabel
                            : l10n.favoriteButtonSemanticLabel,
                        onPressed: () => unawaited(
                          ref
                              .read(playlistRepositoryProvider)
                              .setPlaylistFavorite(
                                playlist.id,
                                isFavorite: !playlist.isFavorite,
                              ),
                        ),
                      ),
                    if (playlist != null)
                      AppIconButton(
                        icon: Icons.more_horiz,
                        semanticLabel: l10n.playlistOptionsSemanticLabel,
                        onPressed: () => unawaited(
                          showPlaylistMoreSheet(
                            context,
                            ref,
                            playlist,
                            onReorderTracks:
                                tracks.isEmpty ||
                                    sort != PlaylistTrackSort.custom
                                ? null
                                : () => setState(() => _editing = true),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
        body: Column(
          children: [
            if (_searching)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: AppSearchField(
                  controller: _searchController,
                  hintText: l10n.searchTracksSemanticLabel,
                  clearButtonSemanticLabel: l10n.clearSearchSemanticLabel,
                  onChanged: (value) => setState(() => _searchTerm = value),
                  onClear: () => setState(() {
                    _searchController.clear();
                    _searchTerm = '';
                  }),
                ),
              ),
            Expanded(
              child: rawTracks.isEmpty
                  ? ListView(
                      padding: EdgeInsets.only(
                        bottom: MiniPlayerDock.insetOf(context),
                      ),
                      children: [
                        header,
                        AppEmptyState(
                          icon: Icons.queue_music_rounded,
                          title: l10n.playlistEmptyTitle,
                          message: l10n.playlistEmptyMessage,
                        ),
                      ],
                    )
                  : _editing
                  ? ReorderableListView.builder(
                      padding: EdgeInsets.only(
                        left: AppSpacing.smMd,
                        right: AppSpacing.smMd,
                        bottom: MiniPlayerDock.insetOf(context),
                      ),
                      header: header,
                      buildDefaultDragHandles: false,
                      itemCount: visibleTracks.length,
                      onReorderItem: (oldIndex, newIndex) =>
                          unawaited(_reorder(tracks, oldIndex, newIndex)),
                      itemBuilder: (context, index) => _PlaylistTrackRow(
                        key: ValueKey('${visibleTracks[index].id}-$index'),
                        track: visibleTracks[index],
                        index: index,
                        editing: true,
                        current: visibleTracks[index].id == currentTrackId,
                        playing: playing,
                        onTap: () {},
                        onRemove: () => unawaited(
                          _confirmRemove(context, tracks, index),
                        ),
                        onMore: () {},
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(
                        left: AppSpacing.smMd,
                        right: AppSpacing.smMd,
                        bottom: MiniPlayerDock.insetOf(context),
                      ),
                      itemCount:
                          visibleTracks.length + 1 + (sortRow == null ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index == 0) return header;
                        if (sortRow != null && index == 1) return sortRow;
                        final trackIndex =
                            index - 1 - (sortRow == null ? 0 : 1);
                        final track = visibleTracks[trackIndex];
                        return _PlaylistTrackRow(
                          key: ValueKey('${track.id}-$trackIndex'),
                          track: track,
                          index: tracks.indexOf(track),
                          editing: false,
                          current: track.id == currentTrackId,
                          playing: playing,
                          onTap: () => unawaited(
                            playFrom(tracks, tracks.indexOf(track)),
                          ),
                          onRemove: () {},
                          onMore: () => unawaited(
                            showPlaylistTrackMoreSheet(
                              context,
                              ref,
                              playlistId: widget.playlistId,
                              track: track,
                              artistName: artistNames[track.artistId],
                              playlistTracks: rawTracks,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _playShuffled(List<Track> tracks) async {
    final shuffled = [...tracks]..shuffle();
    await ref
        .read(queueViewModelProvider.notifier)
        .playFromSource(shuffled, startIndex: 0);
    if (!mounted) return;
    await GoRouter.of(context).push(RoutePaths.player);
  }

  Future<void> _reorder(
    List<Track> tracks,
    int oldIndex,
    int newIndex,
  ) async {
    final ids = tracks.map((track) => track.id).toList()
      ..removeAt(oldIndex)
      ..insert(newIndex, tracks[oldIndex].id);
    await ref
        .read(playlistRepositoryProvider)
        .setPlaylistTracks(widget.playlistId, ids);
  }

  Future<void> _confirmRemove(
    BuildContext context,
    List<Track> tracks,
    int index,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppDestructiveDialog.show(
      context,
      title: l10n.removeTrackConfirmTitle,
      message: l10n.removeTrackConfirmMessage,
      confirmLabel: l10n.deletePlaylistLabel,
      cancelLabel: l10n.cancelLabel,
    );
    if (!confirmed) return;
    final ids = tracks.map((track) => track.id).toList()..removeAt(index);
    await ref
        .read(playlistRepositoryProvider)
        .setPlaylistTracks(widget.playlistId, ids);
  }
}

class _PlaylistHeader extends StatelessWidget {
  const _PlaylistHeader({
    required this.playlistId,
    required this.playlistName,
    required this.description,
    required this.tracks,
    required this.albumArtwork,
    required this.onPlay,
    required this.onShuffle,
  });

  final String playlistId;
  final String? playlistName;
  final String? description;
  final List<Track> tracks;
  final Map<String, String?> albumArtwork;
  final VoidCallback? onPlay;
  final VoidCallback? onShuffle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final totalDuration = tracks.fold(
      Duration.zero,
      (total, track) => total + track.duration,
    );
    final coverTracks = tracks
        .take(4)
        .map<PlaylistCoverTrack>(
          (track) => (seed: track.id, artworkPath: albumArtwork[track.albumId]),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlaylistCoverArt(
                playlistId: playlistId,
                tracks: coverTracks,
                size: 140,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (playlistName != null)
                      Text(
                        playlistName!,
                        style: AppTypography.header.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.trackCountLabel(tracks.length)} · '
                      '${formatDuration(totalDuration)}',
                      style: AppTypography.caption.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                    if (description != null && description!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.rowSubtitle.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (tracks.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lgXl),
            Row(
              children: [
                Expanded(
                  child: AppPrimaryButton(
                    label: l10n.playLabel,
                    icon: Icons.play_arrow_rounded,
                    onPressed: onPlay,
                  ),
                ),
                const SizedBox(width: AppSpacing.smMd),
                Expanded(
                  child: AppSecondaryButton(
                    label: l10n.shuffleButtonSemanticLabel,
                    icon: Icons.shuffle_rounded,
                    onPressed: onShuffle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lgXl),
          ],
        ],
      ),
    );
  }
}

class _SortRow extends ConsumerWidget {
  const _SortRow({required this.trackCount, required this.sort});

  final int trackCount;
  final PlaylistTrackSort sort;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.smMd,
        AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.trackCountLabel(trackCount),
            style: AppTypography.caption.copyWith(color: colors.textTertiary),
          ),
          Pressable(
            scale: 0.97,
            onTap: () => unawaited(showPlaylistTrackSortSheet(context, ref)),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xxs,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.swap_vert_rounded,
                    size: 17,
                    color: colors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(
                    playlistTrackSortLabel(l10n, sort),
                    style: AppTypography.meta.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaylistTrackRow extends ConsumerWidget {
  const _PlaylistTrackRow({
    required this.track,
    required this.index,
    required this.editing,
    required this.current,
    required this.playing,
    required this.onTap,
    required this.onRemove,
    required this.onMore,
    super.key,
  });

  final Track track;
  final int index;
  final bool editing;
  final bool current;
  final bool playing;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final artistName = ref.watch(artistNamesProvider)[track.artistId];

    return Pressable(
      scale: 0.99,
      onTap: editing ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.smMd,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            if (editing)
              AppIconButton(
                icon: Icons.remove_circle_outline,
                semanticLabel: l10n.removeFromPlaylistSemanticLabel,
                onPressed: onRemove,
              )
            else
              SizedBox(
                width: 22,
                child: Text(
                  '${index + 1}',
                  style: AppTypography.caption.copyWith(
                    color: colors.textTertiary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            const SizedBox(width: AppSpacing.smMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.rowTitle.copyWith(
                      color: current ? colors.accent : colors.textPrimary,
                    ),
                  ),
                  if (artistName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      artistName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.rowSubtitle.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            if (editing)
              ReorderableDragStartListener(
                index: index,
                child: Semantics(
                  label: l10n.dragToReorderSemanticLabel,
                  child: Icon(
                    Icons.drag_handle_rounded,
                    color: colors.textTertiary,
                  ),
                ),
              )
            else ...[
              if (current)
                AppPlaybackIndicator(playing: playing, color: colors.accent)
              else
                Text(
                  formatDuration(track.duration),
                  style: AppTypography.meta.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              AppIconButton(
                icon: Icons.more_vert,
                semanticLabel: l10n.playlistOptionsSemanticLabel,
                size: 36,
                iconSize: AppSizes.iconSmall,
                onPressed: onMore,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
