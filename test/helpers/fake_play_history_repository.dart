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

  @override
  Future<void> recordPlay({
    required String trackId,
    required DateTime startedAt,
    required Duration playedDuration,
    required bool completed,
  }) async {
    recordedPlays.add(trackId);
    entries.add((
      trackId: trackId,
      startedAt: startedAt,
      playedDuration: playedDuration,
      completed: completed,
    ));
  }

  bool historyCleared = false;

  @override
  Future<void> clearHistory() async {
    historyCleared = true;
  }
}
