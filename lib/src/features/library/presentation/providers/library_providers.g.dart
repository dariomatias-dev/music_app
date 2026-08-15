// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The artist with the given id, or `null` if it isn't indexed.

@ProviderFor(artistById)
const artistByIdProvider = ArtistByIdFamily._();

/// The artist with the given id, or `null` if it isn't indexed.

final class ArtistByIdProvider
    extends $FunctionalProvider<Artist?, Artist?, Artist?>
    with $Provider<Artist?> {
  /// The artist with the given id, or `null` if it isn't indexed.
  const ArtistByIdProvider._({
    required ArtistByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'artistByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$artistByIdHash();

  @override
  String toString() {
    return r'artistByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Artist?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Artist? create(Ref ref) {
    final argument = this.argument as String;
    return artistById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Artist? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Artist?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ArtistByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$artistByIdHash() => r'e07c9abcf65c3fedc15fbeea292fd8b9e00a49ff';

/// The artist with the given id, or `null` if it isn't indexed.

final class ArtistByIdFamily extends $Family
    with $FunctionalFamilyOverride<Artist?, String> {
  const ArtistByIdFamily._()
    : super(
        retry: null,
        name: r'artistByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The artist with the given id, or `null` if it isn't indexed.

  ArtistByIdProvider call(String artistId) =>
      ArtistByIdProvider._(argument: artistId, from: this);

  @override
  String toString() => r'artistByIdProvider';
}

/// Every album by the artist with the given id, ordered alphabetically.

@ProviderFor(artistAlbums)
const artistAlbumsProvider = ArtistAlbumsFamily._();

/// Every album by the artist with the given id, ordered alphabetically.

final class ArtistAlbumsProvider
    extends $FunctionalProvider<List<Album>, List<Album>, List<Album>>
    with $Provider<List<Album>> {
  /// Every album by the artist with the given id, ordered alphabetically.
  const ArtistAlbumsProvider._({
    required ArtistAlbumsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'artistAlbumsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$artistAlbumsHash();

  @override
  String toString() {
    return r'artistAlbumsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Album>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Album> create(Ref ref) {
    final argument = this.argument as String;
    return artistAlbums(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Album> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Album>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ArtistAlbumsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$artistAlbumsHash() => r'7ef929e2f127a90361349842ced4ca4f057cbb85';

/// Every album by the artist with the given id, ordered alphabetically.

final class ArtistAlbumsFamily extends $Family
    with $FunctionalFamilyOverride<List<Album>, String> {
  const ArtistAlbumsFamily._()
    : super(
        retry: null,
        name: r'artistAlbumsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Every album by the artist with the given id, ordered alphabetically.

  ArtistAlbumsProvider call(String artistId) =>
      ArtistAlbumsProvider._(argument: artistId, from: this);

  @override
  String toString() => r'artistAlbumsProvider';
}

/// Every non-missing track by the artist with the given id (their whole
/// discography), ordered by album title, then disc and track number.

@ProviderFor(artistTracks)
const artistTracksProvider = ArtistTracksFamily._();

/// Every non-missing track by the artist with the given id (their whole
/// discography), ordered by album title, then disc and track number.

final class ArtistTracksProvider
    extends $FunctionalProvider<List<Track>, List<Track>, List<Track>>
    with $Provider<List<Track>> {
  /// Every non-missing track by the artist with the given id (their whole
  /// discography), ordered by album title, then disc and track number.
  const ArtistTracksProvider._({
    required ArtistTracksFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'artistTracksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$artistTracksHash();

  @override
  String toString() {
    return r'artistTracksProvider'
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
    return artistTracks(ref, argument);
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
    return other is ArtistTracksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$artistTracksHash() => r'a1546c713f7b7faad4a18a3a538b5e8092e49bba';

/// Every non-missing track by the artist with the given id (their whole
/// discography), ordered by album title, then disc and track number.

final class ArtistTracksFamily extends $Family
    with $FunctionalFamilyOverride<List<Track>, String> {
  const ArtistTracksFamily._()
    : super(
        retry: null,
        name: r'artistTracksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Every non-missing track by the artist with the given id (their whole
  /// discography), ordered by album title, then disc and track number.

  ArtistTracksProvider call(String artistId) =>
      ArtistTracksProvider._(argument: artistId, from: this);

  @override
  String toString() => r'artistTracksProvider';
}

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
