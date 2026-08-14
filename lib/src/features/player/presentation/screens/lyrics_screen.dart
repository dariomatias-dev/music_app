import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';

/// Temporary placeholder for the lyrics screen.
///
/// Fully built in Fase 13.
class LyricsScreen extends StatelessWidget {
  /// Creates a [LyricsScreen].
  const LyricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      topBar: AppTopBar(
        title: l10n.openLyricsLabel,
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
      ),
      body: const SizedBox.shrink(),
    );
  }
}
