import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/utils/file_size_formatter.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
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

class _StorageScreenState extends ConsumerState<StorageScreen> {
  var _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalUsed = ref.watch(totalStorageUsageProvider);
    final folders = ref.watch(folderUsageProvider);
    final folderTracks = ref.watch(folderTracksProvider);

    return AppScaffold(
      topBar: AppTopBar(
        title: l10n.storageLabel,
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
      ),
      body: Column(
        children: [
          if (_busy) const LinearProgressIndicator(),
          Expanded(
            child: folders.isEmpty
                ? AppEmptyState(
                    icon: Icons.folder_off_outlined,
                    title: l10n.tracksEmptyTitle,
                    message: l10n.tracksEmptyMessage,
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.sd_storage_outlined,
                              size: 20,
                              color: context.colors.textSecondary,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              l10n.storageTotalUsedLabel,
                              style: AppTypography.rowTitle.copyWith(
                                color: context.colors.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              formatFileSize(totalUsed),
                              style: AppTypography.rowTitle.copyWith(
                                color: context.colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.md,
                          AppSpacing.lg,
                          AppSpacing.xs,
                        ),
                        child: Text(
                          l10n.storageFoldersLabel,
                          style: AppTypography.section.copyWith(
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                      for (final folder in folders)
                        _FolderTile(
                          folder: folder,
                          tracks: folderTracks[folder.path] ?? const [],
                          enabled: !_busy,
                          onToggle: (included) => unawaited(
                            _toggleFolder(folder.path, included),
                          ),
                          onDeleteTrack: (track) =>
                              unawaited(_confirmDeleteTrack(track)),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: AppTextButton(
                          label: l10n.clearArtworkCacheLabel,
                          onPressed: _busy
                              ? null
                              : () => unawaited(_confirmClearArtworkCache()),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
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
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
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

class _FolderTile extends StatelessWidget {
  const _FolderTile({
    required this.folder,
    required this.tracks,
    required this.enabled,
    required this.onToggle,
    required this.onDeleteTrack,
  });

  final FolderUsage folder;
  final List<Track> tracks;
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final ValueChanged<Track> onDeleteTrack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return ExpansionTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              p.basename(folder.path),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.rowTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppSwitch(
            value: folder.isIncluded,
            onChanged: enabled ? onToggle : (_) {},
            semanticLabel: l10n.includeInScanSemanticLabel,
          ),
        ],
      ),
      subtitle: Text(
        '${l10n.trackCountLabel(folder.trackCount)} · '
        '${formatFileSize(folder.sizeBytes)}',
        style: AppTypography.caption.copyWith(color: colors.textSecondary),
      ),
      children: [
        for (final track in tracks)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
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
                Text(
                  formatFileSize(track.fileSize),
                  style: AppTypography.meta.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
                AppIconButton(
                  icon: Icons.delete_outline_rounded,
                  semanticLabel: l10n.deleteFileSemanticLabel,
                  size: 36,
                  iconSize: AppSizes.iconSmall,
                  onPressed: enabled ? () => onDeleteTrack(track) : null,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
