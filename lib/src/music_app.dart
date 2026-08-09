import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/settings/presentation/view_models/locale_view_model.dart';

/// Root widget of the application.
class MusicApp extends ConsumerWidget {
  /// Creates the root widget of the application.
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeViewModelProvider).value;

    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Placeholder(),
    );
  }
}
