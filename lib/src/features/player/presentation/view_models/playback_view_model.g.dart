// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The single source of truth for playback state across the app.
///
/// Consumers should watch narrow slices with `.select` (e.g. only
/// [PlaybackState.playing]) rather than the whole state, since the
/// playback position updates frequently during playback.

@ProviderFor(PlaybackViewModel)
const playbackViewModelProvider = PlaybackViewModelProvider._();

/// The single source of truth for playback state across the app.
///
/// Consumers should watch narrow slices with `.select` (e.g. only
/// [PlaybackState.playing]) rather than the whole state, since the
/// playback position updates frequently during playback.
final class PlaybackViewModelProvider
    extends $StreamNotifierProvider<PlaybackViewModel, PlaybackState> {
  /// The single source of truth for playback state across the app.
  ///
  /// Consumers should watch narrow slices with `.select` (e.g. only
  /// [PlaybackState.playing]) rather than the whole state, since the
  /// playback position updates frequently during playback.
  const PlaybackViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playbackViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playbackViewModelHash();

  @$internal
  @override
  PlaybackViewModel create() => PlaybackViewModel();
}

String _$playbackViewModelHash() => r'0e15ad40ca84f358df12acabb430a68edf042925';

/// The single source of truth for playback state across the app.
///
/// Consumers should watch narrow slices with `.select` (e.g. only
/// [PlaybackState.playing]) rather than the whole state, since the
/// playback position updates frequently during playback.

abstract class _$PlaybackViewModel extends $StreamNotifier<PlaybackState> {
  Stream<PlaybackState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<PlaybackState>, PlaybackState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlaybackState>, PlaybackState>,
              AsyncValue<PlaybackState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
