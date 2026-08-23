import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source_impl.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';

void main() {
  late AppDatabase database;
  late LibraryLocalDataSourceImpl dataSource;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    dataSource = LibraryLocalDataSourceImpl(database);
  });

  tearDown(() => database.close());

  test('findArtistBySourceId returns null when nothing is indexed', () async {
    expect(await dataSource.findArtistBySourceId('missing'), isNull);
  });

  test('an artist survives an upsert and lookup by sourceId', () async {
    const artist = Artist(
      id: 'artist-1',
      sourceId: 'charcoal',
      name: 'Charcoal',
      albumCount: 1,
      trackCount: 3,
    );

    await dataSource.upsertArtist(artist);

    expect(await dataSource.findArtistBySourceId('charcoal'), artist);
  });

  test('an album survives an upsert and lookup by sourceId', () async {
    const artist = Artist(
      id: 'artist-1',
      sourceId: 'charcoal',
      name: 'Charcoal',
      albumCount: 1,
      trackCount: 1,
    );
    await dataSource.upsertArtist(artist);

    const album = Album(
      id: 'album-1',
      sourceId: 'charcoal::chill vibes',
      title: 'Chill Vibes',
      artistId: 'artist-1',
      trackCount: 1,
      totalDuration: Duration(minutes: 3),
    );

    await dataSource.upsertAlbum(album);

    expect(
      await dataSource.findAlbumBySourceId('charcoal::chill vibes'),
      album,
    );
  });

  test('upsertTrack persists the track', () async {
    const artist = Artist(
      id: 'artist-1',
      sourceId: 'charcoal',
      name: 'Charcoal',
      albumCount: 1,
      trackCount: 1,
    );
    await dataSource.upsertArtist(artist);

    const album = Album(
      id: 'album-1',
      sourceId: 'charcoal::chill vibes',
      title: 'Chill Vibes',
      artistId: 'artist-1',
      trackCount: 1,
      totalDuration: Duration(minutes: 3, seconds: 30),
    );
    await dataSource.upsertAlbum(album);

    final track = Track(
      id: 'track-1',
      sourceId: '42',
      filePath: '/music/night-drive.mp3',
      title: 'Night Drive',
      artistId: 'artist-1',
      albumId: 'album-1',
      duration: const Duration(minutes: 3, seconds: 30),
      format: 'mp3',
      fileSize: 5000000,
      hasEmbeddedArtwork: false,
      dateAdded: DateTime(2026),
      dateModified: DateTime(2026),
    );

    await dataSource.upsertTrack(track);

    final row = await database.trackDao.getById('track-1');
    expect(row?.title, 'Night Drive');
  });

  group('with an indexed artist, album and track', () {
    late Track track;

    setUp(() async {
      const artist = Artist(
        id: 'artist-1',
        sourceId: 'charcoal',
        name: 'Charcoal',
        albumCount: 1,
        trackCount: 1,
      );
      await dataSource.upsertArtist(artist);

      const album = Album(
        id: 'album-1',
        sourceId: 'charcoal::chill vibes',
        title: 'Chill Vibes',
        artistId: 'artist-1',
        trackCount: 1,
        totalDuration: Duration(minutes: 3, seconds: 30),
      );
      await dataSource.upsertAlbum(album);

      track = Track(
        id: 'track-1',
        sourceId: '42',
        filePath: '/music/night-drive.mp3',
        title: 'Night Drive',
        artistId: 'artist-1',
        albumId: 'album-1',
        duration: const Duration(minutes: 3, seconds: 30),
        format: 'mp3',
        fileSize: 5000000,
        hasEmbeddedArtwork: false,
        dateAdded: DateTime(2026),
        dateModified: DateTime(2026),
      );
      await dataSource.upsertTrack(track);
    });

    test('findTrackBySourceId finds the track', () async {
      expect(await dataSource.findTrackBySourceId('42'), track);
    });

    test('findTrackBySourceId returns null for an unknown sourceId', () async {
      expect(await dataSource.findTrackBySourceId('missing'), isNull);
    });

    test('findAllTracks returns every indexed track', () async {
      expect(await dataSource.findAllTracks(), [track]);
    });

    test('deleteTrack removes the track', () async {
      await dataSource.deleteTrack('track-1');

      expect(await dataSource.findAllTracks(), isEmpty);
    });
  });

  test('clearAlbumArtworkPaths forgets every cached cover', () async {
    await dataSource.upsertAlbum(
      const Album(
        id: 'album-1',
        sourceId: 'album-1',
        title: 'Chill Vibes',
        artistId: 'artist-1',
        trackCount: 1,
        totalDuration: Duration(minutes: 3),
        artworkPath: '/covers/album-1.jpg',
      ),
    );

    await dataSource.clearAlbumArtworkPaths();

    expect(
      (await dataSource.findAlbumBySourceId('album-1'))?.artworkPath,
      isNull,
    );
  });
}
