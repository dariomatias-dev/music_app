// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which [LibrarySection] the library screen is currently showing.

@ProviderFor(LibraryViewModel)
const libraryViewModelProvider = LibraryViewModelProvider._();

/// Which [LibrarySection] the library screen is currently showing.
final class LibraryViewModelProvider
    extends $NotifierProvider<LibraryViewModel, LibrarySection> {
  /// Which [LibrarySection] the library screen is currently showing.
  const LibraryViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryViewModelHash();

  @$internal
  @override
  LibraryViewModel create() => LibraryViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibrarySection value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibrarySection>(value),
    );
  }
}

String _$libraryViewModelHash() => r'9483a787d1599e7737fa33835926166c828dd6c7';

/// Which [LibrarySection] the library screen is currently showing.

abstract class _$LibraryViewModel extends $Notifier<LibrarySection> {
  LibrarySection build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LibrarySection, LibrarySection>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LibrarySection, LibrarySection>,
              LibrarySection,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
