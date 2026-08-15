import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/history/domain/repositories/play_history_repository.dart';

/// [PlayHistoryRepository] implementation backed by [AppDatabase].
class PlayHistoryRepositoryImpl implements PlayHistoryRepository {
  /// Creates a [PlayHistoryRepositoryImpl].
  const PlayHistoryRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Stream<List<String>> watchRecentTrackIds({int limit = 20}) {
    return _database.playEventDao.watchRecentTrackIds(limit: limit);
  }
}
