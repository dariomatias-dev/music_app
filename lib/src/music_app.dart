import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';

/// Root widget of the application.
class MusicApp extends StatelessWidget {
  /// Creates the root widget of the application.
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Placeholder(),
    );
  }
}
