import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/library/data/seeds/library_seed.dart';

void main() {
  late AppDatabase database;

  DateTime clock() => DateTime(2026, 3, 15, 10, 30);

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await LibrarySeed(database, clock: clock).run();
  });

  test('writes every artist, album and track in the catalogue', () async {
    expect(
      (await database.artistDao.watchAll().first).length,
      seedArtists.length,
    );
    expect(
      (await database.albumDao.watchAll().first).length,
      seedAlbums.length,
    );
    expect((await database.trackDao.getAll()).length, seedTrackIds.length);
  });

  test('counts each album and artist by what it actually holds', () async {
    final tracks = await database.trackDao.getAll();

    for (final album in seedAlbums) {
      final albumTracks = tracks.where((track) => track.albumId == album.id);
      expect(album.trackCount, albumTracks.length, reason: album.title);
      expect(
        album.totalDuration,
        albumTracks.fold(
          Duration.zero,
          (total, track) => total + Duration(milliseconds: track.duration),
        ),
        reason: album.title,
      );
    }

    for (final artist in seedArtists) {
      expect(
        artist.trackCount,
        tracks.where((track) => track.artistId == artist.id).length,
        reason: artist.name,
      );
    }
  });

  test('covers the states the library screens have to render', () async {
    final tracks = await database.trackDao.getAll();

    expect(
      tracks.where((track) => track.isMissing),
      isNotEmpty,
      reason: 'a track whose file is gone',
    );
    expect(
      seedAlbums.where((album) => album.year == null),
      isNotEmpty,
      reason: 'an album with no year',
    );
    expect(
      tracks.where((track) => track.genre == null),
      isNotEmpty,
      reason: 'a track with no genre',
    );
    expect(
      tracks.where((track) => (track.discNumber ?? 1) > 1),
      isNotEmpty,
      reason: 'a second disc',
    );
    expect(
      seedArtists.where((artist) => artist.name.length > 40),
      isNotEmpty,
      reason: 'a name long enough to truncate',
    );
    expect(
      seedArtists.where((artist) => artist.name.contains(RegExp('[À-ÿ]'))),
      isNotEmpty,
      reason: 'an accented name',
    );
  });

  test('dates the newest track on the day it runs', () async {
    final tracks = await database.trackDao.getAll();
    final dates = tracks.map((track) => track.dateAdded).toList()..sort();

    expect(dates.last, clock());
    expect(dates.first.isBefore(clock()), isTrue);
  });

  test('running twice replaces the rows it wrote', () async {
    await LibrarySeed(database, clock: clock).run();

    expect((await database.trackDao.getAll()).length, seedTrackIds.length);
  });
}
