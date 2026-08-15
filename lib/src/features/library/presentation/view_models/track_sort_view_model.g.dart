// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_sort_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Tracks tab's current sort order.

@ProviderFor(TrackSortViewModel)
const trackSortViewModelProvider = TrackSortViewModelProvider._();

/// The Tracks tab's current sort order.
final class TrackSortViewModelProvider
    extends $NotifierProvider<TrackSortViewModel, TrackSort> {
  /// The Tracks tab's current sort order.
  const TrackSortViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackSortViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackSortViewModelHash();

  @$internal
  @override
  TrackSortViewModel create() => TrackSortViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrackSort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrackSort>(value),
    );
  }
}

String _$trackSortViewModelHash() =>
    r'd06f3e6f00c6979991f1bdda2bf2cf61c904630d';

/// The Tracks tab's current sort order.

abstract class _$TrackSortViewModel extends $Notifier<TrackSort> {
  TrackSort build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TrackSort, TrackSort>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TrackSort, TrackSort>,
              TrackSort,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
