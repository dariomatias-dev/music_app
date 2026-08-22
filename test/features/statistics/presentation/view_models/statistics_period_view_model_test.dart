import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/features/statistics/presentation/view_models/statistics_period_view_model.dart';

void main() {
  group('cutoff', () {
    final now = DateTime(2026, 6, 15);

    test('a week goes back seven days', () {
      expect(StatisticsPeriod.week.cutoff(now), DateTime(2026, 6, 8));
    });

    test('a month goes back thirty days', () {
      expect(StatisticsPeriod.month.cutoff(now), DateTime(2026, 5, 16));
    });

    test('a year goes back three hundred and sixty-five days', () {
      expect(StatisticsPeriod.year.cutoff(now), DateTime(2025, 6, 15));
    });

    test('all time has no lower bound', () {
      expect(StatisticsPeriod.allTime.cutoff(now), isNull);
    });
  });

  group('the view model', () {
    test('starts on the last week', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(statisticsPeriodViewModelProvider),
        StatisticsPeriod.week,
      );
    });

    test('reports the period currently shown', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final viewModel = container.read(
        statisticsPeriodViewModelProvider.notifier,
      );

      expect(viewModel.period, StatisticsPeriod.week);
    });

    test('switches to another period', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final subscription = container.listen(
        statisticsPeriodViewModelProvider,
        (previous, next) {},
      );
      addTearDown(subscription.close);
      final viewModel = container.read(
        statisticsPeriodViewModelProvider.notifier,
      )..period = StatisticsPeriod.year;

      expect(viewModel.period, StatisticsPeriod.year);
      expect(
        container.read(statisticsPeriodViewModelProvider),
        StatisticsPeriod.year,
      );
    });
  });
}
