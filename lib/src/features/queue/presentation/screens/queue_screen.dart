import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';
import 'package:music_app/src/features/queue/presentation/widgets/queue_screen/queue_row.dart';

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
    // Selects only currentIndex, so neither the frequent position ticks
    // during playback nor a play/pause toggle rebuilds every row in the
    // list.
    final currentIndex = ref.watch(
      playbackViewModelProvider.select((state) => state.value?.currentIndex),
    );

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
                          itemBuilder: (context, index) => QueueRow(
                            key: ValueKey(
                              '${queue[index].id}-$index',
                            ),
                            item: queue[index],
                            index: index,
                            current: index == currentIndex,
                            editing: true,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.smMd,
                            vertical: AppSpacing.sm,
                          ),
                          itemCount: queue.length,
                          itemBuilder: (context, index) => QueueRow(
                            key: ValueKey(
                              '${queue[index].id}-$index',
                            ),
                            item: queue[index],
                            index: index,
                            current: index == currentIndex,
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
