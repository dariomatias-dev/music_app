// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_transition_effects.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Applies the user's gapless/crossfade preference whenever the current
/// queue item changes: either a brief pause (gapless disabled) or a
/// volume fade-in (crossfade enabled). Does nothing when gapless is
/// enabled and crossfade is off, matching the engine's own default
/// behavior.
///
/// Instantiated once at app start (see `SplashScreen`) and kept alive for
/// the app's lifetime; it has no state or UI of its own to expose.

@ProviderFor(PlaybackTransitionEffects)
const playbackTransitionEffectsProvider = PlaybackTransitionEffectsProvider._();

/// Applies the user's gapless/crossfade preference whenever the current
/// queue item changes: either a brief pause (gapless disabled) or a
/// volume fade-in (crossfade enabled). Does nothing when gapless is
/// enabled and crossfade is off, matching the engine's own default
/// behavior.
///
/// Instantiated once at app start (see `SplashScreen`) and kept alive for
/// the app's lifetime; it has no state or UI of its own to expose.
final class PlaybackTransitionEffectsProvider
    extends $NotifierProvider<PlaybackTransitionEffects, void> {
  /// Applies the user's gapless/crossfade preference whenever the current
  /// queue item changes: either a brief pause (gapless disabled) or a
  /// volume fade-in (crossfade enabled). Does nothing when gapless is
  /// enabled and crossfade is off, matching the engine's own default
  /// behavior.
  ///
  /// Instantiated once at app start (see `SplashScreen`) and kept alive for
  /// the app's lifetime; it has no state or UI of its own to expose.
  const PlaybackTransitionEffectsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playbackTransitionEffectsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playbackTransitionEffectsHash();

  @$internal
  @override
  PlaybackTransitionEffects create() => PlaybackTransitionEffects();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$playbackTransitionEffectsHash() =>
    r'2468e16b0b48f8875c1648e946302b387705c43a';

/// Applies the user's gapless/crossfade preference whenever the current
/// queue item changes: either a brief pause (gapless disabled) or a
/// volume fade-in (crossfade enabled). Does nothing when gapless is
/// enabled and crossfade is off, matching the engine's own default
/// behavior.
///
/// Instantiated once at app start (see `SplashScreen`) and kept alive for
/// the app's lifetime; it has no state or UI of its own to expose.

abstract class _$PlaybackTransitionEffects extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
