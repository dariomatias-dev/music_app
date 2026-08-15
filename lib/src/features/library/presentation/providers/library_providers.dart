import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/presentation/view_models/track_sort_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_providers.g.dart';

/// Live-updating list of every indexed track.
final tracksStreamProvider = StreamProvider<List<Track>>(
  (ref) => ref.watch(libraryRepositoryProvider).watchTracks(),
);

/// Live-updating list of every indexed artist.
final artistsStreamProvider = StreamProvider<List<Artist>>(
  (ref) => ref.watch(libraryRepositoryProvider).watchArtists(),
);

/// Live-updating list of every indexed album.
final albumsStreamProvider = StreamProvider<List<Album>>(
  (ref) => ref.watch(libraryRepositoryProvider).watchAlbums(),
);

/// Artist id -> name, for resolving a track's artist without a join query.
final artistNamesProvider = Provider<Map<String, String>>((ref) {
  final artists = ref.watch(artistsStreamProvider).value ?? const [];
  return {for (final artist in artists) artist.id: artist.name};
});

/// Album id -> cached artwork path, for showing a track's cover.
final albumArtworkProvider = Provider<Map<String, String?>>((ref) {
  final albums = ref.watch(albumsStreamProvider).value ?? const [];
  return {for (final album in albums) album.id: album.artworkPath};
});

/// Every indexed, non-missing track, ordered by the Tracks tab's current
/// sort. Recomputed only when the tracks, artists or sort order change.
@riverpod
List<Track> sortedTracks(Ref ref) {
  final tracks = ref.watch(tracksStreamProvider).value ?? const [];
  final sort = ref.watch(trackSortViewModelProvider);
  final artistNames = ref.watch(artistNamesProvider);

  final visible = tracks.where((track) => !track.isMissing).toList()
    ..sort(
      (a, b) => switch (sort) {
        TrackSort.title => a.title.toLowerCase().compareTo(
          b.title.toLowerCase(),
        ),
        TrackSort.artist =>
          (artistNames[a.artistId] ?? '').toLowerCase().compareTo(
            (artistNames[b.artistId] ?? '').toLowerCase(),
          ),
        TrackSort.dateAdded => b.dateAdded.compareTo(a.dateAdded),
        TrackSort.duration => b.duration.compareTo(a.duration),
      },
    );
  return visible;
}
