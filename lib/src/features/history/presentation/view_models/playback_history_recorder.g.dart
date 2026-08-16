// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_history_recorder.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Watches playback and records how long each queued track is actually
/// played, so [PlayHistoryRepository] backs both recently-played and future
/// statistics.
///
/// Instantiated once at app start (see `SplashScreen`) and kept alive for
/// the app's lifetime; it has no state or UI of its own to expose.

@ProviderFor(PlaybackHistoryRecorder)
const playbackHistoryRecorderProvider = PlaybackHistoryRecorderProvider._();

/// Watches playback and records how long each queued track is actually
/// played, so [PlayHistoryRepository] backs both recently-played and future
/// statistics.
///
/// Instantiated once at app start (see `SplashScreen`) and kept alive for
/// the app's lifetime; it has no state or UI of its own to expose.
final class PlaybackHistoryRecorderProvider
    extends $NotifierProvider<PlaybackHistoryRecorder, void> {
  /// Watches playback and records how long each queued track is actually
  /// played, so [PlayHistoryRepository] backs both recently-played and future
  /// statistics.
  ///
  /// Instantiated once at app start (see `SplashScreen`) and kept alive for
  /// the app's lifetime; it has no state or UI of its own to expose.
  const PlaybackHistoryRecorderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playbackHistoryRecorderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playbackHistoryRecorderHash();

  @$internal
  @override
  PlaybackHistoryRecorder create() => PlaybackHistoryRecorder();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$playbackHistoryRecorderHash() =>
    r'b66a3968eca1c1e4f79de10277536c3a3cddbc72';

/// Watches playback and records how long each queued track is actually
/// played, so [PlayHistoryRepository] backs both recently-played and future
/// statistics.
///
/// Instantiated once at app start (see `SplashScreen`) and kept alive for
/// the app's lifetime; it has no state or UI of its own to expose.

abstract class _$PlaybackHistoryRecorder extends $Notifier<void> {
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
