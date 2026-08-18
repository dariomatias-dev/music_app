// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_track_sort_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The current playlist screen's sort order.

@ProviderFor(PlaylistTrackSortViewModel)
const playlistTrackSortViewModelProvider =
    PlaylistTrackSortViewModelProvider._();

/// The current playlist screen's sort order.
final class PlaylistTrackSortViewModelProvider
    extends $NotifierProvider<PlaylistTrackSortViewModel, PlaylistTrackSort> {
  /// The current playlist screen's sort order.
  const PlaylistTrackSortViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playlistTrackSortViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playlistTrackSortViewModelHash();

  @$internal
  @override
  PlaylistTrackSortViewModel create() => PlaylistTrackSortViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlaylistTrackSort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlaylistTrackSort>(value),
    );
  }
}

String _$playlistTrackSortViewModelHash() =>
    r'1d36ad401416d23ec78aad7bd16ca18ffafcf2db';

/// The current playlist screen's sort order.

abstract class _$PlaylistTrackSortViewModel
    extends $Notifier<PlaylistTrackSort> {
  PlaylistTrackSort build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PlaylistTrackSort, PlaylistTrackSort>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlaylistTrackSort, PlaylistTrackSort>,
              PlaylistTrackSort,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
