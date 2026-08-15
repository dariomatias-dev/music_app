import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source.dart';
import 'package:music_app/src/features/library/data/models/album_mapper.dart';
import 'package:music_app/src/features/library/data/models/track_mapper.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';

/// [LibraryLocalDataSource] implementation backed by [AppDatabase].
class LibraryLocalDataSourceImpl implements LibraryLocalDataSource {
  /// Creates a [LibraryLocalDataSourceImpl].
  const LibraryLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Future<Artist?> findArtistBySourceId(String sourceId) async {
    final row = await _database.artistDao.getBySourceId(sourceId);
    return row == null ? null : _artistFromRow(row);
  }

  @override
  Future<void> upsertArtist(Artist artist) {
    return _database.artistDao.upsertOne(
      ArtistTableCompanion.insert(
        id: artist.id,
        sourceId: artist.sourceId,
        name: artist.name,
        albumCount: artist.albumCount,
        trackCount: artist.trackCount,
      ),
    );
  }

  @override
  Future<Album?> findAlbumBySourceId(String sourceId) async {
    final row = await _database.albumDao.getBySourceId(sourceId);
    return row?.toEntity();
  }

  @override
  Future<void> upsertAlbum(Album album) {
    return _database.albumDao.upsertOne(album.toCompanion());
  }

  @override
  Future<Track?> findTrackBySourceId(String sourceId) async {
    final row = await _database.trackDao.getBySourceId(sourceId);
    return row?.toEntity();
  }

  @override
  Future<List<Track>> findAllTracks() async {
    final rows = await _database.trackDao.getAll();
    return rows.map((row) => row.toEntity()).toList();
  }

  @override
  Future<void> upsertTrack(Track track) {
    return _database.trackDao.upsertOne(track.toCompanion());
  }

  @override
  Future<void> deleteTrack(String id) {
    return _database.trackDao.deleteById(id);
  }

  @override
  Stream<List<Track>> watchTracks() {
    return _database.trackDao.watchAll().map(
      (rows) => rows.map((row) => row.toEntity()).toList(),
    );
  }

  @override
  Stream<List<Album>> watchAlbums() {
    return _database.albumDao.watchAll().map(
      (rows) => rows.map((row) => row.toEntity()).toList(),
    );
  }

  @override
  Stream<List<Artist>> watchArtists() {
    return _database.artistDao.watchAll().map(
      (rows) => rows.map(_artistFromRow).toList(),
    );
  }

  @override
  Future<void> clearAlbumArtworkPaths() {
    return _database.albumDao.clearArtworkPaths();
  }

  Artist _artistFromRow(ArtistRow row) {
    return Artist(
      id: row.id,
      sourceId: row.sourceId,
      name: row.name,
      albumCount: row.albumCount,
      trackCount: row.trackCount,
    );
  }
}
