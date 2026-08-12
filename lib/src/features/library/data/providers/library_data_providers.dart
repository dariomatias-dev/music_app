import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/core/services/artwork_cache/artwork_cache_providers.dart';
import 'package:music_app/src/core/services/id_generator/id_generator_provider.dart';
import 'package:music_app/src/core/services/media_scanner/media_scanner_providers.dart';
import 'package:music_app/src/core/services/metadata_reader/metadata_reader_providers.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source_impl.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/repositories/library_repository_impl.dart';
import 'package:music_app/src/features/library/domain/reconcile_library.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';

/// Provides the [LibraryLocalDataSource] used across the library feature.
final libraryLocalDataSourceProvider = Provider<LibraryLocalDataSource>(
  (ref) => LibraryLocalDataSourceImpl(ref.watch(appDatabaseProvider)),
);

/// Provides the [LibraryIndexer] used to scan and index the library.
final libraryIndexerProvider = Provider<LibraryIndexer>(
  (ref) => LibraryIndexer(
    mediaScanner: ref.watch(mediaScannerProvider),
    metadataReader: ref.watch(metadataReaderProvider),
    artworkCache: ref.watch(artworkCacheProvider),
    dataSource: ref.watch(libraryLocalDataSourceProvider),
    idGenerator: ref.watch(idGeneratorProvider),
  ),
);

/// Provides the [ReconcileLibrary] use case.
final reconcileLibraryProvider = Provider<ReconcileLibrary>(
  (ref) => ReconcileLibrary(
    indexer: ref.watch(libraryIndexerProvider),
    dataSource: ref.watch(libraryLocalDataSourceProvider),
  ),
);

/// Provides the [LibraryRepository] used across the app.
final libraryRepositoryProvider = Provider<LibraryRepository>(
  (ref) => LibraryRepositoryImpl(
    dataSource: ref.watch(libraryLocalDataSourceProvider),
    reconcileLibrary: ref.watch(reconcileLibraryProvider),
  ),
);
