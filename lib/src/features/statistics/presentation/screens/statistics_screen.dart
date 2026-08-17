import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/features/history/data/providers/history_data_providers.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/library/presentation/widgets/media_row.dart';
import 'package:music_app/src/features/player/presentation/widgets/mini_player.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';
import 'package:music_app/src/features/statistics/presentation/providers/statistics_providers.dart';
import 'package:music_app/src/features/statistics/presentation/view_models/statistics_period_view_model.dart';
import 'package:music_app/src/features/statistics/presentation/widgets/statistics_bar_chart.dart';

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
          true => const _StatisticsContent(),
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

class _StatisticsContent extends ConsumerWidget {
  const _StatisticsContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final period = ref.watch(statisticsPeriodViewModelProvider);
    final totalListened =
        ref.watch(totalListenedDurationProvider).value ?? Duration.zero;
    final streak = ref.watch(listeningStreakProvider).value;
    final daily = ref.watch(dailyPlayCountsProvider).value ?? const [];
    final hourly = ref.watch(hourlyDistributionProvider).value ?? const [];
    final tracks = ref.watch(mostPlayedTracksProvider).take(5).toList();
    final artists = ref.watch(mostPlayedArtistsProvider).take(5).toList();
    final artistNames = ref.watch(artistNamesProvider);
    final albumArtwork = ref.watch(albumArtworkProvider);

    return ListView(
      padding: EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: MiniPlayerDock.insetOf(context),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: AppSegmentedBar(
            labels: [
              l10n.periodWeekLabel,
              l10n.periodMonthLabel,
              l10n.periodYearLabel,
              l10n.periodAllTimeLabel,
            ],
            index: StatisticsPeriod.values.indexOf(period),
            onChanged: (index) =>
                ref.read(statisticsPeriodViewModelProvider.notifier).period =
                    StatisticsPeriod.values[index],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: l10n.totalListenedLabel,
                  value: formatLongDuration(totalListened),
                ),
              ),
              const SizedBox(width: AppSpacing.smMd),
              Expanded(
                child: _StatCard(
                  label: l10n.currentStreakLabel,
                  value: l10n.dayCountLabel(streak?.currentDays ?? 0),
                ),
              ),
              const SizedBox(width: AppSpacing.smMd),
              Expanded(
                child: _StatCard(
                  label: l10n.longestStreakLabel,
                  value: l10n.dayCountLabel(streak?.longestDays ?? 0),
                ),
              ),
            ],
          ),
        ),
        _Section(
          title: l10n.dailyActivityLabel,
          child: StatisticsBarChart(
            values: [for (final day in daily) day.playCount],
          ),
        ),
        _Section(
          title: l10n.hourlyActivityLabel,
          child: StatisticsBarChart(values: hourly),
        ),
        if (tracks.isNotEmpty)
          _Section(
            title: l10n.mostPlayedTracksLabel,
            padded: false,
            child: Column(
              children: [
                for (final track in tracks)
                  MediaRow(
                    seed: track.id,
                    title: track.title,
                    subtitle: artistNames[track.artistId],
                    artworkPath: albumArtwork[track.albumId],
                    onTap: () => unawaited(
                      ref.read(queueViewModelProvider.notifier).playFromSource([
                        track,
                      ], startIndex: 0),
                    ),
                  ),
              ],
            ),
          ),
        if (artists.isNotEmpty)
          _Section(
            title: l10n.mostPlayedArtistsLabel,
            padded: false,
            child: Column(
              children: [
                for (final artist in artists)
                  MediaRow(
                    seed: artist.id,
                    title: artist.name,
                    circle: true,
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: context.colors.textTertiary,
                    ),
                    onTap: () => context.push(RoutePaths.artist(artist.id)),
                  ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.smMd,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.header.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.padded = true,
  });

  final String title;
  final Widget child;
  final bool padded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            child: Text(
              title,
              style: AppTypography.section.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ),
          if (padded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: child,
            )
          else
            child,
        ],
      ),
    );
  }
}
