import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/features/history/data/repositories/play_history_repository_impl.dart';
import 'package:music_app/src/features/history/domain/repositories/play_history_repository.dart';

/// Provides the [PlayHistoryRepository] used across the app.
final playHistoryRepositoryProvider = Provider<PlayHistoryRepository>(
  (ref) => PlayHistoryRepositoryImpl(ref.watch(appDatabaseProvider)),
);
