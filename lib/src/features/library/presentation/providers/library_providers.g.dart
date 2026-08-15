// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The album with the given id, or `null` if it isn't indexed.

@ProviderFor(albumById)
const albumByIdProvider = AlbumByIdFamily._();

/// The album with the given id, or `null` if it isn't indexed.

final class AlbumByIdProvider
    extends $FunctionalProvider<Album?, Album?, Album?>
    with $Provider<Album?> {
  /// The album with the given id, or `null` if it isn't indexed.
  const AlbumByIdProvider._({
    required AlbumByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'albumByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$albumByIdHash();

  @override
  String toString() {
    return r'albumByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Album?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Album? create(Ref ref) {
    final argument = this.argument as String;
    return albumById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Album? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Album?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumByIdHash() => r'614bd694beb16b94e6a992f49cd5e30469bee041';

/// The album with the given id, or `null` if it isn't indexed.

final class AlbumByIdFamily extends $Family
    with $FunctionalFamilyOverride<Album?, String> {
  const AlbumByIdFamily._()
    : super(
        retry: null,
        name: r'albumByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The album with the given id, or `null` if it isn't indexed.

  AlbumByIdProvider call(String albumId) =>
      AlbumByIdProvider._(argument: albumId, from: this);

  @override
  String toString() => r'albumByIdProvider';
}

/// Every non-missing track on the album with the given id, ordered by disc
/// and track number.

@ProviderFor(albumTracks)
const albumTracksProvider = AlbumTracksFamily._();

/// Every non-missing track on the album with the given id, ordered by disc
/// and track number.

final class AlbumTracksProvider
    extends $FunctionalProvider<List<Track>, List<Track>, List<Track>>
    with $Provider<List<Track>> {
  /// Every non-missing track on the album with the given id, ordered by disc
  /// and track number.
  const AlbumTracksProvider._({
    required AlbumTracksFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'albumTracksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$albumTracksHash();

  @override
  String toString() {
    return r'albumTracksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Track>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Track> create(Ref ref) {
    final argument = this.argument as String;
    return albumTracks(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Track> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Track>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumTracksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumTracksHash() => r'ec8945c381a3d8df86e68c92b4b3fd7c392c34d3';

/// Every non-missing track on the album with the given id, ordered by disc
/// and track number.

final class AlbumTracksFamily extends $Family
    with $FunctionalFamilyOverride<List<Track>, String> {
  const AlbumTracksFamily._()
    : super(
        retry: null,
        name: r'albumTracksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Every non-missing track on the album with the given id, ordered by disc
  /// and track number.

  AlbumTracksProvider call(String albumId) =>
      AlbumTracksProvider._(argument: albumId, from: this);

  @override
  String toString() => r'albumTracksProvider';
}

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
