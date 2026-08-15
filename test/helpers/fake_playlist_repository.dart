import 'dart:async';

import 'package:music_app/src/features/playlist/domain/entities/playlist.dart';
import 'package:music_app/src/features/playlist/domain/repositories/playlist_repository.dart';

/// In-memory [PlaylistRepository] for tests.
class FakePlaylistRepository implements PlaylistRepository {
  final Map<String, Playlist> _playlists = {};
  final Map<String, List<String>> _tracks = {};
  final _playlistsController = StreamController<List<Playlist>>.broadcast();
  final Map<String, StreamController<Playlist?>> _playlistControllers = {};
  final Map<String, StreamController<List<String>>> _trackControllers = {};
  var _nextId = 0;

  void _emitPlaylists() {
    _playlistsController.add(_playlists.values.toList());
    for (final entry in _playlistControllers.entries) {
      entry.value.add(_playlists[entry.key]);
    }
  }

  StreamController<Playlist?> _playlistControllerFor(String id) =>
      _playlistControllers.putIfAbsent(
        id,
        StreamController<Playlist?>.broadcast,
      );

  StreamController<List<String>> _trackControllerFor(String id) =>
      _trackControllers.putIfAbsent(
        id,
        StreamController<List<String>>.broadcast,
      );

  @override
  Stream<List<Playlist>> watchPlaylists() async* {
    yield _playlists.values.toList();
    yield* _playlistsController.stream;
  }

  @override
  Stream<Playlist?> watchPlaylist(String playlistId) async* {
    yield _playlists[playlistId];
    yield* _playlistControllerFor(playlistId).stream;
  }

  @override
  Stream<List<String>> watchPlaylistTrackIds(String playlistId) async* {
    yield _tracks[playlistId] ?? const [];
    yield* _trackControllerFor(playlistId).stream;
  }

  @override
  Future<String> createPlaylist(String name) async {
    final id = 'playlist-${_nextId++}';
    final now = DateTime.now();
    _playlists[id] = Playlist(
      id: id,
      name: name,
      createdAt: now,
      updatedAt: now,
    );
    _tracks[id] = const [];
    _emitPlaylists();
    return id;
  }

  @override
  Future<void> renamePlaylist(String playlistId, String name) async {
    final existing = _playlists[playlistId];
    if (existing == null) return;
    _playlists[playlistId] = existing.copyWith(
      name: name,
      updatedAt: DateTime.now(),
    );
    _emitPlaylists();
  }

  @override
  Future<void> deletePlaylist(String playlistId) async {
    _playlists.remove(playlistId);
    _tracks.remove(playlistId);
    _emitPlaylists();
  }

  @override
  Future<void> setPlaylistTracks(
    String playlistId,
    List<String> trackIds,
  ) async {
    _tracks[playlistId] = trackIds;
    final existing = _playlists[playlistId];
    if (existing != null) {
      _playlists[playlistId] = existing.copyWith(updatedAt: DateTime.now());
      _emitPlaylists();
    }
    _trackControllerFor(playlistId).add(trackIds);
  }
}
