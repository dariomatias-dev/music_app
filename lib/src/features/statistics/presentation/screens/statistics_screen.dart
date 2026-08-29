import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/history/data/providers/history_data_providers.dart';
import 'package:music_app/src/features/player/presentation/widgets/mini_player.dart';
import 'package:music_app/src/features/statistics/presentation/providers/statistics_providers.dart';
import 'package:music_app/src/features/statistics/presentation/widgets/statistics_screen/statistics_content.dart';

/// The statistics screen: a period selector, listening totals, activity
/// charts, ranked most-played lists, and history clearing.
class StatisticsScreen extends ConsumerWidget {
  /// Creates a [StatisticsScreen].
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final hasHistory = ref.watch(hasPlayHistoryProvider).value;

    return MiniPlayerDock(
      child: AppScaffold(
        topBar: AppTopBar(
          title: l10n.statisticsLabel,
          backButtonSemanticLabel: l10n.backButtonSemanticLabel,
          trailing: hasHistory ?? false
              ? AppIconButton(
                  icon: Icons.delete_outline_rounded,
                  semanticLabel: l10n.clearHistoryLabel,
                  onPressed: () => unawaited(_confirmClear(context, ref)),
                )
              : null,
        ),
        body: switch (hasHistory) {
          null => const AppLoadingIndicator(),
          false => AppEmptyState(
            icon: Icons.bar_chart_rounded,
            title: l10n.statisticsEmptyTitle,
            message: l10n.statisticsEmptyMessage,
          ),
          true => const StatisticsContent(),
        },
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppDestructiveDialog.show(
      context,
      title: l10n.clearHistoryConfirmTitle,
      message: l10n.clearHistoryConfirmMessage,
      confirmLabel: l10n.clearHistoryConfirmAction,
      cancelLabel: l10n.cancelLabel,
    );
    if (!confirmed) return;
    await ref.read(playHistoryRepositoryProvider).clearHistory();
  }
}
