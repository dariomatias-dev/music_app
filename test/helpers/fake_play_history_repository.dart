import 'package:music_app/src/features/history/domain/repositories/play_history_repository.dart';

/// In-memory [PlayHistoryRepository] for tests.
class FakePlayHistoryRepository implements PlayHistoryRepository {
  FakePlayHistoryRepository([this.recentTrackIds = const []]);

  final List<String> recentTrackIds;

  @override
  Stream<List<String>> watchRecentTrackIds({int limit = 20}) =>
      Stream.value(recentTrackIds.take(limit).toList());
}
