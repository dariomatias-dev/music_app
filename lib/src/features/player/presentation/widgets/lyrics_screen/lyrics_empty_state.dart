import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';

/// Shown when the current track has no usable lyrics content.
class LyricsEmptyState extends StatelessWidget {
  /// Creates a [LyricsEmptyState].
  const LyricsEmptyState({required this.l10n, super.key});

  /// The active localization.
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.lyrics_outlined,
      title: l10n.lyricsEmptyTitle,
      message: l10n.lyricsEmptyMessage,
    );
  }
}
