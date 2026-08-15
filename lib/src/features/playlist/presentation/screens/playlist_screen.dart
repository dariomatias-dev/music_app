import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/playlist/presentation/providers/playlist_providers.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

/// A playlist's tracks: reorder by drag, remove with confirmation, and see
/// the total duration.
///
/// Fully built (cover, play/shuffle) in Etapa 75.
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

    if (tracks.isEmpty && _editing) _editing = false;
    final totalDuration = tracks.fold(
      Duration.zero,
      (total, track) => total + track.duration,
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
          ? AppEmptyState(
              icon: Icons.queue_music_rounded,
              title: l10n.playlistEmptyTitle,
              message: l10n.playlistEmptyMessage,
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.xs,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${l10n.trackCountLabel(tracks.length)} · '
                      '${formatDuration(totalDuration)}',
                      style: AppTypography.caption.copyWith(
                        color: context.colors.textTertiary,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _editing
                      ? ReorderableListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.smMd,
                          ),
                          buildDefaultDragHandles: false,
                          itemCount: tracks.length,
                          onReorderItem: (oldIndex, newIndex) => unawaited(
                            _reorder(tracks, oldIndex, newIndex),
                          ),
                          itemBuilder: (context, index) => _PlaylistTrackRow(
                            key: ValueKey('${tracks[index].id}-$index'),
                            track: tracks[index],
                            index: index,
                            editing: true,
                            onTap: () {},
                            onRemove: () => unawaited(
                              _confirmRemove(context, tracks, index),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.smMd,
                          ),
                          itemCount: tracks.length,
                          itemBuilder: (context, index) => _PlaylistTrackRow(
                            key: ValueKey('${tracks[index].id}-$index'),
                            track: tracks[index],
                            index: index,
                            editing: false,
                            onTap: () => unawaited(
                              ref
                                  .read(queueViewModelProvider.notifier)
                                  .playFromSource(tracks, startIndex: index),
                            ),
                            onRemove: () {},
                          ),
                        ),
                ),
              ],
            ),
    );
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

class _PlaylistTrackRow extends StatelessWidget {
  const _PlaylistTrackRow({
    required this.track,
    required this.index,
    required this.editing,
    required this.onTap,
    required this.onRemove,
    super.key,
  });

  final Track track;
  final int index;
  final bool editing;
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
                  color: colors.textPrimary,
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
