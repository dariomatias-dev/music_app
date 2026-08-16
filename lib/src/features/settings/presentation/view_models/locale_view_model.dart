import 'package:flutter/widgets.dart';
import 'package:music_app/src/core/constants/preference_keys.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_view_model.g.dart';

/// Manages the user's selected locale, persisting the choice.
///
/// A `null` value means no explicit choice was made; the system locale
/// should be used, falling back to English when unsupported.
@riverpod
class LocaleViewModel extends _$LocaleViewModel {
  @override
  Future<Locale?> build() async {
    final code = await ref
        .read(keyValueStorageProvider)
        .getString(
          PreferenceKeys.locale,
        );
    return code == null ? null : _parseLocale(code);
  }

  /// Selects [locale] and persists the choice.
  Future<void> setLocale(Locale locale) async {
    await ref
        .read(keyValueStorageProvider)
        .setString(PreferenceKeys.locale, _encodeLocale(locale));
    if (!ref.mounted) return;
    state = AsyncData(locale);
  }

  /// Clears the explicit choice, reverting to the system locale.
  Future<void> resetToSystemLocale() async {
    await ref.read(keyValueStorageProvider).remove(PreferenceKeys.locale);
    if (!ref.mounted) return;
    state = const AsyncData(null);
  }

  String _encodeLocale(Locale locale) {
    return locale.countryCode == null
        ? locale.languageCode
        : '${locale.languageCode}_${locale.countryCode}';
  }

  Locale _parseLocale(String code) {
    final parts = code.split('_');
    return parts.length > 1 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
  }
}
