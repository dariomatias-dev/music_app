// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every indexed, non-missing track, ordered by the Tracks tab's current
/// sort. Recomputed only when the tracks, artists or sort order change.

@ProviderFor(sortedTracks)
const sortedTracksProvider = SortedTracksProvider._();

/// Every indexed, non-missing track, ordered by the Tracks tab's current
/// sort. Recomputed only when the tracks, artists or sort order change.

final class SortedTracksProvider
    extends $FunctionalProvider<List<Track>, List<Track>, List<Track>>
    with $Provider<List<Track>> {
  /// Every indexed, non-missing track, ordered by the Tracks tab's current
  /// sort. Recomputed only when the tracks, artists or sort order change.
  const SortedTracksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sortedTracksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sortedTracksHash();

  @$internal
  @override
  $ProviderElement<List<Track>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Track> create(Ref ref) {
    return sortedTracks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Track> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Track>>(value),
    );
  }
}

String _$sortedTracksHash() => r'df176ec64ada595520a98e0c3b336591a1a12461';
