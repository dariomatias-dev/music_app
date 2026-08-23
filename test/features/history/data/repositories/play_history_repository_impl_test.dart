import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:music_app/src/features/history/data/repositories/play_history_repository_impl.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source_impl.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';

class _SequentialIdGenerator implements IdGenerator {
  int _next = 0;

  @override
  String generate() => 'id-${_next++}';
}

void main() {
  late AppDatabase database;
  late PlayHistoryRepositoryImpl repository;

  Future<void> seedTrack(String id) async {
    await LibraryLocalDataSourceImpl(database).upsertTrack(
      Track(
        id: id,
        sourceId: id,
        filePath: '/music/$id.mp3',
        title: id,
        artistId: 'artist-1',
        albumId: 'album-1',
        duration: const Duration(minutes: 3),
        format: 'mp3',
        fileSize: 1000,
        hasEmbeddedArtwork: false,
        dateAdded: DateTime(2026),
        dateModified: DateTime(2026),
      ),
    );
  }

  Future<void> recordPlay(String trackId, DateTime startedAt) async {
    await database
        .into(database.playEventTable)
        .insert(
          PlayEventTableCompanion.insert(
            id: '$trackId-${startedAt.microsecondsSinceEpoch}',
            trackId: trackId,
            startedAt: startedAt,
            playedDuration: 60000,
            completed: true,
          ),
        );
  }

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = PlayHistoryRepositoryImpl(database, _SequentialIdGenerator());

    final dataSource = LibraryLocalDataSourceImpl(database);
    await dataSource.upsertArtist(
      const Artist(
        id: 'artist-1',
        sourceId: 'artist-1',
        name: 'Charcoal',
        albumCount: 1,
        trackCount: 3,
      ),
    );
    await dataSource.upsertAlbum(
      const Album(
        id: 'album-1',
        sourceId: 'album-1',
        title: 'Chill Vibes',
        artistId: 'artist-1',
        trackCount: 3,
        totalDuration: Duration(minutes: 9),
      ),
    );
    await seedTrack('track-1');
    await seedTrack('track-2');
    await seedTrack('track-3');
  });

  tearDown(() => database.close());

  test('watchRecentTrackIds returns empty when nothing was played', () async {
    expect(await repository.watchRecentTrackIds().first, isEmpty);
  });

  test('watchRecentTrackIds orders by most recently played', () async {
    await recordPlay('track-1', DateTime(2026));
    await recordPlay('track-2', DateTime(2026, 1, 3));
    await recordPlay('track-3', DateTime(2026, 1, 2));

    expect(await repository.watchRecentTrackIds().first, [
      'track-2',
      'track-3',
      'track-1',
    ]);
  });

  test('watchRecentTrackIds deduplicates repeated plays of a track', () async {
    await recordPlay('track-1', DateTime(2026));
    await recordPlay('track-1', DateTime(2026, 1, 2));
    await recordPlay('track-2', DateTime(2026, 1, 3));

    expect(await repository.watchRecentTrackIds().first, [
      'track-2',
      'track-1',
    ]);
  });

  test('watchRecentTrackIds respects the limit', () async {
    await recordPlay('track-1', DateTime(2026));
    await recordPlay('track-2', DateTime(2026, 1, 2));
    await recordPlay('track-3', DateTime(2026, 1, 3));

    expect(await repository.watchRecentTrackIds(limit: 2).first, [
      'track-3',
      'track-2',
    ]);
  });

  test('recordPlay persists a play event', () async {
    await repository.recordPlay(
      trackId: 'track-1',
      startedAt: DateTime(2026),
      playedDuration: const Duration(seconds: 45),
      completed: false,
    );

    final rows = await database.select(database.playEventTable).get();
    expect(rows, hasLength(1));
    expect(rows.single.trackId, 'track-1');
    expect(rows.single.playedDuration, 45000);
    expect(rows.single.completed, isFalse);
  });

  test('recordPlay makes the track show up as recently played', () async {
    await repository.recordPlay(
      trackId: 'track-1',
      startedAt: DateTime(2026),
      playedDuration: const Duration(seconds: 45),
      completed: true,
    );

    expect(await repository.watchRecentTrackIds().first, ['track-1']);
  });

  test('clearHistory drops every recorded play', () async {
    await repository.recordPlay(
      trackId: 'track-1',
      startedAt: DateTime(2026),
      playedDuration: const Duration(seconds: 45),
      completed: true,
    );

    await repository.clearHistory();

    expect(await repository.watchRecentTrackIds().first, isEmpty);
  });
}
