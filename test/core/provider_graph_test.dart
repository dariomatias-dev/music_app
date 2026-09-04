import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/core/errors/error_reporter.dart';
import 'package:music_app/src/core/errors/error_reporter_provider.dart';
import 'package:music_app/src/core/permissions/media_permission_service_impl.dart';
import 'package:music_app/src/core/permissions/notification_permission_service_impl.dart';
import 'package:music_app/src/core/permissions/permission_providers.dart';
import 'package:music_app/src/core/services/app_lifecycle/app_lifecycle_providers.dart';
import 'package:music_app/src/core/services/app_lifecycle/widgets_binding_app_lifecycle_service.dart';
import 'package:music_app/src/core/services/artwork_cache/artwork_cache_providers.dart';
import 'package:music_app/src/core/services/artwork_cache/file_system_artwork_cache.dart';
import 'package:music_app/src/core/services/device_file/device_file_service_provider.dart';
import 'package:music_app/src/core/services/device_file/file_picker_device_file_service.dart';
import 'package:music_app/src/core/services/id_generator/id_generator_provider.dart';
import 'package:music_app/src/core/services/id_generator/uuid_v7_generator.dart';
import 'package:music_app/src/core/services/lyrics_reader/file_lyrics_reader.dart';
import 'package:music_app/src/core/services/lyrics_reader/lyrics_reader_providers.dart';
import 'package:music_app/src/core/services/media_scanner/media_scanner_providers.dart';
import 'package:music_app/src/core/services/media_scanner/on_audio_query_media_scanner.dart';
import 'package:music_app/src/core/services/metadata_reader/metadata_god_reader.dart';
import 'package:music_app/src/core/services/metadata_reader/metadata_reader_providers.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/core/utils/clock.dart';
import 'package:music_app/src/features/history/data/providers/history_data_providers.dart';
import 'package:music_app/src/features/history/data/repositories/play_history_repository_impl.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source_impl.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/data/repositories/favorite_repository_impl.dart';
import 'package:music_app/src/features/library/data/repositories/library_repository_impl.dart';
import 'package:music_app/src/features/player/data/providers/player_data_providers.dart';
import 'package:music_app/src/features/player/data/repositories/lyrics_repository_impl.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/playlist/data/repositories/playlist_repository_impl.dart';
import 'package:music_app/src/features/queue/data/providers/queue_data_providers.dart';
import 'package:music_app/src/features/search/data/providers/search_data_providers.dart';
import 'package:music_app/src/features/search/data/repositories/search_history_repository_impl.dart';
import 'package:music_app/src/features/statistics/data/providers/statistics_data_providers.dart';
import 'package:music_app/src/features/statistics/data/repositories/statistics_repository_impl.dart';
import 'package:music_app/src/features/storage/data/providers/storage_data_providers.dart';
import 'package:music_app/src/features/storage/data/repositories/excluded_folder_repository_impl.dart';

import '../helpers/fake_key_value_storage.dart';

/// Builds the real provider graph, overriding only the leaves that reach the
/// platform: the database file and the key-value store.
///
/// Everything above those is the wiring `main()` runs with, so a missing
/// dependency, a wrong argument order or a circular `watch` fails here
/// instead of on a device.
ProviderContainer _container() {
  final database = AppDatabase(NativeDatabase.memory());
  addTearDown(database.close);

  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
      keyValueStorageProvider.overrideWithValue(FakeKeyValueStorage()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('core services', () {
    test('resolve to their production implementations', () {
      final container = _container();

      expect(container.read(idGeneratorProvider), isA<UuidV7Generator>());
      expect(container.read(clockProvider), isNotNull);
      expect(
        container.read(artworkCacheProvider),
        isA<FileSystemArtworkCache>(),
      );
      expect(container.read(lyricsReaderProvider), isA<FileLyricsReader>());
      expect(container.read(metadataReaderProvider), isA<MetadataGodReader>());
      expect(
        container.read(mediaScannerProvider),
        isA<OnAudioQueryMediaScanner>(),
      );
      expect(
        container.read(mediaPermissionServiceProvider),
        isA<MediaPermissionServiceImpl>(),
      );
      expect(
        container.read(notificationPermissionServiceProvider),
        isA<NotificationPermissionServiceImpl>(),
      );
      expect(
        container.read(deviceFileServiceProvider),
        isA<FilePickerDeviceFileService>(),
      );
      expect(container.read(errorReporterProvider), isA<LogErrorReporter>());
      expect(
        container.read(appLifecycleServiceProvider),
        isA<WidgetsBindingAppLifecycleService>(),
      );
    });

    test('clock reports the current time by default', () {
      final container = _container();

      final now = container.read(clockProvider)();

      expect(
        now.difference(DateTime.now()).abs(),
        lessThan(const Duration(seconds: 5)),
      );
    });
  });

  group('database providers', () {
    test('every DAO resolves against the same database instance', () {
      final container = _container();
      final database = container.read(appDatabaseProvider);

      final daos = [
        container.read(artistDaoProvider),
        container.read(albumDaoProvider),
        container.read(trackDaoProvider),
        container.read(playlistDaoProvider),
        container.read(playlistTrackDaoProvider),
        container.read(favoriteDaoProvider),
        container.read(playEventDaoProvider),
        container.read(lyricsDaoProvider),
        container.read(searchHistoryDaoProvider),
        container.read(excludedFolderDaoProvider),
      ];

      expect(daos, hasLength(10));
      for (final dao in daos) {
        expect(dao.attachedDatabase, same(database));
      }
    });

    test('a DAO provider hands back the same instance on re-read', () {
      final container = _container();

      expect(
        container.read(trackDaoProvider),
        same(container.read(trackDaoProvider)),
      );
    });
  });

  group('repositories', () {
    test('resolve to their production implementations', () {
      final container = _container();

      expect(
        container.read(libraryLocalDataSourceProvider),
        isA<LibraryLocalDataSourceImpl>(),
      );
      expect(
        container.read(libraryRepositoryProvider),
        isA<LibraryRepositoryImpl>(),
      );
      expect(
        container.read(favoriteRepositoryProvider),
        isA<FavoriteRepositoryImpl>(),
      );
      expect(
        container.read(playlistRepositoryProvider),
        isA<PlaylistRepositoryImpl>(),
      );
      expect(
        container.read(playHistoryRepositoryProvider),
        isA<PlayHistoryRepositoryImpl>(),
      );
      expect(
        container.read(searchHistoryRepositoryProvider),
        isA<SearchHistoryRepositoryImpl>(),
      );
      expect(
        container.read(statisticsRepositoryProvider),
        isA<StatisticsRepositoryImpl>(),
      );
      expect(
        container.read(lyricsRepositoryProvider),
        isA<LyricsRepositoryImpl>(),
      );
      expect(
        container.read(excludedFolderRepositoryProvider),
        isA<ExcludedFolderRepositoryImpl>(),
      );
      expect(container.read(playbackSessionStorageProvider), isNotNull);
    });
  });

  group('use cases', () {
    test('resolve with every collaborator wired', () {
      final container = _container();

      expect(container.read(libraryIndexerProvider), isNotNull);
      expect(container.read(reconcileLibraryProvider), isNotNull);
      expect(container.read(deleteTrackFileProvider), isNotNull);
      expect(container.read(createBackupProvider), isNotNull);
      expect(container.read(restoreBackupProvider), isNotNull);
    });
  });

  test('the key-value store must be overridden before the app starts', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      () => container.read(keyValueStorageProvider),
      throwsA(
        isA<ProviderException>().having(
          (exception) => exception.exception,
          'exception',
          isA<UnimplementedError>(),
        ),
      ),
    );
  });

  test('the audio handler must be overridden before the app starts', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      () => container.read(audioHandlerProvider),
      throwsA(
        isA<ProviderException>().having(
          (exception) => exception.exception,
          'exception',
          isA<UnimplementedError>(),
        ),
      ),
    );
  });

  test('the session coordinator must be overridden before the app starts', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      () => container.read(audioSessionCoordinatorProvider),
      throwsA(
        isA<ProviderException>().having(
          (exception) => exception.exception,
          'exception',
          isA<UnimplementedError>(),
        ),
      ),
    );
  });
}
