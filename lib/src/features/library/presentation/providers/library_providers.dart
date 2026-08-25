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

/// Album id -> title, for resolving a track's album without a join query.
final albumNamesProvider = Provider<Map<String, String>>((ref) {
  final albums = ref.watch(albumsStreamProvider).value ?? const [];
  return {for (final album in albums) album.id: album.title};
});

/// Every indexed album, ordered alphabetically by title.
final sortedAlbumsProvider = Provider<List<Album>>((ref) {
  return [...ref.watch(albumsStreamProvider).value ?? const []]
    ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
});

/// Every indexed artist, ordered alphabetically by name.
final sortedArtistsProvider = Provider<List<Artist>>((ref) {
  return [...ref.watch(artistsStreamProvider).value ?? const []]
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
});

/// The artist with the given id, or `null` if it isn't indexed.
@riverpod
Artist? artistById(Ref ref, String artistId) {
  final artists = ref.watch(artistsStreamProvider).value ?? const [];
  for (final artist in artists) {
    if (artist.id == artistId) return artist;
  }
  return null;
}

/// Every album by the artist with the given id, ordered alphabetically.
@riverpod
List<Album> artistAlbums(Ref ref, String artistId) {
  return ref
      .watch(sortedAlbumsProvider)
      .where((album) => album.artistId == artistId)
      .toList();
}

/// Every non-missing track by the artist with the given id (their whole
/// discography), ordered by album title, then disc and track number.
@riverpod
List<Track> artistTracks(Ref ref, String artistId) {
  final tracks = ref.watch(tracksStreamProvider).value ?? const [];
  final albums = ref.watch(albumsStreamProvider).value ?? const [];
  final albumTitles = {for (final album in albums) album.id: album.title};

  return tracks
      .where((track) => track.artistId == artistId && !track.isMissing)
      .toList()
    ..sort((a, b) {
      final albumCompare = (albumTitles[a.albumId] ?? '')
          .toLowerCase()
          .compareTo((albumTitles[b.albumId] ?? '').toLowerCase());
      if (albumCompare != 0) return albumCompare;
      final discCompare = (a.discNumber ?? 0).compareTo(b.discNumber ?? 0);
      if (discCompare != 0) return discCompare;
      return (a.trackNumber ?? 0).compareTo(b.trackNumber ?? 0);
    });
}

/// The album with the given id, or `null` if it isn't indexed.
@riverpod
Album? albumById(Ref ref, String albumId) {
  final albums = ref.watch(albumsStreamProvider).value ?? const [];
  for (final album in albums) {
    if (album.id == albumId) return album;
  }
  return null;
}

/// Every non-missing track on the album with the given id, ordered by disc
/// and track number.
@riverpod
List<Track> albumTracks(Ref ref, String albumId) {
  final tracks = ref.watch(tracksStreamProvider).value ?? const [];
  return tracks
      .where((track) => track.albumId == albumId && !track.isMissing)
      .toList()
    ..sort((a, b) {
      final discCompare = (a.discNumber ?? 0).compareTo(b.discNumber ?? 0);
      if (discCompare != 0) return discCompare;
      return (a.trackNumber ?? 0).compareTo(b.trackNumber ?? 0);
    });
}

/// Ids of every favorited track, most recently favorited first.
final favoriteTrackIdsProvider = StreamProvider<List<String>>(
  (ref) => ref.watch(favoriteRepositoryProvider).watchFavoriteTrackIds(),
);

/// Every favorited, non-missing track, most recently favorited first.
final favoriteTracksProvider = Provider<List<Track>>((ref) {
  final ids = ref.watch(favoriteTrackIdsProvider).value ?? const [];
  final tracks = ref.watch(tracksStreamProvider).value ?? const [];
  final tracksById = {for (final track in tracks) track.id: track};

  final favorites = <Track>[];
  for (final id in ids) {
    final track = tracksById[id];
    if (track != null && !track.isMissing) favorites.add(track);
  }
  return favorites;
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
