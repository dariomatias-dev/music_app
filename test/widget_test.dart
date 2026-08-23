import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/core/constants/preference_keys.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/core/navigation/route_transitions.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/music_app.dart';

import 'helpers/fake_audio_player_service.dart';
import 'helpers/fake_key_value_storage.dart';

/// Boots the real app over an in-memory database, with [themeMode] and
/// [locale] already persisted.
Future<void> _pumpApp(
  WidgetTester tester, {
  String? themeMode,
  String? locale,
  Brightness platformBrightness = Brightness.light,
}) async {
  final database = AppDatabase(NativeDatabase.memory());
  addTearDown(database.close);

  final storage = FakeKeyValueStorage();
  if (themeMode != null) {
    await storage.setString(PreferenceKeys.themeMode, themeMode);
  }
  if (locale != null) {
    await storage.setString(PreferenceKeys.locale, locale);
  }

  final service = FakeAudioPlayerService();
  final handler = MusicAudioHandler(service);
  addTearDown(handler.dispose);

  tester.platformDispatcher.platformBrightnessTestValue = platformBrightness;
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        keyValueStorageProvider.overrideWithValue(storage),
        audioPlayerServiceProvider.overrideWithValue(service),
        audioHandlerProvider.overrideWithValue(handler),
      ],
      child: const MusicApp(),
    ),
  );
  await tester.pump();
  await tester.pump();
}

/// The theme the app handed to [MaterialApp].
ThemeData _appTheme(WidgetTester tester) =>
    tester.widget<MaterialApp>(find.byType(MaterialApp)).theme!;

void main() {
  testWidgets('builds without throwing', (tester) async {
    await _pumpApp(tester);

    expect(find.byType(MusicApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  group('theme', () {
    testWidgets('follows the platform when set to system', (tester) async {
      await _pumpApp(tester, platformBrightness: Brightness.dark);

      expect(_appTheme(tester).brightness, Brightness.dark);
    });

    testWidgets('stays light when the platform is light and mode is system', (
      tester,
    ) async {
      await _pumpApp(tester);

      expect(_appTheme(tester).brightness, Brightness.light);
    });

    testWidgets('forces light regardless of the platform', (tester) async {
      await _pumpApp(
        tester,
        themeMode: 'light',
        platformBrightness: Brightness.dark,
      );

      expect(_appTheme(tester).brightness, Brightness.light);
    });

    testWidgets('forces dark regardless of the platform', (tester) async {
      await _pumpApp(tester, themeMode: 'dark');

      expect(_appTheme(tester).brightness, Brightness.dark);
    });

    testWidgets('keeps the app page transitions on every mode', (tester) async {
      await _pumpApp(tester, themeMode: 'dark');

      expect(
        _appTheme(tester).pageTransitionsTheme.builders[TargetPlatform.android],
        isA<AppPageTransitionsBuilder>(),
      );
    });
  });

  group('locale', () {
    testWidgets('follows the system when none was chosen', (tester) async {
      await _pumpApp(tester);

      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).locale,
        isNull,
      );
    });

    testWidgets('applies the stored choice', (tester) async {
      await _pumpApp(tester, locale: 'es');

      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).locale,
        const Locale('es'),
      );
    });
  });
}
