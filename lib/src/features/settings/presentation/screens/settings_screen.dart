import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/core/utils/language_names.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/settings/presentation/view_models/locale_view_model.dart';
import 'package:music_app/src/features/settings/presentation/view_models/theme_mode_view_model.dart';
import 'package:music_app/src/features/settings/presentation/view_models/user_profile_view_model.dart';
import 'package:music_app/src/features/settings/presentation/widgets/edit_name_sheet.dart';
import 'package:music_app/src/features/settings/presentation/widgets/theme_mode_sheet.dart';

/// The Settings tab: preferences organized into sections, each a group of
/// standardized rows.
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
    } on Object catch (_) {
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

    return AppScaffold(
      topBar: AppTopBar(title: l10n.settingsTabLabel, showBack: false),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _Section(
            title: l10n.settingsSectionProfileLabel,
            children: [
              AppSettingsRow(
                icon: Icons.person_outline_rounded,
                label: l10n.settingsNameLabel,
                value: (displayName == null || displayName.isEmpty)
                    ? l10n.settingsNameNotSetValue
                    : displayName,
                onTap: () => unawaited(_editName(context, ref, displayName)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _Section(
            title: l10n.settingsSectionAppearanceLabel,
            children: [
              AppSettingsRow(
                icon: Icons.dark_mode_outlined,
                label: l10n.settingsThemeLabel,
                value: _themeModeDisplayName(l10n, themeMode),
                onTap: () => unawaited(showThemeModeSheet(context, ref)),
              ),
              AppSettingsRow(
                icon: Icons.language_rounded,
                label: l10n.settingsLanguageLabel,
                value: locale == null
                    ? l10n.settingsLanguageSystemValue
                    : languageDisplayName(locale),
                onTap: () => context.push(RoutePaths.settingsLanguage),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _Section(
            title: l10n.settingsSectionPlaybackLabel,
            children: [
              AppSettingsRow(
                icon: Icons.tune_rounded,
                label: l10n.settingsPlaybackRowLabel,
                onTap: () => context.push(RoutePaths.settingsPlayback),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _Section(
            title: l10n.settingsSectionLibraryLabel,
            children: [
              AppSettingsRow(
                icon: Icons.sd_storage_outlined,
                label: l10n.storageLabel,
                onTap: () => context.push(RoutePaths.storage),
              ),
              AppSettingsRow(
                icon: Icons.bar_chart_rounded,
                label: l10n.statisticsLabel,
                onTap: () => context.push(RoutePaths.statistics),
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
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _Section(
            title: l10n.settingsSectionAboutLabel,
            children: [
              AppSettingsRow(
                icon: Icons.info_outline_rounded,
                label: l10n.settingsAboutRowLabel,
                onTap: () => context.push(RoutePaths.about),
              ),
            ],
          ),
        ],
      ),
    );
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

  String _themeModeDisplayName(AppLocalizations l10n, ThemeMode? mode) {
    return switch (mode) {
      ThemeMode.light => l10n.themeLightLabel,
      ThemeMode.dark => l10n.themeDarkLabel,
      ThemeMode.system || null => l10n.themeSystemLabel,
    };
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.sm,
            bottom: AppSpacing.xs,
          ),
          child: Text(
            title,
            style: AppTypography.section.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
        AppSectionContainer(
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    indent: AppSpacing.md,
                    color: context.colors.divider,
                  ),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
