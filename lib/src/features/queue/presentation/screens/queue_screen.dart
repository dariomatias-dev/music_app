import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';

/// Temporary placeholder for the playback queue screen.
///
/// Fully built in Fase 12.
class QueueScreen extends StatelessWidget {
  /// Creates a [QueueScreen].
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      topBar: AppTopBar(
        title: l10n.viewQueueLabel,
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
      ),
      body: const SizedBox.shrink(),
    );
  }
}
