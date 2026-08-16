import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/app_router.dart';
import 'package:music_app/src/core/navigation/route_transitions.dart';
import 'package:music_app/src/features/player/presentation/widgets/playback_error_listener.dart';
import 'package:music_app/src/features/settings/presentation/view_models/locale_view_model.dart';
import 'package:music_app/src/features/settings/presentation/view_models/theme_mode_view_model.dart';

/// Root widget of the application.
class MusicApp extends ConsumerWidget {
  /// Creates the root widget of the application.
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeViewModelProvider).value;
    final themeMode =
        ref.watch(themeModeViewModelProvider).value ?? ThemeMode.system;
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final brightness = switch (themeMode) {
      ThemeMode.system => platformBrightness,
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
    };
    final baseTheme = brightness == Brightness.dark
        ? AppTheme.dark
        : AppTheme.light;
    final theme = baseTheme.copyWith(
      pageTransitionsTheme: appPageTransitionsTheme,
    );
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
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
            child: PlaybackErrorListener(child: child!),
          ),
        );
      },
      routerConfig: router,
    );
  }
}
