import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/utils/file_size_formatter.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/player/presentation/widgets/mini_player.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';
import 'package:music_app/src/features/storage/data/providers/storage_data_providers.dart';
import 'package:music_app/src/features/storage/domain/entities/folder_usage.dart';
import 'package:music_app/src/features/storage/presentation/providers/storage_providers.dart';
import 'package:path/path.dart' as p;

/// The storage screen: total space used, indexed folders (include/exclude
/// from the scan, with their files listed), and artwork cache clearing.
class StorageScreen extends ConsumerStatefulWidget {
  /// Creates a [StorageScreen].
  const StorageScreen({super.key});

  @override
  ConsumerState<StorageScreen> createState() => _StorageScreenState();
}

/// One row in the storage list: everything but a folder's tracks is fixed;
/// a folder contributes one header row, then one row per track only while
/// it's expanded.
sealed class _Row {}

class _SummaryRow extends _Row {}

class _FoldersLabelRow extends _Row {}

class _FolderHeaderRow extends _Row {
  _FolderHeaderRow(this.folder);
  final FolderUsage folder;
}

class _TrackRow extends _Row {
  _TrackRow(this.folder, this.track);
  final FolderUsage folder;
  final Track track;
}

class _ClearCacheRow extends _Row {}

class _StorageScreenState extends ConsumerState<StorageScreen> {
  var _busy = false;
  final _expandedFolders = <String>{};

  void _toggleExpanded(String path) {
    setState(() {
      if (!_expandedFolders.remove(path)) _expandedFolders.add(path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalUsed = ref.watch(totalStorageUsageProvider);
    final folders = ref.watch(folderUsageProvider);
    final folderTracks = ref.watch(folderTracksProvider);

    // A lightweight index of rows, not widgets: ListView.builder only
    // calls itemBuilder for rows actually on screen, so a folder with
    // thousands of tracks costs nothing until it's expanded and scrolled
    // into view, rather than laying every track out immediately like
    // ExpansionTile's own (eagerly built) children used to.
    final rows = <_Row>[_SummaryRow(), _FoldersLabelRow()];
    for (final folder in folders) {
      rows.add(_FolderHeaderRow(folder));
      if (_expandedFolders.contains(folder.path)) {
        final tracks = folderTracks[folder.path] ?? const <Track>[];
        for (final track in tracks) {
          rows.add(_TrackRow(folder, track));
        }
      }
    }
    rows.add(_ClearCacheRow());

    return MiniPlayerDock(
      child: AppScaffold(
        topBar: AppTopBar(
          title: l10n.storageLabel,
          backButtonSemanticLabel: l10n.backButtonSemanticLabel,
        ),
        body: Column(
          children: [
            if (_busy)
              LinearProgressIndicator(
                color: context.colors.accent,
                backgroundColor: context.colors.divider,
              ),
            Expanded(
              child: folders.isEmpty
                  ? AppEmptyState(
                      icon: Icons.folder_off_outlined,
                      title: l10n.storageEmptyTitle,
                      message: l10n.storageEmptyMessage,
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(
                        top: AppSpacing.sm,
                        bottom: MiniPlayerDock.insetOf(context),
                      ),
                      itemCount: rows.length,
                      itemBuilder: (context, index) => switch (rows[index]) {
                        _SummaryRow() => _SummaryTile(totalUsed: totalUsed),
                        _FoldersLabelRow() => _FoldersLabel(
                          label: l10n.storageFoldersLabel,
                        ),
                        _FolderHeaderRow(:final folder) => _FolderHeader(
                          folder: folder,
                          expanded: _expandedFolders.contains(folder.path),
                          enabled: !_busy,
                          onExpandToggle: () => _toggleExpanded(folder.path),
                          onToggleIncluded: (included) => unawaited(
                            _toggleFolder(folder.path, included),
                          ),
                        ),
                        _TrackRow(:final track) => _TrackTile(
                          track: track,
                          enabled: !_busy,
                          onDelete: () => unawaited(_confirmDeleteTrack(track)),
                        ),
                        _ClearCacheRow() => Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: AppTextButton(
                            label: l10n.clearArtworkCacheLabel,
                            onPressed: _busy
                                ? null
                                : () => unawaited(_confirmClearArtworkCache()),
                          ),
                        ),
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleFolder(String path, bool included) async {
    setState(() => _busy = true);
    final repository = ref.read(excludedFolderRepositoryProvider);
    if (included) {
      await repository.include(path);
    } else {
      await repository.exclude(path);
    }
    try {
      await ref.read(libraryRepositoryProvider).reindex().drain<void>();
      // The scan touches device files and metadata parsing outside our
      // control; any failure here should reset the busy state and tell the
      // user, not leave the screen spinning forever.
    } on Object catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() => _busy = false);
      AppToast.show(
        context,
        message: l10n.scanErrorMessage,
        variant: AppToastVariant.error,
      );
      return;
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _confirmClearArtworkCache() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppDestructiveDialog.show(
      context,
      title: l10n.clearArtworkCacheConfirmTitle,
      message: l10n.clearArtworkCacheConfirmMessage,
      confirmLabel: l10n.clearArtworkCacheConfirmAction,
      cancelLabel: l10n.cancelLabel,
    );
    if (!confirmed) return;
    await ref.read(libraryRepositoryProvider).clearArtworkCache();
    if (!mounted) return;
    AppToast.show(context, message: l10n.artworkCacheClearedMessage);
  }

  Future<void> _confirmDeleteTrack(Track track) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppDestructiveDialog.show(
      context,
      title: l10n.deleteFileConfirmTitle,
      message: l10n.deleteFileConfirmMessage,
      confirmLabel: l10n.deleteFileConfirmAction,
      cancelLabel: l10n.cancelLabel,
    );
    if (!confirmed) return;

    setState(() => _busy = true);
    try {
      await ref.read(deleteTrackFileProvider)(track);
      await ref
          .read(queueViewModelProvider.notifier)
          .removeTrackFromQueue(track.id);
      if (!mounted) return;
      AppToast.show(context, message: l10n.fileDeletedMessage);
    } on Exception {
      if (!mounted) return;
      AppToast.show(
        context,
        message: l10n.fileDeleteFailedMessage,
        variant: AppToastVariant.error,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.totalUsed});

  final int totalUsed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(
            Icons.sd_storage_outlined,
            size: 20,
            color: colors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            l10n.storageTotalUsedLabel,
            style: AppTypography.rowTitle.copyWith(color: colors.textPrimary),
          ),
          const Spacer(),
          Text(
            formatFileSize(totalUsed),
            style: AppTypography.rowTitle.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _FoldersLabel extends StatelessWidget {
  const _FoldersLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Text(
        label,
        style: AppTypography.section.copyWith(
          color: context.colors.textPrimary,
        ),
      ),
    );
  }
}

class _FolderHeader extends StatelessWidget {
  const _FolderHeader({
    required this.folder,
    required this.expanded,
    required this.enabled,
    required this.onExpandToggle,
    required this.onToggleIncluded,
  });

  final FolderUsage folder;
  final bool expanded;
  final bool enabled;
  final VoidCallback onExpandToggle;
  final ValueChanged<bool> onToggleIncluded;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Pressable(
      onTap: folder.trackCount == 0 ? null : onExpandToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            AnimatedRotation(
              turns: expanded ? 0.25 : 0,
              duration: AppDurations.resolve(context, AppDurations.fast),
              child: Icon(
                Icons.chevron_right_rounded,
                color: folder.trackCount == 0
                    ? colors.textTertiary.withValues(alpha: 0.4)
                    : colors.textTertiary,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    p.basename(folder.path),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.rowTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    '${l10n.trackCountLabel(folder.trackCount)} · '
                    '${formatFileSize(folder.sizeBytes)}',
                    style: AppTypography.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppSwitch(
              value: folder.isIncluded,
              onChanged: enabled ? onToggleIncluded : null,
              semanticLabel: l10n.includeInScanSemanticLabel,
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackTile extends StatelessWidget {
  const _TrackTile({
    required this.track,
    required this.enabled,
    required this.onDelete,
  });

  final Track track;
  final bool enabled;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xxs,
        AppSpacing.smMd,
        AppSpacing.xxs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              track.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.rowSubtitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            formatFileSize(track.fileSize),
            style: AppTypography.meta.copyWith(color: colors.textTertiary),
          ),
          AppIconButton(
            icon: Icons.delete_outline_rounded,
            semanticLabel: l10n.deleteFileSemanticLabel,
            size: 36,
            iconSize: AppSizes.iconSmall,
            onPressed: enabled ? onDelete : null,
          ),
        ],
      ),
    );
  }
}
