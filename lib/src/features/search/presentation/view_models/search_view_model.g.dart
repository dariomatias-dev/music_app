// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The search screen's current term, debounced so results aren't
/// recomputed on every keystroke.

@ProviderFor(SearchViewModel)
const searchViewModelProvider = SearchViewModelProvider._();

/// The search screen's current term, debounced so results aren't
/// recomputed on every keystroke.
final class SearchViewModelProvider
    extends $NotifierProvider<SearchViewModel, String> {
  /// The search screen's current term, debounced so results aren't
  /// recomputed on every keystroke.
  const SearchViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchViewModelHash();

  @$internal
  @override
  SearchViewModel create() => SearchViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchViewModelHash() => r'8952680146db623cd72f4841a8c5dd0c2855a488';

/// The search screen's current term, debounced so results aren't
/// recomputed on every keystroke.

abstract class _$SearchViewModel extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
