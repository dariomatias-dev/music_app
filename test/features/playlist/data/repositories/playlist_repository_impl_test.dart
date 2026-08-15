import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source_impl.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/playlist/data/repositories/playlist_repository_impl.dart';

class _SequentialIdGenerator implements IdGenerator {
  int _next = 0;

  @override
  String generate() => 'playlist-${_next++}';
}

void main() {
  late AppDatabase database;
  late PlaylistRepositoryImpl repository;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = PlaylistRepositoryImpl(database, _SequentialIdGenerator());

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
    for (final id in ['track-1', 'track-2', 'track-3']) {
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

  test('createPlaylist persists a new playlist', () async {
    final id = await repository.createPlaylist('Road Trip');

    final playlist = await repository.watchPlaylist(id).first;
    expect(playlist?.name, 'Road Trip');
    expect(playlist?.createdAt, playlist?.updatedAt);
  });

  test('watchPlaylists lists every playlist', () async {
    await repository.createPlaylist('Road Trip');
    await repository.createPlaylist('Focus');

    final playlists = await repository.watchPlaylists().first;
    expect(playlists.map((p) => p.name), ['Road Trip', 'Focus']);
  });

  test('watchPlaylist returns null for an unknown id', () async {
    expect(await repository.watchPlaylist('missing').first, isNull);
  });

  test('renamePlaylist updates the name and updatedAt', () async {
    final id = await repository.createPlaylist('Road Trip');
    final original = await repository.watchPlaylist(id).first;

    await repository.renamePlaylist(id, 'Long Drive');

    final renamed = await repository.watchPlaylist(id).first;
    expect(renamed?.name, 'Long Drive');
    expect(renamed?.createdAt, original?.createdAt);
  });

  test('deletePlaylist removes it', () async {
    final id = await repository.createPlaylist('Road Trip');

    await repository.deletePlaylist(id);

    expect(await repository.watchPlaylist(id).first, isNull);
  });

  test('setPlaylistTracks persists track order', () async {
    final id = await repository.createPlaylist('Road Trip');

    await repository.setPlaylistTracks(id, ['track-2', 'track-1']);

    expect(await repository.watchPlaylistTrackIds(id).first, [
      'track-2',
      'track-1',
    ]);
  });

  test('setPlaylistTracks replaces the previous order', () async {
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1', 'track-2', 'track-3']);

    await repository.setPlaylistTracks(id, ['track-3', 'track-1']);

    expect(await repository.watchPlaylistTrackIds(id).first, [
      'track-3',
      'track-1',
    ]);
  });

  test('setPlaylistTracks bumps updatedAt', () async {
    final id = await repository.createPlaylist('Road Trip');
    final before = await repository.watchPlaylist(id).first;

    // Drift stores DateTime with second precision, so the clock needs to
    // cross a full second for the bump to be observable.
    await Future<void>.delayed(const Duration(seconds: 1));
    await repository.setPlaylistTracks(id, ['track-1']);

    final after = await repository.watchPlaylist(id).first;
    expect(after!.updatedAt.isAfter(before!.updatedAt), isTrue);
  });
}
