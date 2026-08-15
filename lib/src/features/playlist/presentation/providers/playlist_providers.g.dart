// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Live-updating track ids of the playlist with the given id, in order.

@ProviderFor(playlistTrackIds)
const playlistTrackIdsProvider = PlaylistTrackIdsFamily._();

/// Live-updating track ids of the playlist with the given id, in order.

final class PlaylistTrackIdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          Stream<List<String>>
        >
    with $FutureModifier<List<String>>, $StreamProvider<List<String>> {
  /// Live-updating track ids of the playlist with the given id, in order.
  const PlaylistTrackIdsProvider._({
    required PlaylistTrackIdsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'playlistTrackIdsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playlistTrackIdsHash();

  @override
  String toString() {
    return r'playlistTrackIdsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<String>> create(Ref ref) {
    final argument = this.argument as String;
    return playlistTrackIds(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistTrackIdsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playlistTrackIdsHash() => r'059fc9dd4ff9dd9e2ee4957d178bf898b9ce5750';

/// Live-updating track ids of the playlist with the given id, in order.

final class PlaylistTrackIdsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<String>>, String> {
  const PlaylistTrackIdsFamily._()
    : super(
        retry: null,
        name: r'playlistTrackIdsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Live-updating track ids of the playlist with the given id, in order.

  PlaylistTrackIdsProvider call(String playlistId) =>
      PlaylistTrackIdsProvider._(argument: playlistId, from: this);

  @override
  String toString() => r'playlistTrackIdsProvider';
}

/// Live-updating playlist with the given id, `null` if it doesn't exist.

@ProviderFor(playlistById)
const playlistByIdProvider = PlaylistByIdFamily._();

/// Live-updating playlist with the given id, `null` if it doesn't exist.

final class PlaylistByIdProvider
    extends
        $FunctionalProvider<AsyncValue<Playlist?>, Playlist?, Stream<Playlist?>>
    with $FutureModifier<Playlist?>, $StreamProvider<Playlist?> {
  /// Live-updating playlist with the given id, `null` if it doesn't exist.
  const PlaylistByIdProvider._({
    required PlaylistByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'playlistByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playlistByIdHash();

  @override
  String toString() {
    return r'playlistByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Playlist?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Playlist?> create(Ref ref) {
    final argument = this.argument as String;
    return playlistById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playlistByIdHash() => r'c89c731712f3044054287190376afaae55461219';

/// Live-updating playlist with the given id, `null` if it doesn't exist.

final class PlaylistByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Playlist?>, String> {
  const PlaylistByIdFamily._()
    : super(
        retry: null,
        name: r'playlistByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Live-updating playlist with the given id, `null` if it doesn't exist.

  PlaylistByIdProvider call(String playlistId) =>
      PlaylistByIdProvider._(argument: playlistId, from: this);

  @override
  String toString() => r'playlistByIdProvider';
}
