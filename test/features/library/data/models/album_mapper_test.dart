import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/library/data/models/album_mapper.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  test('an album survives a round trip through the database', () async {
    final artist = ArtistTableCompanion.insert(
      id: 'artist-1',
      sourceId: 'artist-source-1',
      name: 'Charcoal',
      albumCount: 1,
      trackCount: 3,
    );
    await database.artistDao.upsertOne(artist);

    const album = Album(
      id: 'album-1',
      sourceId: 'album-source-1',
      title: 'Chill Vibes',
      artistId: 'artist-1',
      trackCount: 3,
      totalDuration: Duration(minutes: 12, seconds: 45),
      year: 2024,
      artworkPath: '/cache/album-1.jpg',
    );

    await database.albumDao.upsertOne(album.toCompanion());

    final storedRow = await database.albumDao.watchAll().first;
    final roundTripped = storedRow.single.toEntity();

    expect(roundTripped, album);
  });
}
