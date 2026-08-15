import 'package:flutter/material.dart';
import 'package:music_app/src/core/constants/preference_keys.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_view_model.g.dart';

/// Manages the user's selected theme mode, persisting the choice.
///
/// Defaults to [ThemeMode.system] when no explicit choice was made.
@riverpod
class ThemeModeViewModel extends _$ThemeModeViewModel {
  @override
  Future<ThemeMode> build() async {
    final name = await ref
        .read(keyValueStorageProvider)
        .getString(PreferenceKeys.themeMode);
    return name == null ? ThemeMode.system : ThemeMode.values.byName(name);
  }

  /// Selects [mode] and persists the choice.
  Future<void> setThemeMode(ThemeMode mode) async {
    await ref
        .read(keyValueStorageProvider)
        .setString(PreferenceKeys.themeMode, mode.name);
    state = AsyncData(mode);
  }
}
