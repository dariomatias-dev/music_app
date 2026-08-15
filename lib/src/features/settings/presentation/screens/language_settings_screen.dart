import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/utils/language_names.dart';
import 'package:music_app/src/features/settings/presentation/view_models/locale_view_model.dart';

const _selectableLocales = [
  Locale('en'),
  Locale('es'),
  Locale('pt', 'BR'),
  Locale('zh'),
];

/// The language settings screen: every supported language, plus a system
/// default option, with the active one checked.
class LanguageSettingsScreen extends ConsumerWidget {
  /// Creates a [LanguageSettingsScreen].
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedLocale = ref.watch(localeViewModelProvider).value;

    return AppScaffold(
      topBar: AppTopBar(
        title: l10n.settingsLanguageLabel,
        backButtonSemanticLabel: l10n.backButtonSemanticLabel,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: AppSectionContainer(
          child: Column(
            children: [
              _LanguageRow(
                label: l10n.settingsLanguageSystemValue,
                selected: selectedLocale == null,
                onTap: () => unawaited(
                  ref
                      .read(localeViewModelProvider.notifier)
                      .resetToSystemLocale()
                      .then((_) {
                        if (context.mounted) context.pop();
                      }),
                ),
              ),
              for (final locale in _selectableLocales) ...[
                Divider(height: 1, color: context.colors.divider),
                _LanguageRow(
                  label: languageDisplayName(locale),
                  selected: selectedLocale == locale,
                  onTap: () => unawaited(
                    ref
                        .read(localeViewModelProvider.notifier)
                        .setLocale(locale)
                        .then((_) {
                          if (context.mounted) context.pop();
                        }),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSettingsRow(
      icon: Icons.language_rounded,
      label: label,
      onTap: onTap,
      trailing: selected
          ? Icon(Icons.check_rounded, color: context.colors.accent)
          : const SizedBox.shrink(),
    );
  }
}
