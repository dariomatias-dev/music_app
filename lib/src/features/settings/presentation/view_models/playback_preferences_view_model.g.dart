// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_preferences_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the user's playback preferences, persisting each choice.
///
/// Kept alive (rather than the default per-widget lifetime) since it's
/// read from outside any UI subscription, when a new queue starts and on
/// every track transition.

@ProviderFor(PlaybackPreferencesViewModel)
const playbackPreferencesViewModelProvider =
    PlaybackPreferencesViewModelProvider._();

/// Manages the user's playback preferences, persisting each choice.
///
/// Kept alive (rather than the default per-widget lifetime) since it's
/// read from outside any UI subscription, when a new queue starts and on
/// every track transition.
final class PlaybackPreferencesViewModelProvider
    extends
        $AsyncNotifierProvider<
          PlaybackPreferencesViewModel,
          PlaybackPreferences
        > {
  /// Manages the user's playback preferences, persisting each choice.
  ///
  /// Kept alive (rather than the default per-widget lifetime) since it's
  /// read from outside any UI subscription, when a new queue starts and on
  /// every track transition.
  const PlaybackPreferencesViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playbackPreferencesViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playbackPreferencesViewModelHash();

  @$internal
  @override
  PlaybackPreferencesViewModel create() => PlaybackPreferencesViewModel();
}

String _$playbackPreferencesViewModelHash() =>
    r'2c90b16a26461071dbf80901291c6457877ff5e9';

/// Manages the user's playback preferences, persisting each choice.
///
/// Kept alive (rather than the default per-widget lifetime) since it's
/// read from outside any UI subscription, when a new queue starts and on
/// every track transition.

abstract class _$PlaybackPreferencesViewModel
    extends $AsyncNotifier<PlaybackPreferences> {
  FutureOr<PlaybackPreferences> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<PlaybackPreferences>, PlaybackPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlaybackPreferences>, PlaybackPreferences>,
              AsyncValue<PlaybackPreferences>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
