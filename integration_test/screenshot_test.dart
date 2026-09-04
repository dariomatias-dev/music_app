import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/core/constants/preference_keys.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/core/database/seeds/dev_seeds.dart';
import 'package:music_app/src/core/permissions/media_permission_service.dart';
import 'package:music_app/src/core/permissions/notification_permission_service.dart';
import 'package:music_app/src/core/permissions/permission_providers.dart';
import 'package:music_app/src/core/storage/shared_preferences_storage.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/player/presentation/widgets/mini_player.dart';
import 'package:music_app/src/music_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test/helpers/fake_audio_player_service.dart';

/// One README per locale (README.md, README.es.md, README.pt-BR.md,
/// README.zh.md); each gets its own `screenshots/<folder>` subfolder,
/// named to match.
const _localesToCapture = ['en', 'es', 'pt-BR', 'zh'];

/// Parses a locale arg ('en', 'es', 'pt-BR', ...) into a [Locale].
Locale _parseLocaleArg(String arg) {
  final parts = arg.split('-');
  return parts.length > 1 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
}

/// The same encoding the app's locale settings use to persist a choice, so
/// the seeded storage matches what it expects to read back.
String _encodeLocale(Locale locale) {
  return locale.countryCode == null
      ? locale.languageCode
      : '${locale.languageCode}_${locale.countryCode}';
}

/// Grants access immediately, so the redirect lands straight on Home
/// instead of stopping at the permission screen.
class _FakeGrantedPermissionService implements MediaPermissionService {
  @override
  Future<MediaPermissionStatus> check() async => MediaPermissionStatus.granted;

  @override
  Future<MediaPermissionStatus> request() async =>
      MediaPermissionStatus.granted;

  @override
  Future<void> openSystemSettings() async {}
}

class _FakeGrantedNotificationPermissionService
    implements NotificationPermissionService {
  @override
  Future<NotificationPermissionStatus> check() async =>
      NotificationPermissionStatus.granted;

  @override
  Future<NotificationPermissionStatus> request() async =>
      NotificationPermissionStatus.granted;

  @override
  Future<void> openSystemSettings() async {}
}

/// Pins what the seeded library calls "now", so two captures of the same
/// build produce the same dates, the same listening history and therefore
/// the same images.
final _seedClock = DateTime(2026, 3, 15, 10, 30);

/// Drives the app through its main screens, once per README locale, taking
/// a screenshot of each screen, so marketing assets (READMEs, Play Store
/// listing, official website) can be generated without manually navigating
/// the app.
///
/// A single `flutter drive` install serves every locale — each is its own
/// `testWidgets`, not a separate driver invocation — since installing the
/// app is the slow part.
///
/// Run with:
///   fvm flutter drive \
///     --driver=test_driver/integration_test.dart \
///     --target=integration_test/screenshot_test.dart
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  for (final localeArg in _localesToCapture) {
    testWidgets('capture marketing screenshots ($localeArg)', (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await runDevSeeds(database, clock: () => _seedClock);

      final locale = _parseLocaleArg(localeArg);

      SharedPreferences.setMockInitialValues(const {});
      final storage = SharedPreferencesStorage(
        await SharedPreferences.getInstance(),
      );
      // Pin the locale and theme so labels and colors in every screenshot
      // are predictable, regardless of the driving device's own settings.
      await storage.setString(PreferenceKeys.locale, _encodeLocale(locale));
      await storage.setString(PreferenceKeys.themeMode, 'light');
      await storage.setBool(PreferenceKeys.onboardingCompleted, value: true);

      final playerService = FakeAudioPlayerService();
      final audioHandler = MusicAudioHandler(playerService);
      addTearDown(audioHandler.dispose);

      await binding.convertFlutterSurfaceToImage();

      /// A few widgets (the mini player's artwork, playback progress) drive
      /// looping or position-based animations that never let
      /// `pumpAndSettle` return, so screens are advanced with a fixed
      /// number of pumps instead.
      Future<void> settle() async {
        for (var i = 0; i < 20; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
      }

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            keyValueStorageProvider.overrideWithValue(storage),
            appDatabaseProvider.overrideWithValue(database),
            audioPlayerServiceProvider.overrideWithValue(playerService),
            audioHandlerProvider.overrideWithValue(audioHandler),
            mediaPermissionServiceProvider.overrideWithValue(
              _FakeGrantedPermissionService(),
            ),
            notificationPermissionServiceProvider.overrideWithValue(
              _FakeGrantedNotificationPermissionService(),
            ),
          ],
          child: const MusicApp(),
        ),
      );
      await settle();

      Future<void> shoot(String name) async {
        await settle();
        await binding.takeScreenshot('$localeArg/$name');
      }

      Future<void> goBack() async {
        await tester.tap(find.byIcon(Icons.arrow_back));
        await settle();
      }

      final l10n = await AppLocalizations.delegate.load(locale);

      await shoot('01_home');

      await tester.tap(find.text(l10n.libraryTabLabel));
      await settle();
      await shoot('02_library_playlists');

      await tester.tap(find.text('Evening Wind Down'));
      await settle();
      await shoot('03_playlist_detail');
      await goBack();

      await tester.tap(find.text(l10n.libraryTracksTab));
      await settle();
      await shoot('04_library_tracks');

      await tester.tap(find.text('Night Drive').first);
      await settle();

      await tester.tap(find.byType(MiniPlayer));
      await settle();
      await shoot('05_now_playing');
      await goBack();

      await tester.tap(find.text(l10n.searchTabLabel));
      await settle();
      await shoot('06_search');

      await tester.tap(find.text(l10n.settingsTabLabel));
      await settle();
      await shoot('07_settings');

      await tester.tap(find.text(l10n.storageLabel));
      await settle();
      await shoot('08_storage');
      await goBack();

      await tester.tap(find.text(l10n.statisticsLabel));
      await settle();
      await shoot('09_statistics');
    });
  }
}
