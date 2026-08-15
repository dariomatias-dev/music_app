// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_period_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which [StatisticsPeriod] the statistics screen is currently showing.

@ProviderFor(StatisticsPeriodViewModel)
const statisticsPeriodViewModelProvider = StatisticsPeriodViewModelProvider._();

/// Which [StatisticsPeriod] the statistics screen is currently showing.
final class StatisticsPeriodViewModelProvider
    extends $NotifierProvider<StatisticsPeriodViewModel, StatisticsPeriod> {
  /// Which [StatisticsPeriod] the statistics screen is currently showing.
  const StatisticsPeriodViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statisticsPeriodViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statisticsPeriodViewModelHash();

  @$internal
  @override
  StatisticsPeriodViewModel create() => StatisticsPeriodViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatisticsPeriod value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatisticsPeriod>(value),
    );
  }
}

String _$statisticsPeriodViewModelHash() =>
    r'0fbcbedd82bed665ce8d85efbf8712e04a717e4a';

/// Which [StatisticsPeriod] the statistics screen is currently showing.

abstract class _$StatisticsPeriodViewModel extends $Notifier<StatisticsPeriod> {
  StatisticsPeriod build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<StatisticsPeriod, StatisticsPeriod>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StatisticsPeriod, StatisticsPeriod>,
              StatisticsPeriod,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
