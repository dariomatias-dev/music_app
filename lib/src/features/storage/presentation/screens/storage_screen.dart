import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/widgets/restart_widget.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/player/presentation/widgets/mini_player.dart';
import 'package:music_app/src/features/storage/domain/entities/folder_usage.dart';
import 'package:music_app/src/features/storage/presentation/providers/storage_providers.dart';
import 'package:music_app/src/features/storage/presentation/view_models/storage_view_model.dart';
import 'package:music_app/src/features/storage/presentation/widgets/storage_screen/storage_backup_actions.dart';
import 'package:music_app/src/features/storage/presentation/widgets/storage_screen/storage_folder_header.dart';
import 'package:music_app/src/features/storage/presentation/widgets/storage_screen/storage_section_label.dart';
import 'package:music_app/src/features/storage/presentation/widgets/storage_screen/storage_summary_tile.dart';
import 'package:music_app/src/features/storage/presentation/widgets/storage_screen/storage_track_tile.dart';

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

class _SectionLabelRow extends _Row {
  _SectionLabelRow(this.label);
  final String label;
}

class _EmptyFoldersRow extends _Row {}

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

class _BackupActionsRow extends _Row {}

class _DatabaseBackupActionsRow extends _Row {}

class _StorageScreenState extends ConsumerState<StorageScreen> {
  final _expandedFolders = <String>{};

  void _toggleExpanded(String path) {
    setState(() {
      if (!_expandedFolders.remove(path)) _expandedFolders.add(path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final busy = ref.watch(storageViewModelProvider);
    final totalUsed = ref.watch(totalStorageUsageProvider);
    final folders = ref.watch(folderUsageProvider);
    final folderTracks = ref.watch(folderTracksProvider);

    // A lightweight index of rows, not widgets: ListView.builder only
    // calls itemBuilder for rows actually on screen, so a folder with
    // thousands of tracks costs nothing until it's expanded and scrolled
    // into view, rather than laying every track out immediately like
    // ExpansionTile's own (eagerly built) children used to.
    final rows = <_Row>[
      _SummaryRow(),
      _SectionLabelRow(l10n.storageFoldersLabel),
    ];
    if (folders.isEmpty) {
      rows.add(_EmptyFoldersRow());
    } else {
      for (final folder in folders) {
        rows.add(_FolderHeaderRow(folder));
        if (_expandedFolders.contains(folder.path)) {
          final tracks = folderTracks[folder.path] ?? const <Track>[];
          for (final track in tracks) {
            rows.add(_TrackRow(folder, track));
          }
        }
      }
    }
    rows
      ..add(_ClearCacheRow())
      ..add(_SectionLabelRow(l10n.backupSectionLabel))
      ..add(_BackupActionsRow())
      ..add(_SectionLabelRow(l10n.databaseBackupSectionLabel))
      ..add(_DatabaseBackupActionsRow());

    return MiniPlayerDock(
      child: AppScaffold(
        topBar: AppTopBar(
          title: l10n.storageLabel,
          backButtonSemanticLabel: l10n.backButtonSemanticLabel,
        ),
        body: Column(
          children: [
            if (busy)
              LinearProgressIndicator(
                color: context.colors.accent,
                backgroundColor: context.colors.divider,
              ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(
                  top: AppSpacing.sm,
                  bottom: MiniPlayerDock.insetOf(context),
                ),
                itemCount: rows.length,
                itemBuilder: (context, index) => switch (rows[index]) {
                  _SummaryRow() => StorageSummaryTile(totalUsed: totalUsed),
                  _SectionLabelRow(:final label) => StorageSectionLabel(
                    label: label,
                  ),
                  _EmptyFoldersRow() => Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xl,
                    ),
                    child: AppEmptyState(
                      icon: Icons.folder_off_outlined,
                      title: l10n.storageEmptyTitle,
                      message: l10n.storageEmptyMessage,
                    ),
                  ),
                  _FolderHeaderRow(:final folder) => StorageFolderHeader(
                    folder: folder,
                    expanded: _expandedFolders.contains(folder.path),
                    enabled: !busy,
                    onExpandToggle: () => _toggleExpanded(folder.path),
                    onToggleIncluded: (included) => unawaited(
                      _toggleFolder(folder.path, included: included),
                    ),
                  ),
                  _TrackRow(:final track) => StorageTrackTile(
                    track: track,
                    enabled: !busy,
                    onDelete: () => unawaited(_confirmDeleteTrack(track)),
                  ),
                  _ClearCacheRow() => Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: AppTextButton(
                      label: l10n.clearArtworkCacheLabel,
                      onPressed: busy
                          ? null
                          : () => unawaited(_confirmClearArtworkCache()),
                    ),
                  ),
                  _BackupActionsRow() => StorageBackupActions(
                    enabled: !busy,
                    onExport: () => unawaited(_exportBackup()),
                    onImport: () => unawaited(_importBackup()),
                  ),
                  _DatabaseBackupActionsRow() => StorageBackupActions(
                    enabled: !busy,
                    exportLabel: l10n.exportDatabaseBackupLabel,
                    importLabel: l10n.importDatabaseBackupLabel,
                    onExport: () => unawaited(_exportDatabaseBackup()),
                    onImport: () => unawaited(_importDatabaseBackup()),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  StorageViewModel get _viewModel =>
      ref.read(storageViewModelProvider.notifier);

  Future<void> _toggleFolder(String path, {required bool included}) async {
    final outcome = await _viewModel.toggleFolder(path, included: included);
    _announce(outcome);
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

    final outcome = await _viewModel.clearArtworkCache();
    _announce(outcome, onSuccess: (l10n) => l10n.artworkCacheClearedMessage);
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

    final outcome = await _viewModel.deleteTrack(track);
    _announce(outcome, onSuccess: (l10n) => l10n.fileDeletedMessage);
  }

  Future<void> _exportBackup() async {
    final outcome = await _viewModel.exportBackup();
    _announce(outcome, onSuccess: (l10n) => l10n.backupExportedMessage);
  }

  Future<void> _importBackup() async {
    final result = await _viewModel.importBackup();
    _announce(
      result.outcome,
      onSuccess: (l10n) => result.skippedTracks > 0
          ? l10n.backupImportedWithSkippedTracksMessage(result.skippedTracks)
          : l10n.backupImportedMessage,
    );
  }

  Future<void> _exportDatabaseBackup() async {
    final outcome = await _viewModel.exportDatabaseBackup();
    _announce(
      outcome,
      onSuccess: (l10n) => l10n.databaseBackupExportedMessage,
    );
  }

  Future<void> _importDatabaseBackup() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppDestructiveDialog.show(
      context,
      title: l10n.restoreDatabaseConfirmTitle,
      message: l10n.restoreDatabaseConfirmMessage,
      confirmLabel: l10n.restoreLabel,
      cancelLabel: l10n.cancelLabel,
    );
    if (!confirmed) return;

    final outcome = await _viewModel.restoreDatabaseBackup();
    _announce(outcome);
    if (outcome == StorageOutcome.cancelled ||
        outcome == StorageOutcome.invalidDatabaseBackup) {
      return;
    }

    if (outcome == StorageOutcome.databaseRestoreFailed) {
      // Gives the toast above a moment on screen before the restart below
      // tears down the whole widget tree, taking it with it.
      await Future<void>.delayed(const Duration(seconds: 2));
    }
    if (!mounted) return;
    RestartWidget.restartApp(context);
  }

  /// Tells the user how [outcome] went.
  ///
  /// A failure speaks for itself; a success only does when [onSuccess]
  /// gives it something to say, since most of them are already visible in
  /// the list behind the toast.
  void _announce(
    StorageOutcome outcome, {
    String Function(AppLocalizations l10n)? onSuccess,
  }) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final failure = _failureMessage(outcome, l10n);
    if (failure != null) {
      AppToast.show(
        context,
        message: failure,
        variant: AppToastVariant.error,
      );
    } else if (outcome == StorageOutcome.succeeded && onSuccess != null) {
      AppToast.show(context, message: onSuccess(l10n));
    }
  }

  /// What to tell the user about [outcome], or `null` when it did not
  /// fail.
  String? _failureMessage(StorageOutcome outcome, AppLocalizations l10n) =>
      switch (outcome) {
        StorageOutcome.succeeded || StorageOutcome.cancelled => null,
        StorageOutcome.folderUpdateFailed => l10n.folderUpdateFailedMessage,
        StorageOutcome.rescanFailed => l10n.scanErrorMessage,
        StorageOutcome.artworkCacheClearFailed =>
          l10n.artworkCacheClearFailedMessage,
        StorageOutcome.fileDeleteFailed => l10n.fileDeleteFailedMessage,
        StorageOutcome.backupExportFailed => l10n.backupExportFailedMessage,
        StorageOutcome.backupImportFailed => l10n.backupImportFailedMessage,
        StorageOutcome.unsupportedBackupFormat =>
          l10n.backupUnsupportedFormatMessage,
        StorageOutcome.databaseBackupExportFailed =>
          l10n.databaseBackupExportFailedMessage,
        StorageOutcome.invalidDatabaseBackup =>
          l10n.invalidDatabaseBackupMessage,
        StorageOutcome.databaseRestoreFailed =>
          l10n.databaseBackupImportFailedMessage,
      };
}
