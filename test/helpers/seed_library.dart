import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';

/// Inserts the artist row [id], if it isn't there already.
///
/// The schema's foreign keys are enforced, so a test that only cares about
/// a child row still has to give it something to point at.
Future<void> seedArtist(AppDatabase database, {String id = 'artist-1'}) {
  return database
      .into(database.artistTable)
      .insert(
        ArtistTableCompanion.insert(
          id: id,
          sourceId: id,
          name: 'Artist $id',
          albumCount: 1,
          trackCount: 1,
        ),
        mode: InsertMode.insertOrIgnore,
      );
}

/// Inserts the album row [id], and the artist it belongs to.
Future<void> seedAlbum(
  AppDatabase database, {
  String id = 'album-1',
  String artistId = 'artist-1',
}) async {
  await seedArtist(database, id: artistId);
  await database
      .into(database.albumTable)
      .insert(
        AlbumTableCompanion.insert(
          id: id,
          sourceId: id,
          title: 'Album $id',
          artistId: artistId,
          trackCount: 1,
          totalDuration: 1000,
        ),
        mode: InsertMode.insertOrIgnore,
      );
}

/// Inserts the track row [id], and the album and artist it belongs to.
Future<void> seedTrack(
  AppDatabase database,
  String id, {
  String artistId = 'artist-1',
  String albumId = 'album-1',
}) async {
  await seedAlbum(database, id: albumId, artistId: artistId);
  await database
      .into(database.trackTable)
      .insert(
        TrackTableCompanion.insert(
          id: id,
          sourceId: id,
          filePath: '/music/$id.mp3',
          title: 'Track $id',
          artistId: artistId,
          albumId: albumId,
          duration: 1000,
          format: 'mp3',
          fileSize: 2048,
          hasEmbeddedArtwork: false,
          dateAdded: DateTime.utc(2024),
          dateModified: DateTime.utc(2024),
        ),
        mode: InsertMode.insertOrIgnore,
      );
}
