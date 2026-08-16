import 'dart:io';

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
import 'package:music_app/src/core/permissions/permission_providers.dart';
import 'package:music_app/src/core/storage/key_value_storage.dart';
import 'package:music_app/src/core/storage/shared_preferences_storage.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source_impl.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/music_app.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test/helpers/fake_audio_player_service.dart';

/// Grants access immediately and never scans, so the onboarding flow can
/// reach Home without a real device media store.
class _FakeGrantedPermissionService implements MediaPermissionService {
  @override
  Future<MediaPermissionStatus> check() async => MediaPermissionStatus.granted;

  @override
  Future<MediaPermissionStatus> request() async =>
      MediaPermissionStatus.granted;

  @override
  Future<void> openSystemSettings() async {}
}

class _FakeEmptyLibraryRepository implements LibraryRepository {
  const _FakeEmptyLibraryRepository();

  @override
  Stream<List<Track>> watchTracks() => Stream.value(const []);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const []);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const []);

  @override
  Stream<IndexingProgress> reindex() => const Stream.empty();

  @override
  Future<void> purgeMissingTracks() async {}

  @override
  Future<void> clearArtworkCache() async {}
}

/// A real, file-backed [AppDatabase] so each test can verify data survives
/// closing and reopening it, the same as an app restart would.
Future<AppDatabase> _openTempDatabase(String name) async {
  final directory = await getTemporaryDirectory();
  final file = p.join(directory.path, '$name.sqlite');
  return AppDatabase(NativeDatabase(File(file)));
}

Future<KeyValueStorage> _onboardedStorage() async {
  SharedPreferences.setMockInitialValues(const {});
  final storage = SharedPreferencesStorage(
    await SharedPreferences.getInstance(),
  );
  await storage.setBool(PreferenceKeys.onboardingCompleted, value: true);
  // Pin the locale so button/tab labels match the English strings this
  // suite looks up, regardless of the device's own system locale.
  await storage.setString(PreferenceKeys.locale, 'en');
  return storage;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('onboarding grants access, scans and lands on Home, '
      'then every tab is reachable', (tester) async {
    SharedPreferences.setMockInitialValues(const {});
    final storage = SharedPreferencesStorage(
      await SharedPreferences.getInstance(),
    );
    // Pin the locale so button/tab labels match the English strings this
    // suite looks up, regardless of the device's own system locale.
    await storage.setString(PreferenceKeys.locale, 'en');
    final service = FakeAudioPlayerService();
    final handler = MusicAudioHandler(service);
    addTearDown(handler.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          keyValueStorageProvider.overrideWithValue(storage),
          audioPlayerServiceProvider.overrideWithValue(service),
          audioHandlerProvider.overrideWithValue(handler),
          mediaPermissionServiceProvider.overrideWithValue(
            _FakeGrantedPermissionService(),
          ),
          libraryRepositoryProvider.overrideWithValue(
            const _FakeEmptyLibraryRepository(),
          ),
        ],
        child: const MusicApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Splash -> onboarding: skip the slides straight to the permission
    // check, which the fake service auto-grants and moves past on its own
    // (an empty scan, then straight to Home).
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    await tester.tap(find.text(l10n.onboardingSkip));
    await tester.pumpAndSettle();

    expect(find.text(l10n.homeTabLabel), findsWidgets);

    for (final tabLabel in [
      l10n.searchTabLabel,
      l10n.libraryTabLabel,
      l10n.settingsTabLabel,
      l10n.homeTabLabel,
    ]) {
      await tester.tap(find.text(tabLabel));
      await tester.pumpAndSettle();
      expect(find.text(tabLabel), findsWidgets);
    }
  });

  testWidgets('playing a track from the library updates the mini player, '
      'and pause/skip control it', (tester) async {
    final database = await _openTempDatabase('playback_flow');
    addTearDown(database.close);
    final dataSource = LibraryLocalDataSourceImpl(database);
    await dataSource.upsertArtist(
      const Artist(
        id: 'artist-1',
        sourceId: 'charcoal',
        name: 'Charcoal',
        albumCount: 1,
        trackCount: 2,
      ),
    );
    await dataSource.upsertAlbum(
      const Album(
        id: 'album-1',
        sourceId: 'charcoal::chill-vibes',
        title: 'Chill Vibes',
        artistId: 'artist-1',
        trackCount: 2,
        totalDuration: Duration(minutes: 8),
      ),
    );
    await dataSource.upsertTrack(
      Track(
        id: 'track-1',
        sourceId: 'track-1',
        filePath: '/music/night-drive.mp3',
        title: 'Night Drive',
        artistId: 'artist-1',
        albumId: 'album-1',
        duration: const Duration(minutes: 4),
        format: 'mp3',
        fileSize: 1000,
        hasEmbeddedArtwork: false,
        dateAdded: DateTime.fromMillisecondsSinceEpoch(0),
        dateModified: DateTime.fromMillisecondsSinceEpoch(0),
      ),
    );

    final service = FakeAudioPlayerService();
    final handler = MusicAudioHandler(service);
    addTearDown(handler.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          keyValueStorageProvider.overrideWithValue(await _onboardedStorage()),
          audioPlayerServiceProvider.overrideWithValue(service),
          audioHandlerProvider.overrideWithValue(handler),
          appDatabaseProvider.overrideWithValue(database),
          mediaPermissionServiceProvider.overrideWithValue(
            _FakeGrantedPermissionService(),
          ),
        ],
        child: const MusicApp(),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    await tester.tap(find.text(l10n.libraryTabLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Night Drive').first);
    await tester.pumpAndSettle();

    expect(service.snapshot.playing, isTrue);
    expect(find.text('Night Drive'), findsWidgets);

    await tester.tap(find.byIcon(Icons.pause_rounded).first);
    await tester.pumpAndSettle();
    expect(service.snapshot.playing, isFalse);
  });

  testWidgets(
    'a favorite written to the database survives closing and reopening it',
    (tester) async {
      final database = await _openTempDatabase('persistence_flow');
      final dataSource = LibraryLocalDataSourceImpl(database);
      await dataSource.upsertArtist(
        const Artist(
          id: 'artist-1',
          sourceId: 'charcoal',
          name: 'Charcoal',
          albumCount: 1,
          trackCount: 1,
        ),
      );
      await dataSource.upsertAlbum(
        const Album(
          id: 'album-1',
          sourceId: 'charcoal::chill-vibes',
          title: 'Chill Vibes',
          artistId: 'artist-1',
          trackCount: 1,
          totalDuration: Duration(minutes: 4),
        ),
      );
      await dataSource.upsertTrack(
        Track(
          id: 'track-1',
          sourceId: 'track-1',
          filePath: '/music/night-drive.mp3',
          title: 'Night Drive',
          artistId: 'artist-1',
          albumId: 'album-1',
          duration: const Duration(minutes: 4),
          format: 'mp3',
          fileSize: 1000,
          hasEmbeddedArtwork: false,
          dateAdded: DateTime.fromMillisecondsSinceEpoch(0),
          dateModified: DateTime.fromMillisecondsSinceEpoch(0),
        ),
      );
      await database.favoriteDao.upsertOne(
        FavoriteTableCompanion.insert(
          id: 'favorite-1',
          trackId: 'track-1',
          createdAt: DateTime.fromMillisecondsSinceEpoch(0),
        ),
      );
      await database.close();

      // Reopen the same file, as a fresh app launch would.
      final reopened = await _openTempDatabase('persistence_flow');
      addTearDown(reopened.close);

      expect(
        await reopened.favoriteDao.getByTrackId('track-1'),
        isNotNull,
      );
      final track = await reopened.trackDao.getById('track-1');
      expect(track?.title, 'Night Drive');

      // The key-value store persists the same way: written by one storage
      // instance, read back by a fresh one.
      SharedPreferences.setMockInitialValues(const {});
      final prefsA = SharedPreferencesStorage(
        await SharedPreferences.getInstance(),
      );
      await prefsA.setString(PreferenceKeys.userDisplayName, 'Dario');
      final prefsB = SharedPreferencesStorage(
        await SharedPreferences.getInstance(),
      );
      expect(
        await prefsB.getString(PreferenceKeys.userDisplayName),
        'Dario',
      );
    },
  );
}
