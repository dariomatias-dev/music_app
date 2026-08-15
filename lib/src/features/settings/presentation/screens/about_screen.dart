import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';

/// Temporary placeholder for the about screen.
///
/// Fully built in Etapa 94.
class AboutScreen extends StatelessWidget {
  /// Creates an [AboutScreen].
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      topBar: AppTopBar(
        title: l10n.settingsAboutLabel,
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
      ),
      body: const SizedBox.shrink(),
    );
  }
}
