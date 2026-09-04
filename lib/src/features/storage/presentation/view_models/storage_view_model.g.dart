// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Runs the storage screen's operations, exposing whether one is in
/// flight so the screen can disable itself while it runs.
///
/// Every method returns a [StorageOutcome] rather than throwing, and
/// reports the cause it swallowed to the app's `ErrorReporter`: the screen
/// has one sentence to say about any of these failures, and the detail
/// that sentence leaves out would otherwise be lost.

@ProviderFor(StorageViewModel)
const storageViewModelProvider = StorageViewModelProvider._();

/// Runs the storage screen's operations, exposing whether one is in
/// flight so the screen can disable itself while it runs.
///
/// Every method returns a [StorageOutcome] rather than throwing, and
/// reports the cause it swallowed to the app's `ErrorReporter`: the screen
/// has one sentence to say about any of these failures, and the detail
/// that sentence leaves out would otherwise be lost.
final class StorageViewModelProvider
    extends $NotifierProvider<StorageViewModel, bool> {
  /// Runs the storage screen's operations, exposing whether one is in
  /// flight so the screen can disable itself while it runs.
  ///
  /// Every method returns a [StorageOutcome] rather than throwing, and
  /// reports the cause it swallowed to the app's `ErrorReporter`: the screen
  /// has one sentence to say about any of these failures, and the detail
  /// that sentence leaves out would otherwise be lost.
  const StorageViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageViewModelHash();

  @$internal
  @override
  StorageViewModel create() => StorageViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$storageViewModelHash() => r'8c57b8378a85f7019dbf6a7518cb97f84835535d';

/// Runs the storage screen's operations, exposing whether one is in
/// flight so the screen can disable itself while it runs.
///
/// Every method returns a [StorageOutcome] rather than throwing, and
/// reports the cause it swallowed to the app's `ErrorReporter`: the screen
/// has one sentence to say about any of these failures, and the detail
/// that sentence leaves out would otherwise be lost.

abstract class _$StorageViewModel extends $Notifier<bool> {
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
