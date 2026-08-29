import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';

/// A row of export/import buttons, reused for both the JSON library backup
/// and the raw database backup sections.
class StorageBackupActions extends StatelessWidget {
  /// Creates a [StorageBackupActions].
  const StorageBackupActions({
    required this.enabled,
    required this.onExport,
    required this.onImport,
    this.exportLabel,
    this.importLabel,
    super.key,
  });

  /// Whether the export/import buttons respond to input.
  final bool enabled;

  /// Called when the export button is pressed.
  final VoidCallback onExport;

  /// Called when the import button is pressed.
  final VoidCallback onImport;

  /// Overrides the default export button label.
  final String? exportLabel;

  /// Overrides the default import button label.
  final String? importLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppTextButton(
              label: exportLabel ?? l10n.exportBackupLabel,
              onPressed: enabled ? onExport : null,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: AppTextButton(
              label: importLabel ?? l10n.importBackupLabel,
              onPressed: enabled ? onImport : null,
            ),
          ),
        ],
      ),
    );
  }
}
