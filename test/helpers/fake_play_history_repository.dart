import 'package:music_app/src/features/history/domain/repositories/play_history_repository.dart';

/// In-memory [PlayHistoryRepository] for tests.
class FakePlayHistoryRepository implements PlayHistoryRepository {
  FakePlayHistoryRepository([
    this.recentTrackIds = const [],
    List<PlayHistoryEntry> entries = const [],
  ]) : entries = List.of(entries);

  final List<String> recentTrackIds;
  final List<PlayHistoryEntry> entries;

  @override
  Stream<List<String>> watchRecentTrackIds({int limit = 20}) =>
      Stream.value(recentTrackIds.take(limit).toList());

  @override
  Future<List<PlayHistoryEntry>> getAllEntries() async => List.of(entries);

  final recordedPlays = <String>[];

  /// Where each recorded id landed in [entries], so writing the same id
  /// again rewrites that entry, as the database's upsert does.
  final _indexById = <String, int>{};

  @override
  Future<void> recordPlay({
    required String trackId,
    required DateTime startedAt,
    required Duration playedDuration,
    required bool completed,
    String? id,
  }) async {
    final entry = (
      trackId: trackId,
      startedAt: startedAt,
      playedDuration: playedDuration,
      completed: completed,
    );
    final index = id == null ? null : _indexById[id];
    if (index != null) {
      entries[index] = entry;
      return;
    }
    if (id != null) _indexById[id] = entries.length;
    recordedPlays.add(trackId);
    entries.add(entry);
  }

  bool historyCleared = false;

  @override
  Future<void> clearHistory() async {
    historyCleared = true;
  }
}
