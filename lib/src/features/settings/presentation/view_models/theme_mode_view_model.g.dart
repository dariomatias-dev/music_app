// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_mode_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the user's selected theme mode, persisting the choice.
///
/// Defaults to [ThemeMode.system] when no explicit choice was made.

@ProviderFor(ThemeModeViewModel)
const themeModeViewModelProvider = ThemeModeViewModelProvider._();

/// Manages the user's selected theme mode, persisting the choice.
///
/// Defaults to [ThemeMode.system] when no explicit choice was made.
final class ThemeModeViewModelProvider
    extends $AsyncNotifierProvider<ThemeModeViewModel, ThemeMode> {
  /// Manages the user's selected theme mode, persisting the choice.
  ///
  /// Defaults to [ThemeMode.system] when no explicit choice was made.
  const ThemeModeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeViewModelHash();

  @$internal
  @override
  ThemeModeViewModel create() => ThemeModeViewModel();
}

String _$themeModeViewModelHash() =>
    r'12763fd0cb9d51312d983f41a6f6edfaa39b98f8';

/// Manages the user's selected theme mode, persisting the choice.
///
/// Defaults to [ThemeMode.system] when no explicit choice was made.

abstract class _$ThemeModeViewModel extends $AsyncNotifier<ThemeMode> {
  FutureOr<ThemeMode> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<ThemeMode>, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ThemeMode>, ThemeMode>,
              AsyncValue<ThemeMode>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
