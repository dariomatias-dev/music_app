import 'package:app_ui/app_ui.dart';
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
    final brightness = MediaQuery.platformBrightnessOf(context);
    final theme = brightness == Brightness.dark
        ? AppTheme.dark
        : AppTheme.light;

    return MaterialApp(
      theme: theme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return AppThemeSwitcher(
          data: theme,
          child: MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: mediaQuery.textScaler.clamp(
                maxScaleFactor: AppTypography.maxTextScaleFactor,
              ),
            ),
            child: child!,
          ),
        );
      },
      home: const Placeholder(),
    );
  }
}
