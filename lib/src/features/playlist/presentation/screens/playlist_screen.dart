import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_screen_view_model.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/playlist/presentation/providers/playlist_providers.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_cover_art.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

/// A playlist's details: composed cover, play/shuffle, its tracks
/// (reorder by drag, remove with confirmation), and an empty state.
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final playlist = ref.watch(playlistByIdProvider(widget.playlistId)).value;
    final tracks = ref.watch(playlistTracksProvider(widget.playlistId));
    final albumArtwork = ref.watch(albumArtworkProvider);
    final currentTrackId = ref.watch(playbackScreenViewModelProvider)?.id;
    final playing =
        ref.watch(
          playbackViewModelProvider.select((state) => state.value?.playing),
        ) ??
        false;

    if (tracks.isEmpty && _editing) _editing = false;

    final header = _PlaylistHeader(
      playlistId: widget.playlistId,
      playlistName: playlist?.name,
      tracks: tracks,
      albumArtwork: albumArtwork,
      onPlay: tracks.isEmpty
          ? null
          : () => unawaited(
              ref
                  .read(queueViewModelProvider.notifier)
                  .playFromSource(tracks, startIndex: 0),
            ),
      onShuffle: tracks.isEmpty ? null : () => unawaited(_playShuffled(tracks)),
    );

    return AppScaffold(
      topBar: AppTopBar(
        title: playlist?.name,
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
        trailing: tracks.isEmpty
            ? null
            : AppTextButton(
                label: _editing ? l10n.queueDoneLabel : l10n.queueEditLabel,
                onPressed: () => setState(() => _editing = !_editing),
              ),
      ),
      body: tracks.isEmpty
          ? ListView(
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
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.smMd,
              ),
              header: header,
              buildDefaultDragHandles: false,
              itemCount: tracks.length,
              onReorderItem: (oldIndex, newIndex) =>
                  unawaited(_reorder(tracks, oldIndex, newIndex)),
              itemBuilder: (context, index) => _PlaylistTrackRow(
                key: ValueKey('${tracks[index].id}-$index'),
                track: tracks[index],
                index: index,
                editing: true,
                current: tracks[index].id == currentTrackId,
                playing: playing,
                onTap: () {},
                onRemove: () =>
                    unawaited(_confirmRemove(context, tracks, index)),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.smMd,
              ),
              itemCount: tracks.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return header;
                final trackIndex = index - 1;
                return _PlaylistTrackRow(
                  key: ValueKey('${tracks[trackIndex].id}-$trackIndex'),
                  track: tracks[trackIndex],
                  index: trackIndex,
                  editing: false,
                  current: tracks[trackIndex].id == currentTrackId,
                  playing: playing,
                  onTap: () => unawaited(
                    ref
                        .read(queueViewModelProvider.notifier)
                        .playFromSource(tracks, startIndex: trackIndex),
                  ),
                  onRemove: () {},
                );
              },
            ),
    );
  }

  Future<void> _playShuffled(List<Track> tracks) async {
    final shuffled = [...tracks]..shuffle();
    await ref
        .read(queueViewModelProvider.notifier)
        .playFromSource(shuffled, startIndex: 0);
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
    required this.tracks,
    required this.albumArtwork,
    required this.onPlay,
    required this.onShuffle,
  });

  final String playlistId;
  final String? playlistName;
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
        children: [
          PlaylistCoverArt(
            playlistId: playlistId,
            tracks: coverTracks,
            size: 160,
          ),
          const SizedBox(height: AppSpacing.md),
          if (playlistName != null)
            Text(
              playlistName!,
              textAlign: TextAlign.center,
              style: AppTypography.header.copyWith(color: colors.textPrimary),
            ),
          const SizedBox(height: 4),
          Text(
            '${l10n.trackCountLabel(tracks.length)} · '
            '${formatDuration(totalDuration)}',
            style: AppTypography.caption.copyWith(color: colors.textTertiary),
          ),
          if (tracks.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
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
          ],
        ],
      ),
    );
  }
}

class _PlaylistTrackRow extends StatelessWidget {
  const _PlaylistTrackRow({
    required this.track,
    required this.index,
    required this.editing,
    required this.current,
    required this.playing,
    required this.onTap,
    required this.onRemove,
    super.key,
  });

  final Track track;
  final int index;
  final bool editing;
  final bool current;
  final bool playing;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

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
            else if (current)
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
