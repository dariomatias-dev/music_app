import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/navigators/player_navigator.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_screen_view_model.dart';
import 'package:music_app/src/features/player/presentation/widgets/mini_player.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/playlist/presentation/providers/playlist_providers.dart';
import 'package:music_app/src/features/playlist/presentation/view_models/playlist_track_sort_view_model.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_more_sheet.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_screen/playlist_header.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_screen/playlist_sort_row.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_screen/playlist_track_row.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_track_more_sheet.dart';
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
      await PlayerNavigator.openPlayer(context);
    }

    final header = PlaylistHeader(
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
        : PlaylistSortRow(trackCount: tracks.length, sort: sort);

    // Built once per build rather than calling `indexOf` per row: the list
    // renders a row's position and plays from it, and both lookups inside
    // `itemBuilder` would each scan the list, making a long playlist
    // quadratic to scroll.
    final positionsById = {
      for (var i = 0; i < tracks.length; i++) tracks[i].id: i,
    };

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
                      itemBuilder: (context, index) => PlaylistTrackRow(
                        key: ValueKey('${visibleTracks[index].id}-$index'),
                        track: visibleTracks[index],
                        index: index,
                        editing: true,
                        current: visibleTracks[index].id == currentTrackId,
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
                        final position = positionsById[track.id] ?? 0;
                        return PlaylistTrackRow(
                          key: ValueKey('${track.id}-$trackIndex'),
                          track: track,
                          index: position,
                          editing: false,
                          current: track.id == currentTrackId,
                          onTap: () => unawaited(playFrom(tracks, position)),
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
    await PlayerNavigator.openPlayer(context);
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
