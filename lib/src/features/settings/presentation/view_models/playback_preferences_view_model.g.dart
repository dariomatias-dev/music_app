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
/// every track transition. Also mirrors [PlaybackPreferences.hapticsEnabled]
/// onto `Pressable.hapticsEnabled`, since the design system has no access
/// to app-level preferences of its own.

@ProviderFor(PlaybackPreferencesViewModel)
const playbackPreferencesViewModelProvider =
    PlaybackPreferencesViewModelProvider._();

/// Manages the user's playback preferences, persisting each choice.
///
/// Kept alive (rather than the default per-widget lifetime) since it's
/// read from outside any UI subscription, when a new queue starts and on
/// every track transition. Also mirrors [PlaybackPreferences.hapticsEnabled]
/// onto `Pressable.hapticsEnabled`, since the design system has no access
/// to app-level preferences of its own.
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
  /// every track transition. Also mirrors [PlaybackPreferences.hapticsEnabled]
  /// onto `Pressable.hapticsEnabled`, since the design system has no access
  /// to app-level preferences of its own.
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
    r'637a6ade5461a4604015d8b84e1ccef5cb823a09';

/// Manages the user's playback preferences, persisting each choice.
///
/// Kept alive (rather than the default per-widget lifetime) since it's
/// read from outside any UI subscription, when a new queue starts and on
/// every track transition. Also mirrors [PlaybackPreferences.hapticsEnabled]
/// onto `Pressable.hapticsEnabled`, since the design system has no access
/// to app-level preferences of its own.

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
