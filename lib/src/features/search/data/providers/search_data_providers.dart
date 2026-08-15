import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/core/services/id_generator/id_generator_provider.dart';
import 'package:music_app/src/features/search/data/repositories/search_history_repository_impl.dart';
import 'package:music_app/src/features/search/domain/repositories/search_history_repository.dart';

/// Provides the [SearchHistoryRepository] used across the app.
final searchHistoryRepositoryProvider = Provider<SearchHistoryRepository>(
  (ref) => SearchHistoryRepositoryImpl(
    ref.watch(appDatabaseProvider),
    ref.watch(idGeneratorProvider),
  ),
);
