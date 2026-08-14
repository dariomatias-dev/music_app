// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_screen_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The track currently loaded for the playback screen, or `null` when
/// nothing is playing.

@ProviderFor(PlaybackScreenViewModel)
const playbackScreenViewModelProvider = PlaybackScreenViewModelProvider._();

/// The track currently loaded for the playback screen, or `null` when
/// nothing is playing.
final class PlaybackScreenViewModelProvider
    extends $NotifierProvider<PlaybackScreenViewModel, QueueMediaItem?> {
  /// The track currently loaded for the playback screen, or `null` when
  /// nothing is playing.
  const PlaybackScreenViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playbackScreenViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playbackScreenViewModelHash();

  @$internal
  @override
  PlaybackScreenViewModel create() => PlaybackScreenViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QueueMediaItem? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QueueMediaItem?>(value),
    );
  }
}

String _$playbackScreenViewModelHash() =>
    r'0cdca56f3c10ffe3459e2dc930254348731da817';

/// The track currently loaded for the playback screen, or `null` when
/// nothing is playing.

abstract class _$PlaybackScreenViewModel extends $Notifier<QueueMediaItem?> {
  QueueMediaItem? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<QueueMediaItem?, QueueMediaItem?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<QueueMediaItem?, QueueMediaItem?>,
              QueueMediaItem?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
