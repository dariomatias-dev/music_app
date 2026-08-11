import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/library/data/models/track_mapper.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  test('a track survives a round trip through the database', () async {
    final artist = ArtistTableCompanion.insert(
      id: 'artist-1',
      sourceId: 'artist-source-1',
      name: 'Charcoal',
      albumCount: 1,
      trackCount: 1,
    );
    await database.artistDao.upsertOne(artist);

    final album = AlbumTableCompanion.insert(
      id: 'album-1',
      sourceId: 'album-source-1',
      title: 'Chill Vibes',
      artistId: 'artist-1',
      trackCount: 1,
      totalDuration: 210000,
    );
    await database.albumDao.upsertOne(album);

    final track = Track(
      id: 'track-1',
      sourceId: 'track-source-1',
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
      trackNumber: 4,
    );

    await database.trackDao.upsertOne(track.toCompanion());

    final storedRow = await database.trackDao.getById('track-1');
    final roundTripped = storedRow!.toEntity();

    expect(roundTripped, track);
  });
}
