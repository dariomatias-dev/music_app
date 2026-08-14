import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/player/presentation/widgets/track_artwork.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';

/// Shows every track currently loaded into the playback queue, highlighting
/// the one playing now. Tapping a row jumps playback to that track.
///
/// An edit mode lets tracks be reordered by drag, removed one at a time, or
/// the whole queue cleared.
class QueueScreen extends ConsumerStatefulWidget {
  /// Creates a [QueueScreen].
  const QueueScreen({super.key});

  @override
  ConsumerState<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends ConsumerState<QueueScreen> {
  var _editing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final queue = ref.watch(queueViewModelProvider);
    final playback = ref.watch(playbackViewModelProvider).value;
    final currentIndex = playback?.currentIndex;

    if (queue.isEmpty && _editing) _editing = false;

    return AppScaffold(
      topBar: AppTopBar(
        title: l10n.viewQueueLabel,
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
        trailing: queue.isEmpty
            ? null
            : AppTextButton(
                label: _editing ? l10n.queueDoneLabel : l10n.queueEditLabel,
                onPressed: () => setState(() => _editing = !_editing),
              ),
      ),
      body: queue.isEmpty
          ? AppEmptyState(
              icon: Icons.queue_music_rounded,
              title: l10n.queueEmptyTitle,
              message: l10n.queueEmptyMessage,
            )
          : Column(
              children: [
                Expanded(
                  child: _editing
                      ? ReorderableListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.smMd,
                            vertical: AppSpacing.sm,
                          ),
                          buildDefaultDragHandles: false,
                          itemCount: queue.length,
                          onReorderItem: (oldIndex, newIndex) => unawaited(
                            ref
                                .read(queueViewModelProvider.notifier)
                                .reorder(oldIndex, newIndex),
                          ),
                          itemBuilder: (context, index) => _QueueRow(
                            key: ValueKey(
                              '${queue[index].id}-$index',
                            ),
                            item: queue[index],
                            index: index,
                            current: index == currentIndex,
                            playing: playback?.playing ?? false,
                            editing: true,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.smMd,
                            vertical: AppSpacing.sm,
                          ),
                          itemCount: queue.length,
                          itemBuilder: (context, index) => _QueueRow(
                            key: ValueKey(
                              '${queue[index].id}-$index',
                            ),
                            item: queue[index],
                            index: index,
                            current: index == currentIndex,
                            playing: playback?.playing ?? false,
                            editing: false,
                          ),
                        ),
                ),
                if (_editing)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: AppTextButton(
                      label: l10n.clearQueueLabel,
                      color: context.colors.error,
                      onPressed: () => unawaited(_confirmClear(context)),
                    ),
                  ),
              ],
            ),
    );
  }

  Future<void> _confirmClear(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppDestructiveDialog.show(
      context,
      title: l10n.clearQueueConfirmTitle,
      message: l10n.clearQueueConfirmMessage,
      confirmLabel: l10n.clearQueueConfirmAction,
      cancelLabel: l10n.cancelLabel,
    );
    if (!confirmed) return;
    setState(() => _editing = false);
    await ref.read(queueViewModelProvider.notifier).clear();
  }
}

class _QueueRow extends ConsumerWidget {
  const _QueueRow({
    required this.item,
    required this.index,
    required this.current,
    required this.playing,
    required this.editing,
    super.key,
  });

  final QueueMediaItem item;
  final int index;
  final bool current;
  final bool playing;
  final bool editing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final titleColor = current ? colors.accent : colors.textPrimary;

    return Semantics(
      label: current ? l10n.nowPlayingSemanticLabel : null,
      child: Pressable(
        scale: 0.99,
        onTap: editing
            ? null
            : () => unawaited(
                ref
                    .read(audioPlayerServiceProvider)
                    .seek(Duration.zero, index: index),
              ),
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
                  semanticLabel: l10n.removeFromQueueSemanticLabel,
                  onPressed: () => unawaited(
                    ref.read(queueViewModelProvider.notifier).removeAt(index),
                  ),
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
              const SizedBox(width: AppSpacing.sm),
              TrackArtwork(item: item, size: 44, radius: AppRadius.small),
              const SizedBox(width: AppSpacing.smMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.rowTitle.copyWith(color: titleColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.artist ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.rowSubtitle.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
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
              else if (current)
                AppPlaybackIndicator(playing: playing, color: colors.accent)
              else if (item.duration != null)
                Text(
                  formatDuration(item.duration!),
                  style: AppTypography.meta.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
