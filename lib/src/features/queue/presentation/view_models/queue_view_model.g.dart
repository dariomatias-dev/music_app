// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The ordered list of tracks currently loaded into the playback queue.
///
/// Playback state itself (position, playing, current index, shuffle, loop
/// mode) lives in `PlaybackViewModel`; this only tracks which [Track]s are
/// in the queue, so the UI can show track details for the queue and for the
/// currently playing item.

@ProviderFor(QueueViewModel)
const queueViewModelProvider = QueueViewModelProvider._();

/// The ordered list of tracks currently loaded into the playback queue.
///
/// Playback state itself (position, playing, current index, shuffle, loop
/// mode) lives in `PlaybackViewModel`; this only tracks which [Track]s are
/// in the queue, so the UI can show track details for the queue and for the
/// currently playing item.
final class QueueViewModelProvider
    extends $NotifierProvider<QueueViewModel, List<Track>> {
  /// The ordered list of tracks currently loaded into the playback queue.
  ///
  /// Playback state itself (position, playing, current index, shuffle, loop
  /// mode) lives in `PlaybackViewModel`; this only tracks which [Track]s are
  /// in the queue, so the UI can show track details for the queue and for the
  /// currently playing item.
  const QueueViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queueViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queueViewModelHash();

  @$internal
  @override
  QueueViewModel create() => QueueViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Track> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Track>>(value),
    );
  }
}

String _$queueViewModelHash() => r'ff7a48477f3b806fe0efd1279d813a24256c64f3';

/// The ordered list of tracks currently loaded into the playback queue.
///
/// Playback state itself (position, playing, current index, shuffle, loop
/// mode) lives in `PlaybackViewModel`; this only tracks which [Track]s are
/// in the queue, so the UI can show track details for the queue and for the
/// currently playing item.

abstract class _$QueueViewModel extends $Notifier<List<Track>> {
  List<Track> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Track>, List<Track>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Track>, List<Track>>,
              List<Track>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
