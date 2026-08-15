import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:music_app/src/features/history/domain/repositories/play_history_repository.dart';

/// [PlayHistoryRepository] implementation backed by [AppDatabase].
class PlayHistoryRepositoryImpl implements PlayHistoryRepository {
  /// Creates a [PlayHistoryRepositoryImpl].
  const PlayHistoryRepositoryImpl(this._database, this._idGenerator);

  final AppDatabase _database;
  final IdGenerator _idGenerator;

  @override
  Stream<List<String>> watchRecentTrackIds({int limit = 20}) {
    return _database.playEventDao.watchRecentTrackIds(limit: limit);
  }

  @override
  Future<void> recordPlay({
    required String trackId,
    required DateTime startedAt,
    required Duration playedDuration,
    required bool completed,
  }) {
    return _database.playEventDao.upsertOne(
      PlayEventTableCompanion.insert(
        id: _idGenerator.generate(),
        trackId: trackId,
        startedAt: startedAt,
        playedDuration: playedDuration.inMilliseconds,
        completed: completed,
      ),
    );
  }
}
