import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:music_app/src/features/playlist/domain/entities/playlist.dart';
import 'package:music_app/src/features/playlist/domain/repositories/playlist_repository.dart';

/// [PlaylistRepository] implementation backed by [AppDatabase].
class PlaylistRepositoryImpl implements PlaylistRepository {
  /// Creates a [PlaylistRepositoryImpl].
  const PlaylistRepositoryImpl(this._database, this._idGenerator);

  final AppDatabase _database;
  final IdGenerator _idGenerator;

  @override
  Stream<List<Playlist>> watchPlaylists() {
    return _database.playlistDao.watchAll().map(
      (rows) => rows.map(_toEntity).toList(),
    );
  }

  @override
  Stream<Playlist?> watchPlaylist(String playlistId) {
    return _database.playlistDao
        .watchById(playlistId)
        .map((row) => row == null ? null : _toEntity(row));
  }

  @override
  Stream<List<String>> watchPlaylistTrackIds(String playlistId) {
    return _database.playlistTrackDao
        .watchForPlaylist(playlistId)
        .map((rows) => rows.map((row) => row.trackId).toList());
  }

  @override
  Future<String> createPlaylist(String name) async {
    final id = _idGenerator.generate();
    final now = DateTime.now();
    await _database.playlistDao.insertOne(
      PlaylistTableCompanion.insert(
        id: id,
        name: name,
        createdAt: now,
        updatedAt: now,
      ),
    );
    return id;
  }

  @override
  Future<void> renamePlaylist(String playlistId, String name) {
    return _database.playlistDao.updateOne(
      playlistId,
      PlaylistTableCompanion(
        name: Value(name),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> deletePlaylist(String playlistId) =>
      _database.playlistDao.deleteById(playlistId);

  @override
  Future<void> setPlaylistTracks(
    String playlistId,
    List<String> trackIds,
  ) async {
    final entries = [
      for (var i = 0; i < trackIds.length; i++)
        PlaylistTrackTableCompanion.insert(
          playlistId: playlistId,
          trackId: trackIds[i],
          position: i,
        ),
    ];
    await _database.playlistTrackDao.replaceForPlaylist(playlistId, entries);
    await _database.playlistDao.updateOne(
      playlistId,
      PlaylistTableCompanion(updatedAt: Value(DateTime.now())),
    );
  }

  @override
  Future<void> removeTrackFromAllPlaylists(String trackId) =>
      _database.playlistTrackDao.deleteTrackFromAllPlaylists(trackId);

  Playlist _toEntity(PlaylistRow row) => Playlist(
    id: row.id,
    name: row.name,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
