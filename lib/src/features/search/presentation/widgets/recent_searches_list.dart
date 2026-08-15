import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/search/data/providers/search_data_providers.dart';
import 'package:music_app/src/features/search/presentation/providers/search_history_providers.dart';

/// Recent search terms, shown while the search field is empty. Renders
/// nothing once a term is entered or when there's no history yet.
class RecentSearchesList extends ConsumerWidget {
  /// Creates a [RecentSearchesList].
  const RecentSearchesList({required this.onSelect, super.key});

  /// Called with the tapped term.
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final terms = ref.watch(recentSearchTermsProvider).value ?? const [];

    if (terms.isEmpty) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.smMd,
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.recentSearchesLabel,
                style: AppTypography.section.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
              AppTextButton(
                label: l10n.clearSearchHistoryLabel,
                onPressed: () => unawaited(_confirmClear(context, ref)),
              ),
            ],
          ),
        ),
        for (final term in terms)
          _RecentSearchRow(term: term, onSelect: onSelect),
      ],
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppDestructiveDialog.show(
      context,
      title: l10n.clearSearchHistoryConfirmTitle,
      message: l10n.clearSearchHistoryConfirmMessage,
      confirmLabel: l10n.clearSearchHistoryConfirmAction,
      cancelLabel: l10n.cancelLabel,
    );
    if (!confirmed) return;
    await ref.read(searchHistoryRepositoryProvider).clear();
  }
}

class _RecentSearchRow extends ConsumerWidget {
  const _RecentSearchRow({required this.term, required this.onSelect});

  final String term;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Pressable(
      scale: 0.99,
      onTap: () => onSelect(term),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.smMd,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(Icons.history_rounded, color: colors.textTertiary),
            const SizedBox(width: AppSpacing.smMd),
            Expanded(
              child: Text(
                term,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.rowTitle.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
            AppIconButton(
              icon: Icons.close_rounded,
              semanticLabel: l10n.removeSearchTermSemanticLabel,
              size: 36,
              iconSize: AppSizes.iconSmall,
              onPressed: () => unawaited(
                ref.read(searchHistoryRepositoryProvider).remove(term),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
