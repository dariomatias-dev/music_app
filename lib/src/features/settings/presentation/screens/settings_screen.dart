import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/errors/error_reporter_provider.dart';
import 'package:music_app/src/core/navigation/navigators/onboarding_navigator.dart';
import 'package:music_app/src/core/navigation/navigators/settings_navigator.dart';
import 'package:music_app/src/core/navigation/navigators/statistics_navigator.dart';
import 'package:music_app/src/core/navigation/navigators/storage_navigator.dart';
import 'package:music_app/src/core/utils/language_names.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/onboarding/presentation/view_models/onboarding_view_model.dart';
import 'package:music_app/src/features/settings/data/providers/app_info_provider.dart';
import 'package:music_app/src/features/settings/presentation/view_models/locale_view_model.dart';
import 'package:music_app/src/features/settings/presentation/view_models/theme_mode_view_model.dart';
import 'package:music_app/src/features/settings/presentation/view_models/user_profile_view_model.dart';
import 'package:music_app/src/features/settings/presentation/widgets/edit_name_sheet.dart';
import 'package:music_app/src/features/settings/presentation/widgets/language_sheet.dart';
import 'package:music_app/src/features/settings/presentation/widgets/playback_sheet.dart';
import 'package:music_app/src/features/settings/presentation/widgets/settings_screen/settings_group_label.dart';

/// The Settings tab: a flat list of rows grouped under section labels,
/// each leading to a sheet, a screen, or acting immediately in place.
class SettingsScreen extends ConsumerStatefulWidget {
  /// Creates a [SettingsScreen].
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  var _rescanning = false;

  Future<void> _rescan() async {
    setState(() => _rescanning = true);
    try {
      await ref.read(libraryRepositoryProvider).reindex().drain<void>();
      // The scan touches device files and metadata parsing outside our
      // control; any failure here should reset the busy state and tell the
      // user, not leave the row spinning forever.
    } on Object catch (error, stackTrace) {
      ref
          .read(errorReporterProvider)
          .report(error, stackTrace, context: 'Rescanning the library');
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() => _rescanning = false);
      AppToast.show(
        context,
        message: l10n.scanErrorMessage,
        variant: AppToastVariant.error,
      );
      return;
    }
    if (!mounted) return;
    setState(() => _rescanning = false);
    final l10n = AppLocalizations.of(context)!;
    AppToast.show(context, message: l10n.rescanCompleteMessage);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final displayName = ref.watch(userProfileViewModelProvider).value;
    final locale = ref.watch(localeViewModelProvider).value;
    final themeMode = ref.watch(themeModeViewModelProvider).value;
    final isDark = _resolveIsDark(context, themeMode);
    final packageInfo = ref.watch(appInfoProvider).value;

    return AppScaffold(
      topBar: AppTopBar(title: l10n.settingsTabLabel, showBack: false),
      body: ListView(
        children: [
          SettingsGroupLabel(l10n.settingsSectionProfileLabel),
          AppSettingsRow(
            icon: Icons.person_outline_rounded,
            label: l10n.settingsNameLabel,
            value: (displayName == null || displayName.isEmpty)
                ? l10n.settingsNameNotSetValue
                : displayName,
            onTap: () => unawaited(_editName(context, ref, displayName)),
          ),
          AppSettingsRow(
            icon: Icons.dark_mode_outlined,
            label: l10n.settingsThemeLabel,
            value: isDark ? l10n.themeDarkLabel : l10n.themeLightLabel,
            onTap: () => unawaited(
              ref
                  .read(themeModeViewModelProvider.notifier)
                  .setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark),
            ),
          ),
          AppSettingsRow(
            icon: Icons.language_rounded,
            label: l10n.settingsLanguageLabel,
            value: locale == null
                ? l10n.settingsLanguageSystemValue
                : languageDisplayName(locale),
            onTap: () => unawaited(showLanguageSheet(context, ref)),
          ),
          AppSettingsRow(
            icon: Icons.tune_rounded,
            label: l10n.settingsPlaybackRowLabel,
            onTap: () => unawaited(showPlaybackSheet(context, ref)),
          ),
          SettingsGroupLabel(l10n.settingsSectionLibraryLabel),
          AppSettingsRow(
            icon: Icons.sd_storage_outlined,
            label: l10n.storageLabel,
            onTap: () => StorageNavigator.openStorage(context),
          ),
          AppSettingsRow(
            icon: Icons.bar_chart_rounded,
            label: l10n.statisticsLabel,
            onTap: () => StatisticsNavigator.openStatistics(context),
          ),
          AppSettingsRow(
            icon: Icons.refresh_rounded,
            label: l10n.settingsRescanLabel,
            trailing: _rescanning
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: AppLoadingIndicator(size: 18),
                  )
                : null,
            onTap: _rescanning ? null : () => unawaited(_rescan()),
          ),
          SettingsGroupLabel(l10n.settingsSectionAboutLabel),
          AppSettingsRow(
            icon: Icons.restart_alt_rounded,
            label: l10n.settingsReplayOnboardingLabel,
            onTap: () => unawaited(_replayOnboarding(context, ref)),
          ),
          AppSettingsRow(
            icon: Icons.info_outline_rounded,
            label: l10n.settingsAboutRowLabel,
            onTap: () => SettingsNavigator.openAbout(context),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Text(
              packageInfo == null
                  ? l10n.appName
                  : '${l10n.appName} ${packageInfo.version}',
              style: AppTypography.caption.copyWith(
                color: context.colors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _resolveIsDark(BuildContext context, ThemeMode? mode) {
    return switch (mode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system ||
      null => MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };
  }

  Future<void> _editName(
    BuildContext context,
    WidgetRef ref,
    String? currentName,
  ) async {
    final name = await showEditNameSheet(context, initialName: currentName);
    if (name == null) return;
    await ref.read(userProfileViewModelProvider.notifier).setDisplayName(name);
  }

  Future<void> _replayOnboarding(BuildContext context, WidgetRef ref) async {
    await ref.read(onboardingViewModelProvider.notifier).reset();
    if (!context.mounted) return;
    OnboardingNavigator.goToOnboarding(context);
  }
}
