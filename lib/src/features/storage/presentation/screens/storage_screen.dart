import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/core/errors/error_reporter_provider.dart';
import 'package:music_app/src/core/services/device_file/device_file_service_provider.dart';
import 'package:music_app/src/core/widgets/restart_widget.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/player/presentation/widgets/mini_player.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';
import 'package:music_app/src/features/storage/data/providers/storage_data_providers.dart';
import 'package:music_app/src/features/storage/domain/create_backup.dart';
import 'package:music_app/src/features/storage/domain/entities/backup_snapshot.dart';
import 'package:music_app/src/features/storage/domain/entities/folder_usage.dart';
import 'package:music_app/src/features/storage/domain/restore_database_backup.dart';
import 'package:music_app/src/features/storage/presentation/providers/storage_providers.dart';
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

/// Thrown when a picked backup file parses but was made with a
/// [backupFormatVersion] this build doesn't support, distinct from a file
/// that isn't valid JSON at all.
class _UnsupportedBackupFormatVersion implements Exception {
  const _UnsupportedBackupFormatVersion();
}

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
            if (_busy)
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
                    enabled: !_busy,
                    onExpandToggle: () => _toggleExpanded(folder.path),
                    onToggleIncluded: (included) => unawaited(
                      _toggleFolder(folder.path, included),
                    ),
                  ),
                  _TrackRow(:final track) => StorageTrackTile(
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
                  _BackupActionsRow() => StorageBackupActions(
                    enabled: !_busy,
                    onExport: () => unawaited(_exportBackup()),
                    onImport: () => unawaited(_importBackup()),
                  ),
                  _DatabaseBackupActionsRow() => StorageBackupActions(
                    enabled: !_busy,
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

  Future<void> _toggleFolder(String path, bool included) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _busy = true);

    try {
      final repository = ref.read(excludedFolderRepositoryProvider);
      if (included) {
        await repository.include(path);
      } else {
        await repository.exclude(path);
      }
    } on Object catch (error, stackTrace) {
      _report('Updating an excluded folder', error, stackTrace);
      _reportToggleFailure(l10n.folderUpdateFailedMessage);
      return;
    }

    try {
      await ref.read(libraryRepositoryProvider).reindex().drain<void>();
    } on Object catch (error, stackTrace) {
      _report('Rescanning after a folder toggle', error, stackTrace);
      _reportToggleFailure(l10n.scanErrorMessage);
      return;
    }

    if (mounted) setState(() => _busy = false);
  }

  /// Clears the busy state and tells the user that toggling a folder
  /// failed with [message].
  ///
  /// Both steps a toggle runs are outside this screen's control: the write
  /// goes to SQLite, and the rescan reads device files and parses their
  /// metadata. Either failing has to release the screen, which stays
  /// spinning with every control disabled for as long as it believes the
  /// toggle is still running.
  void _reportToggleFailure(String message) {
    if (!mounted) return;
    setState(() => _busy = false);
    AppToast.show(context, message: message, variant: AppToastVariant.error);
  }

  /// Records [error] as a failure of [operation].
  ///
  /// The catches on this screen are deliberately broad: each operation
  /// spans SQLite, the file system and the platform's file picker, and the
  /// screen has one sentence to say about any of them. Reporting keeps the
  /// cause the toast leaves out from vanishing with it.
  void _report(String operation, Object error, StackTrace stackTrace) {
    ref
        .read(errorReporterProvider)
        .report(error, stackTrace, context: operation);
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
    } on Exception catch (error, stackTrace) {
      _report('Deleting a track file', error, stackTrace);
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

  Future<void> _exportBackup() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    try {
      final snapshot = await ref.read(createBackupProvider)();
      final json = jsonEncode(snapshot.toJson());
      final timestamp = snapshot.createdAt.toIso8601String().replaceAll(
        RegExp('[:.]'),
        '-',
      );
      await ref
          .read(deviceFileServiceProvider)
          .saveFile(
            fileName: 'music_app_backup_$timestamp.json',
            bytes: Uint8List.fromList(utf8.encode(json)),
          );
      if (!mounted) return;
      AppToast.show(context, message: l10n.backupExportedMessage);
    } on Object catch (error, stackTrace) {
      _report('Exporting a backup', error, stackTrace);
      if (!mounted) return;
      AppToast.show(
        context,
        message: l10n.backupExportFailedMessage,
        variant: AppToastVariant.error,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _importBackup() async {
    final l10n = AppLocalizations.of(context)!;
    final bytes = await ref
        .read(deviceFileServiceProvider)
        .pickFile(allowedExtensions: ['json']);
    if (bytes == null) return;

    setState(() => _busy = true);
    try {
      final json = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      final snapshot = BackupSnapshot.fromJson(json);
      if (snapshot.formatVersion != backupFormatVersion) {
        throw const _UnsupportedBackupFormatVersion();
      }

      final result = await ref.read(restoreBackupProvider)(snapshot);
      if (!mounted) return;
      AppToast.show(
        context,
        message: result.skippedTracks > 0
            ? l10n.backupImportedWithSkippedTracksMessage(
                result.skippedTracks,
              )
            : l10n.backupImportedMessage,
      );
    } on _UnsupportedBackupFormatVersion {
      if (!mounted) return;
      AppToast.show(
        context,
        message: l10n.backupUnsupportedFormatMessage,
        variant: AppToastVariant.error,
      );
    } on Object catch (error, stackTrace) {
      _report('Importing a backup', error, stackTrace);
      if (!mounted) return;
      AppToast.show(
        context,
        message: l10n.backupImportFailedMessage,
        variant: AppToastVariant.error,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _exportDatabaseBackup() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    try {
      final bytes = await ref.read(createDatabaseBackupProvider)();
      final timestamp = DateTime.now().toIso8601String().replaceAll(
        RegExp('[:.]'),
        '-',
      );
      await ref
          .read(deviceFileServiceProvider)
          .saveFile(fileName: 'music_app_db_$timestamp.sqlite', bytes: bytes);
      if (!mounted) return;
      AppToast.show(context, message: l10n.databaseBackupExportedMessage);
    } on Object catch (error, stackTrace) {
      _report('Exporting a database backup', error, stackTrace);
      if (!mounted) return;
      AppToast.show(
        context,
        message: l10n.databaseBackupExportFailedMessage,
        variant: AppToastVariant.error,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
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
    if (!mounted) return;

    final bytes = await ref
        .read(deviceFileServiceProvider)
        .pickFile(allowedExtensions: ['sqlite', 'db']);
    if (bytes == null) return;

    if (!isSqliteDatabase(bytes)) {
      if (!mounted) return;
      AppToast.show(
        context,
        message: l10n.invalidDatabaseBackupMessage,
        variant: AppToastVariant.error,
      );
      return;
    }

    setState(() => _busy = true);
    try {
      // The database file is about to be overwritten on disk, so the live
      // connection is closed first: writing under an open SQLite connection
      // can corrupt it. Past this point there's no state worth resetting to
      // if either step fails — the app restarts either way, reopening
      // whatever ends up on disk, since a closed connection can't otherwise
      // be recovered from this screen.
      await ref.read(appDatabaseProvider).close();
      await ref.read(restoreDatabaseBackupProvider)(bytes);
    } on Object catch (error, stackTrace) {
      _report('Restoring a database backup', error, stackTrace);
      if (mounted) {
        AppToast.show(
          context,
          message: l10n.databaseBackupImportFailedMessage,
          variant: AppToastVariant.error,
        );
        // Gives the toast above a moment on screen before the restart below
        // tears down the whole widget tree, taking it with it.
        await Future<void>.delayed(const Duration(seconds: 2));
      }
    }
    if (!mounted) return;
    RestartWidget.restartApp(context);
  }
}
