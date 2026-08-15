import 'package:flutter/widgets.dart';

/// The display name of [locale] in its own language.
///
/// Covers exactly the app's translated locales; anything else falls back
/// to English.
String languageDisplayName(Locale locale) {
  return switch (locale.languageCode) {
    'es' => 'Español',
    'pt' => 'Português',
    'zh' => '中文',
    _ => 'English',
  };
}
