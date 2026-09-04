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
import 'package:music_app/src/core/permissions/media_permission_service.dart';
import 'package:music_app/src/core/permissions/notification_permission_service.dart';
import 'package:music_app/src/core/permissions/permission_providers.dart';
import 'package:music_app/src/core/services/id_generator/uuid_v7_generator.dart';
import 'package:music_app/src/core/storage/shared_preferences_storage.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/history/data/repositories/play_history_repository_impl.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source_impl.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/player/presentation/widgets/mini_player.dart';
import 'package:music_app/src/features/playlist/data/repositories/playlist_repository_impl.dart';
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
      const idGenerator = UuidV7Generator();
      final library = LibraryLocalDataSourceImpl(database);
      final playlists = PlaylistRepositoryImpl(database, idGenerator);
      final history = PlayHistoryRepositoryImpl(database, idGenerator);

      final artists = [
        const Artist(
          id: 'artist-1',
          sourceId: 'charcoal',
          name: 'Charcoal',
          albumCount: 1,
          trackCount: 4,
        ),
        const Artist(
          id: 'artist-2',
          sourceId: 'night-bloom',
          name: 'Night Bloom',
          albumCount: 1,
          trackCount: 3,
        ),
        const Artist(
          id: 'artist-3',
          sourceId: 'solar-drift',
          name: 'Solar Drift',
          albumCount: 1,
          trackCount: 3,
        ),
      ];
      for (final artist in artists) {
        await library.upsertArtist(artist);
      }

      final albums = [
        const Album(
          id: 'album-1',
          sourceId: 'charcoal::chill-vibes',
          title: 'Chill Vibes',
          artistId: 'artist-1',
          trackCount: 4,
          totalDuration: Duration(minutes: 15),
        ),
        const Album(
          id: 'album-2',
          sourceId: 'night-bloom::afterglow',
          title: 'Afterglow',
          artistId: 'artist-2',
          trackCount: 3,
          totalDuration: Duration(minutes: 12),
        ),
        const Album(
          id: 'album-3',
          sourceId: 'solar-drift::horizon-line',
          title: 'Horizon Line',
          artistId: 'artist-3',
          trackCount: 3,
          totalDuration: Duration(minutes: 11),
        ),
      ];
      for (final album in albums) {
        await library.upsertAlbum(album);
      }

      Track buildTrack({
        required String id,
        required String title,
        required String artistId,
        required String albumId,
      }) => Track(
        id: id,
        sourceId: id,
        filePath: '/music/${_folderForAlbum(albumId)}/$id.mp3',
        title: title,
        artistId: artistId,
        albumId: albumId,
        duration: const Duration(minutes: 4),
        format: 'mp3',
        fileSize: 4 * 1024 * 1024,
        hasEmbeddedArtwork: false,
        dateAdded: DateTime.now(),
        dateModified: DateTime.now(),
      );

      final tracks = [
        buildTrack(
          id: 'track-1',
          title: 'Night Drive',
          artistId: 'artist-1',
          albumId: 'album-1',
        ),
        buildTrack(
          id: 'track-2',
          title: 'Slow Fade',
          artistId: 'artist-1',
          albumId: 'album-1',
        ),
        buildTrack(
          id: 'track-3',
          title: 'Warm Static',
          artistId: 'artist-1',
          albumId: 'album-1',
        ),
        buildTrack(
          id: 'track-4',
          title: 'Glass Hours',
          artistId: 'artist-1',
          albumId: 'album-1',
        ),
        buildTrack(
          id: 'track-5',
          title: 'Afterglow',
          artistId: 'artist-2',
          albumId: 'album-2',
        ),
        buildTrack(
          id: 'track-6',
          title: 'Paper Moon',
          artistId: 'artist-2',
          albumId: 'album-2',
        ),
        buildTrack(
          id: 'track-7',
          title: 'Low Tide',
          artistId: 'artist-2',
          albumId: 'album-2',
        ),
        buildTrack(
          id: 'track-8',
          title: 'Horizon Line',
          artistId: 'artist-3',
          albumId: 'album-3',
        ),
        buildTrack(
          id: 'track-9',
          title: 'Ember Sky',
          artistId: 'artist-3',
          albumId: 'album-3',
        ),
        buildTrack(
          id: 'track-10',
          title: 'Halflight',
          artistId: 'artist-3',
          albumId: 'album-3',
        ),
      ];
      for (final track in tracks) {
        await library.upsertTrack(track);
      }

      for (final trackId in ['track-1', 'track-5', 'track-8']) {
        await database.favoriteDao.upsertOne(
          FavoriteTableCompanion.insert(
            id: 'favorite-$trackId',
            trackId: trackId,
            createdAt: DateTime.now(),
          ),
        );
      }

      final windDownId = await playlists.createPlaylist('Evening Wind Down');
      await playlists.setPlaylistTracks(windDownId, [
        'track-1',
        'track-2',
        'track-5',
        'track-8',
        'track-9',
      ]);
      final focusId = await playlists.createPlaylist('Focus');
      await playlists.setPlaylistTracks(focusId, [
        'track-3',
        'track-6',
        'track-10',
      ]);

      final now = DateTime.now();
      for (final (trackId, daysAgo) in [
        ('track-1', 0),
        ('track-5', 1),
        ('track-8', 1),
        ('track-2', 2),
        ('track-9', 3),
        ('track-1', 4),
      ]) {
        await history.recordPlay(
          trackId: trackId,
          startedAt: now.subtract(Duration(days: daysAgo)),
          playedDuration: const Duration(minutes: 4),
          completed: true,
        );
      }

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

/// The folder each seeded track's fake file path is placed under, purely
/// for cosmetic variety in the Storage screenshot.
String _folderForAlbum(String albumId) => switch (albumId) {
  'album-1' => 'chill-vibes',
  'album-2' => 'afterglow',
  _ => 'horizon-line',
};
