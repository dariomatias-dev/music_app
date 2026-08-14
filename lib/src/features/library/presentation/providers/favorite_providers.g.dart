// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Watches whether the track with [trackId] is favorited.

@ProviderFor(isFavorite)
const isFavoriteProvider = IsFavoriteFamily._();

/// Watches whether the track with [trackId] is favorited.

final class IsFavoriteProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Watches whether the track with [trackId] is favorited.
  const IsFavoriteProvider._({
    required IsFavoriteFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isFavoriteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isFavoriteHash();

  @override
  String toString() {
    return r'isFavoriteProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    final argument = this.argument as String;
    return isFavorite(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IsFavoriteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isFavoriteHash() => r'49a1ec9850e0f9279da8ea5ff93af7b3946e978b';

/// Watches whether the track with [trackId] is favorited.

final class IsFavoriteFamily extends $Family
    with $FunctionalFamilyOverride<Stream<bool>, String> {
  const IsFavoriteFamily._()
    : super(
        retry: null,
        name: r'isFavoriteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Watches whether the track with [trackId] is favorited.

  IsFavoriteProvider call(String trackId) =>
      IsFavoriteProvider._(argument: trackId, from: this);

  @override
  String toString() => r'isFavoriteProvider';
}
