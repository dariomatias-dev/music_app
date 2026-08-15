import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/database/database_providers.dart';
import 'package:music_app/src/features/statistics/data/repositories/statistics_repository_impl.dart';
import 'package:music_app/src/features/statistics/domain/repositories/statistics_repository.dart';

/// Provides the [StatisticsRepository] used across the app.
final statisticsRepositoryProvider = Provider<StatisticsRepository>(
  (ref) => StatisticsRepositoryImpl(ref.watch(appDatabaseProvider)),
);
