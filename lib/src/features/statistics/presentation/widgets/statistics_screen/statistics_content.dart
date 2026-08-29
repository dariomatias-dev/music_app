import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/navigators/library_navigator.dart';
import 'package:music_app/src/core/utils/duration_formatter.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/library/presentation/widgets/media_row.dart';
import 'package:music_app/src/features/player/presentation/widgets/mini_player.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';
import 'package:music_app/src/features/statistics/presentation/providers/statistics_providers.dart';
import 'package:music_app/src/features/statistics/presentation/view_models/statistics_period_view_model.dart';
import 'package:music_app/src/features/statistics/presentation/widgets/statistics_bar_chart.dart';
import 'package:music_app/src/features/statistics/presentation/widgets/statistics_screen/stat_card.dart';
import 'package:music_app/src/features/statistics/presentation/widgets/statistics_screen/statistics_section.dart';

/// The statistics screen's body once play history exists: period selector,
/// listening totals, activity charts and ranked most-played lists.
class StatisticsContent extends ConsumerWidget {
  /// Creates a [StatisticsContent].
  const StatisticsContent({super.key});

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
                child: StatCard(
                  label: l10n.totalListenedLabel,
                  value: formatLongDuration(totalListened),
                ),
              ),
              const SizedBox(width: AppSpacing.smMd),
              Expanded(
                child: StatCard(
                  label: l10n.currentStreakLabel,
                  value: l10n.dayCountLabel(streak?.currentDays ?? 0),
                ),
              ),
              const SizedBox(width: AppSpacing.smMd),
              Expanded(
                child: StatCard(
                  label: l10n.longestStreakLabel,
                  value: l10n.dayCountLabel(streak?.longestDays ?? 0),
                ),
              ),
            ],
          ),
        ),
        StatisticsSection(
          title: l10n.dailyActivityLabel,
          child: StatisticsBarChart(
            values: [for (final day in daily) day.playCount],
          ),
        ),
        StatisticsSection(
          title: l10n.hourlyActivityLabel,
          child: StatisticsBarChart(values: hourly),
        ),
        if (tracks.isNotEmpty)
          StatisticsSection(
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
          StatisticsSection(
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
                    onTap: () => LibraryNavigator.openArtist(
                      context,
                      artistId: artist.id,
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
