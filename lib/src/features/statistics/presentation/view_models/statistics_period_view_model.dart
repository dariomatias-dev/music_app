import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'statistics_period_view_model.g.dart';

/// The rolling window statistics are computed over, switched between with a
/// segmented control.
enum StatisticsPeriod {
  /// The last 7 days.
  week,

  /// The last 30 days.
  month,

  /// The last 365 days.
  year,

  /// Every recorded play.
  allTime;

  /// The earliest moment to include, relative to [now]; `null` for
  /// [allTime], meaning no lower bound.
  DateTime? cutoff(DateTime now) => switch (this) {
    StatisticsPeriod.week => now.subtract(const Duration(days: 7)),
    StatisticsPeriod.month => now.subtract(const Duration(days: 30)),
    StatisticsPeriod.year => now.subtract(const Duration(days: 365)),
    StatisticsPeriod.allTime => null,
  };
}

/// Which [StatisticsPeriod] the statistics screen is currently showing.
@riverpod
class StatisticsPeriodViewModel extends _$StatisticsPeriodViewModel {
  @override
  StatisticsPeriod build() => StatisticsPeriod.week;

  /// The period currently shown.
  StatisticsPeriod get period => state;

  /// Switches to [period].
  set period(StatisticsPeriod period) => state = period;
}
