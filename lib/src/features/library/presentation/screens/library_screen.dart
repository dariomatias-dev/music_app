import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';

/// The Library tab.
class LibraryScreen extends StatelessWidget {
  /// Creates a [LibraryScreen].
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      topBar: AppTopBar(title: l10n.libraryTabLabel, showBack: false),
      body: const SizedBox.shrink(),
    );
  }
}
