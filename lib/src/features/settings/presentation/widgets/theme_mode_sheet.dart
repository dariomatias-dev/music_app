import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/settings/presentation/view_models/theme_mode_view_model.dart';

/// Shows the theme mode options: system, light or dark.
Future<void> showThemeModeSheet(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;

  void select(ThemeMode mode) {
    unawaited(
      ref.read(themeModeViewModelProvider.notifier).setThemeMode(mode),
    );
    Navigator.of(context).pop();
  }

  return AppBottomSheet.show<void>(
    context,
    builder: (sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 2),
          child: Text(
            l10n.settingsThemeLabel,
            style: AppTypography.section.copyWith(
              color: sheetContext.colors.textPrimary,
            ),
          ),
        ),
        AppSheetAction(
          icon: Icons.brightness_auto_rounded,
          label: l10n.themeSystemLabel,
          onTap: () => select(ThemeMode.system),
        ),
        AppSheetAction(
          icon: Icons.light_mode_outlined,
          label: l10n.themeLightLabel,
          onTap: () => select(ThemeMode.light),
        ),
        AppSheetAction(
          icon: Icons.dark_mode_outlined,
          label: l10n.themeDarkLabel,
          onTap: () => select(ThemeMode.dark),
        ),
        const SizedBox(height: 6),
      ],
    ),
  );
}
