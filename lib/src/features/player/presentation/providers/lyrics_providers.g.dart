// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Resolves and caches the lyrics for the track at [filePath].

@ProviderFor(lyrics)
const lyricsProvider = LyricsFamily._();

/// Resolves and caches the lyrics for the track at [filePath].

final class LyricsProvider
    extends $FunctionalProvider<AsyncValue<Lyrics>, Lyrics, FutureOr<Lyrics>>
    with $FutureModifier<Lyrics>, $FutureProvider<Lyrics> {
  /// Resolves and caches the lyrics for the track at [filePath].
  const LyricsProvider._({
    required LyricsFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'lyricsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lyricsHash();

  @override
  String toString() {
    return r'lyricsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Lyrics> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Lyrics> create(Ref ref) {
    final argument = this.argument as (String, String);
    return lyrics(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is LyricsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lyricsHash() => r'97e6fd75a8f70c2898430c1ba15cf571c5e5f0de';

/// Resolves and caches the lyrics for the track at [filePath].

final class LyricsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Lyrics>, (String, String)> {
  const LyricsFamily._()
    : super(
        retry: null,
        name: r'lyricsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Resolves and caches the lyrics for the track at [filePath].

  LyricsProvider call(String trackId, String filePath) =>
      LyricsProvider._(argument: (trackId, filePath), from: this);

  @override
  String toString() => r'lyricsProvider';
}
