import 'dart:async';

import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';

/// In-memory [LibraryRepository] for tests.
class FakeLibraryRepository implements LibraryRepository {
  FakeLibraryRepository([List<Track> tracks = const []])
    : _tracks = List.of(tracks);

  final List<Track> _tracks;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(List.of(_tracks));

  @override
  Stream<List<Album>> watchAlbums() => const Stream.empty();

  @override
  Stream<List<Artist>> watchArtists() => const Stream.empty();

  @override
  Stream<IndexingProgress> reindex() => const Stream.empty();

  @override
  Future<void> purgeMissingTracks() async {}

  @override
  Future<void> updateTrackTags(
    String trackId, {
    required String title,
    required String artist,
    required String album,
  }) async {}

  @override
  Future<void> clearArtworkCache() async {}
}
