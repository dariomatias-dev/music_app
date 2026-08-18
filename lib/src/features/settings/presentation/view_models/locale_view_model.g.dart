// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the user's selected locale, persisting the choice.
///
/// A `null` value means no explicit choice was made; the system locale
/// should be used, falling back to English when unsupported.

@ProviderFor(LocaleViewModel)
const localeViewModelProvider = LocaleViewModelProvider._();

/// Manages the user's selected locale, persisting the choice.
///
/// A `null` value means no explicit choice was made; the system locale
/// should be used, falling back to English when unsupported.
final class LocaleViewModelProvider
    extends $AsyncNotifierProvider<LocaleViewModel, Locale?> {
  /// Manages the user's selected locale, persisting the choice.
  ///
  /// A `null` value means no explicit choice was made; the system locale
  /// should be used, falling back to English when unsupported.
  const LocaleViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeViewModelHash();

  @$internal
  @override
  LocaleViewModel create() => LocaleViewModel();
}

String _$localeViewModelHash() => r'abbc647286e0ab02777a22393ad7e34ece9a6f3b';

/// Manages the user's selected locale, persisting the choice.
///
/// A `null` value means no explicit choice was made; the system locale
/// should be used, falling back to English when unsupported.

abstract class _$LocaleViewModel extends $AsyncNotifier<Locale?> {
  FutureOr<Locale?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Locale?>, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Locale?>, Locale?>,
              AsyncValue<Locale?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
