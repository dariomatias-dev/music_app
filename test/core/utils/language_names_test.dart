import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/utils/language_names.dart';

void main() {
  test('names each supported locale in its own language', () {
    expect(languageDisplayName(const Locale('es')), 'Español');
    expect(languageDisplayName(const Locale('pt')), 'Português');
    expect(languageDisplayName(const Locale('zh')), '中文');
  });

  test('falls back to English for an unsupported locale', () {
    expect(languageDisplayName(const Locale('en')), 'English');
    expect(languageDisplayName(const Locale('fr')), 'English');
  });
}
