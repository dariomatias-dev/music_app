import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source_impl.dart';
import 'package:music_app/src/features/library/data/repositories/favorite_repository_impl.dart';
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
  late FavoriteRepositoryImpl repository;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = FavoriteRepositoryImpl(database, _SequentialIdGenerator());

    final dataSource = LibraryLocalDataSourceImpl(database);
    await dataSource.upsertArtist(
      const Artist(
        id: 'artist-1',
        sourceId: 'artist-1',
        name: 'Charcoal',
        albumCount: 1,
        trackCount: 2,
      ),
    );
    await dataSource.upsertAlbum(
      const Album(
        id: 'album-1',
        sourceId: 'album-1',
        title: 'Chill Vibes',
        artistId: 'artist-1',
        trackCount: 2,
        totalDuration: Duration(minutes: 6),
      ),
    );
    for (final id in ['track-1', 'track-2']) {
      await dataSource.upsertTrack(
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
  });

  tearDown(() => database.close());

  test('watchIsFavorite reflects setFavorite', () async {
    expect(await repository.watchIsFavorite('track-1').first, isFalse);

    await repository.setFavorite('track-1', isFavorite: true);

    expect(await repository.watchIsFavorite('track-1').first, isTrue);
  });

  test('setFavorite does not duplicate an already-favorited track', () async {
    await repository.setFavorite('track-1', isFavorite: true);
    await repository.setFavorite('track-1', isFavorite: true);

    expect(await repository.watchFavoriteTrackIds().first, ['track-1']);
  });

  test('watchFavoriteTrackIds lists most recently favorited first', () async {
    await repository.setFavorite('track-1', isFavorite: true);
    await repository.setFavorite('track-2', isFavorite: true);

    expect(await repository.watchFavoriteTrackIds().first, [
      'track-2',
      'track-1',
    ]);
  });

  test('setFavorite false removes the track from favorites', () async {
    await repository.setFavorite('track-1', isFavorite: true);
    await repository.setFavorite('track-2', isFavorite: true);

    await repository.setFavorite('track-1', isFavorite: false);

    expect(await repository.watchFavoriteTrackIds().first, ['track-2']);
  });
}
