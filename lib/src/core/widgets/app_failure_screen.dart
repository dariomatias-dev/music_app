import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/l10n/app_localizations.dart';

/// The failure an [AppFailureScreen] is reporting.
enum AppFailureKind {
  /// The app could not finish starting up, so there is no app to show.
  startup,

  /// A part of a running app failed to build.
  unexpected,
}

/// A failure screen that stands on its own, outside the app's widget tree.
///
/// [ErrorWidget.builder] is invoked at the point of failure, which can sit
/// above [MaterialApp] when the root itself throws, and the startup
/// fallback runs before there is an app at all. Neither can read a
/// [Theme], a [Directionality] or an [AppLocalizations] from an ancestor
/// that may not exist, and reading one that is missing would throw from
/// inside the screen that exists to report the throw: all three are
/// resolved from the platform rather than from [BuildContext]. The text
/// direction is fixed rather than derived, since every supported locale
/// is left-to-right.
class AppFailureScreen extends StatelessWidget {
  /// Creates an [AppFailureScreen].
  const AppFailureScreen({
    required this.kind,
    this.onRetry,
    this.technicalDetails,
    super.key,
  });

  /// Which failure to describe.
  final AppFailureKind kind;

  /// Called when the retry action is tapped. When `null`, no retry action
  /// is shown.
  final VoidCallback? onRetry;

  /// Technical failure details, which [AppErrorState] shows in debug
  /// builds only.
  final String? technicalDetails;

  @override
  Widget build(BuildContext context) {
    final l10n = _localizations();
    final dispatcher = WidgetsBinding.instance.platformDispatcher;
    final theme = dispatcher.platformBrightness == Brightness.dark
        ? AppTheme.dark
        : AppTheme.light;
    final retry = onRetry;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Theme(
        data: theme,
        child: Material(
          color: theme.scaffoldBackgroundColor,
          child: AppErrorState(
            icon: Icons.error_outline,
            title: switch (kind) {
              AppFailureKind.startup => l10n.startupErrorTitle,
              AppFailureKind.unexpected => l10n.unexpectedErrorTitle,
            },
            message: switch (kind) {
              AppFailureKind.startup => l10n.startupErrorMessage,
              AppFailureKind.unexpected => l10n.unexpectedErrorMessage,
            },
            retryLabel: retry == null ? null : l10n.retryLabel,
            onRetry: retry,
            technicalDetails: technicalDetails,
          ),
        ),
      ),
    );
  }

  /// The localizations for the device's language, falling back to English.
  ///
  /// [lookupAppLocalizations] throws on an unsupported locale, which on a
  /// screen that exists to report a failure would replace it with another
  /// one.
  AppLocalizations _localizations() {
    final languageCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final supported = AppLocalizations.supportedLocales.any(
      (locale) => locale.languageCode == languageCode,
    );
    return lookupAppLocalizations(Locale(supported ? languageCode : 'en'));
  }
}
