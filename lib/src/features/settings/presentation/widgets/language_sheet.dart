import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/utils/language_names.dart';
import 'package:music_app/src/features/settings/presentation/view_models/locale_view_model.dart';

const _selectableLocales = [
  Locale('en'),
  Locale('es'),
  Locale('pt'),
  Locale('zh'),
];

/// Shows the language options: every supported language, plus a system
/// default, with the active one checked.
Future<void> showLanguageSheet(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;
  final current = ref.read(localeViewModelProvider).value;

  void selectSystem(BuildContext sheetContext) {
    unawaited(
      ref.read(localeViewModelProvider.notifier).resetToSystemLocale().then((
        _,
      ) {
        if (sheetContext.mounted) Navigator.of(sheetContext).pop();
      }),
    );
  }

  void select(BuildContext sheetContext, Locale locale) {
    unawaited(
      ref.read(localeViewModelProvider.notifier).setLocale(locale).then((_) {
        if (sheetContext.mounted) Navigator.of(sheetContext).pop();
      }),
    );
  }

  return AppBottomSheet.show<void>(
    context,
    builder: (sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.smMd,
            AppSpacing.lg,
            AppSpacing.xxs,
          ),
          child: Text(
            l10n.settingsLanguageLabel,
            style: AppTypography.section.copyWith(
              color: sheetContext.colors.textPrimary,
            ),
          ),
        ),
        AppSheetAction(
          icon: Icons.translate_rounded,
          label: l10n.settingsLanguageSystemValue,
          trailing: current == null ? '✓' : null,
          onTap: () => selectSystem(sheetContext),
        ),
        for (final locale in _selectableLocales)
          AppSheetAction(
            icon: Icons.translate_rounded,
            label: languageDisplayName(locale),
            trailing: current == locale ? '✓' : null,
            onTap: () => select(sheetContext, locale),
          ),
        const SizedBox(height: AppSpacing.sm),
      ],
    ),
  );
}
