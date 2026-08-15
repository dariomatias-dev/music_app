import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';

/// Temporary placeholder for the playback settings screen.
///
/// Fully built in Etapa 93.
class PlaybackSettingsScreen extends StatelessWidget {
  /// Creates a [PlaybackSettingsScreen].
  const PlaybackSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      topBar: AppTopBar(
        title: l10n.settingsSectionPlaybackLabel,
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
      ),
      body: const SizedBox.shrink(),
    );
  }
}
