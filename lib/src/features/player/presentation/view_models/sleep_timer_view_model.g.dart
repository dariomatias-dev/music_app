// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_timer_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether a sleep timer is active, pausing playback once it fires.
///
/// Kept alive across navigation, so leaving and returning to the playback
/// screen doesn't cancel a running timer.

@ProviderFor(SleepTimerViewModel)
const sleepTimerViewModelProvider = SleepTimerViewModelProvider._();

/// Whether a sleep timer is active, pausing playback once it fires.
///
/// Kept alive across navigation, so leaving and returning to the playback
/// screen doesn't cancel a running timer.
final class SleepTimerViewModelProvider
    extends $NotifierProvider<SleepTimerViewModel, bool> {
  /// Whether a sleep timer is active, pausing playback once it fires.
  ///
  /// Kept alive across navigation, so leaving and returning to the playback
  /// screen doesn't cancel a running timer.
  const SleepTimerViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sleepTimerViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sleepTimerViewModelHash();

  @$internal
  @override
  SleepTimerViewModel create() => SleepTimerViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$sleepTimerViewModelHash() =>
    r'3248c731a477f1d416f2fcf7749cd6153b25bd80';

/// Whether a sleep timer is active, pausing playback once it fires.
///
/// Kept alive across navigation, so leaving and returning to the playback
/// screen doesn't cancel a running timer.

abstract class _$SleepTimerViewModel extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
