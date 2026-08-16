// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The ordered list of items currently loaded into the playback queue,
/// resolved with display metadata (title, artist, artwork).
///
/// Playback state itself (position, playing, current index, shuffle, loop
/// mode) lives in `PlaybackViewModel`; this only tracks what's in the
/// queue, so the UI can show track details for the mini player, the queue
/// screen and the currently playing item.

@ProviderFor(QueueViewModel)
const queueViewModelProvider = QueueViewModelProvider._();

/// The ordered list of items currently loaded into the playback queue,
/// resolved with display metadata (title, artist, artwork).
///
/// Playback state itself (position, playing, current index, shuffle, loop
/// mode) lives in `PlaybackViewModel`; this only tracks what's in the
/// queue, so the UI can show track details for the mini player, the queue
/// screen and the currently playing item.
final class QueueViewModelProvider
    extends $NotifierProvider<QueueViewModel, List<QueueMediaItem>> {
  /// The ordered list of items currently loaded into the playback queue,
  /// resolved with display metadata (title, artist, artwork).
  ///
  /// Playback state itself (position, playing, current index, shuffle, loop
  /// mode) lives in `PlaybackViewModel`; this only tracks what's in the
  /// queue, so the UI can show track details for the mini player, the queue
  /// screen and the currently playing item.
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
  Override overrideWithValue(List<QueueMediaItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<QueueMediaItem>>(value),
    );
  }
}

String _$queueViewModelHash() => r'90d0a742c89cdb2d4a0891261b21cc54f7d9b846';

/// The ordered list of items currently loaded into the playback queue,
/// resolved with display metadata (title, artist, artwork).
///
/// Playback state itself (position, playing, current index, shuffle, loop
/// mode) lives in `PlaybackViewModel`; this only tracks what's in the
/// queue, so the UI can show track details for the mini player, the queue
/// screen and the currently playing item.

abstract class _$QueueViewModel extends $Notifier<List<QueueMediaItem>> {
  List<QueueMediaItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<QueueMediaItem>, List<QueueMediaItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<QueueMediaItem>, List<QueueMediaItem>>,
              List<QueueMediaItem>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
