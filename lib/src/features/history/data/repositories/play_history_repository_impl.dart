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
  Future<List<PlayHistoryEntry>> getAllEntries() async {
    final rows = await _database.playEventDao.getAll();
    return [
      for (final row in rows)
        (
          trackId: row.trackId,
          startedAt: row.startedAt,
          playedDuration: Duration(milliseconds: row.playedDuration),
          completed: row.completed,
        ),
    ];
  }

  @override
  Future<void> recordPlay({
    required String trackId,
    required DateTime startedAt,
    required Duration playedDuration,
    required bool completed,
    String? id,
  }) {
    return _database.playEventDao.upsertOne(
      PlayEventTableCompanion.insert(
        id: id ?? _idGenerator.generate(),
        trackId: trackId,
        startedAt: startedAt,
        playedDuration: playedDuration.inMilliseconds,
        completed: completed,
      ),
    );
  }

  @override
  Future<void> clearHistory() => _database.playEventDao.clear();
}
