import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';

/// Temporary placeholder for the storage screen.
///
/// Fully built in Fase 19.
class StorageScreen extends StatelessWidget {
  /// Creates a [StorageScreen].
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      topBar: AppTopBar(
        title: l10n.storageLabel,
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
      ),
      body: const SizedBox.shrink(),
    );
  }
}
