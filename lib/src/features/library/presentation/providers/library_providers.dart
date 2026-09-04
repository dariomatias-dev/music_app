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

/// Album id -> album, for looking one up without scanning the list.
final albumsByIdProvider = Provider<Map<String, Album>>((ref) {
  final albums = ref.watch(albumsStreamProvider).value ?? const [];
  return {for (final album in albums) album.id: album};
});

/// Artist id -> artist, for looking one up without scanning the list.
final artistsByIdProvider = Provider<Map<String, Artist>>((ref) {
  final artists = ref.watch(artistsStreamProvider).value ?? const [];
  return {for (final artist in artists) artist.id: artist};
});

/// Every album with at least one track still on the device.
///
/// An album whose files are all gone keeps its row, so playlists, history
/// and favorites that point at its tracks still resolve, but it has
/// nothing left to show and browsing into it would land on an empty
/// screen.
final visibleAlbumsProvider = Provider<List<Album>>((ref) {
  final albums = ref.watch(albumsStreamProvider).value ?? const [];
  final tracksByAlbum = ref.watch(tracksByAlbumProvider);
  return [
    for (final album in albums)
      if (tracksByAlbum.containsKey(album.id)) album,
  ];
});

/// Every artist with at least one track still on the device, for the same
/// reason as [visibleAlbumsProvider].
final visibleArtistsProvider = Provider<List<Artist>>((ref) {
  final artists = ref.watch(artistsStreamProvider).value ?? const [];
  final tracksByArtist = ref.watch(tracksByArtistProvider);
  return [
    for (final artist in artists)
      if (tracksByArtist.containsKey(artist.id)) artist,
  ];
});

/// Every album still on the device, ordered alphabetically by title.
final sortedAlbumsProvider = Provider<List<Album>>((ref) {
  final albums = ref.watch(visibleAlbumsProvider);
  return _sortedByKey(albums, (album) => album.title.toLowerCase());
});

/// Every artist still on the device, ordered alphabetically by name.
final sortedArtistsProvider = Provider<List<Artist>>((ref) {
  final artists = ref.watch(visibleArtistsProvider);
  return _sortedByKey(artists, (artist) => artist.name.toLowerCase());
});

/// Album id -> its non-missing tracks, ordered by disc and track number.
///
/// Grouped once for the whole library rather than per album screen, which
/// would otherwise filter and sort every indexed track again each time one
/// is opened.
final tracksByAlbumProvider = Provider<Map<String, List<Track>>>((ref) {
  final grouped = _groupVisibleTracks(
    ref.watch(tracksStreamProvider).value ?? const [],
    (track) => track.albumId,
  );
  for (final tracks in grouped.values) {
    tracks.sort(_byDiscAndTrackNumber);
  }
  return grouped;
});

/// Artist id -> their non-missing tracks, ordered by album title, then disc
/// and track number.
///
/// Grouped once for the whole library, for the same reason as
/// [tracksByAlbumProvider].
final tracksByArtistProvider = Provider<Map<String, List<Track>>>((ref) {
  final albumTitles = ref.watch(albumNamesProvider);
  final grouped = _groupVisibleTracks(
    ref.watch(tracksStreamProvider).value ?? const [],
    (track) => track.artistId,
  );
  return {
    for (final entry in grouped.entries)
      entry.key: _sortedByAlbumThenNumber(entry.value, albumTitles),
  };
});

/// The artist with the given id, or `null` if it isn't indexed.
@riverpod
Artist? artistById(Ref ref, String artistId) =>
    ref.watch(artistsByIdProvider)[artistId];

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
List<Track> artistTracks(Ref ref, String artistId) =>
    ref.watch(tracksByArtistProvider)[artistId] ?? const [];

/// The album with the given id, or `null` if it isn't indexed.
@riverpod
Album? albumById(Ref ref, String albumId) =>
    ref.watch(albumsByIdProvider)[albumId];

/// Every non-missing track on the album with the given id, ordered by disc
/// and track number.
@riverpod
List<Track> albumTracks(Ref ref, String albumId) =>
    ref.watch(tracksByAlbumProvider)[albumId] ?? const [];

/// Total playing time of [albumTracks].
///
/// Derived rather than read from the album's stored total, which is only
/// recomputed by a scan and so still counts files deleted since.
@riverpod
Duration albumDuration(Ref ref, String albumId) {
  return ref
      .watch(albumTracksProvider(albumId))
      .fold(Duration.zero, (total, track) => total + track.duration);
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

  final visible = tracks.where((track) => !track.isMissing).toList();

  // The text sorts read their key through a map lookup and a lowercasing
  // that a comparator would otherwise redo on both sides of every one of
  // the n log n comparisons.
  return switch (sort) {
    TrackSort.title => _sortedByKey(
      visible,
      (track) => track.title.toLowerCase(),
    ),
    TrackSort.artist => _sortedByKey(
      visible,
      (track) => (artistNames[track.artistId] ?? '').toLowerCase(),
    ),
    TrackSort.dateAdded =>
      visible..sort((a, b) => b.dateAdded.compareTo(a.dateAdded)),
    TrackSort.duration =>
      visible..sort((a, b) => b.duration.compareTo(a.duration)),
  };
}

/// [items] ordered by [key], which is computed once per item instead of
/// once per comparison.
List<T> _sortedByKey<T, K extends Comparable<K>>(
  Iterable<T> items,
  K Function(T item) key,
) {
  final decorated = [for (final item in items) (key: key(item), item: item)]
    ..sort((a, b) => a.key.compareTo(b.key));
  return [for (final entry in decorated) entry.item];
}

/// [tracks] that are still on disk, grouped by [keyOf].
Map<String, List<Track>> _groupVisibleTracks(
  List<Track> tracks,
  String Function(Track track) keyOf,
) {
  final grouped = <String, List<Track>>{};
  for (final track in tracks) {
    if (track.isMissing) continue;
    (grouped[keyOf(track)] ??= []).add(track);
  }
  return grouped;
}

int _byDiscAndTrackNumber(Track a, Track b) {
  final discCompare = (a.discNumber ?? 0).compareTo(b.discNumber ?? 0);
  if (discCompare != 0) return discCompare;
  return (a.trackNumber ?? 0).compareTo(b.trackNumber ?? 0);
}

/// [tracks] ordered by their album's title, then by disc and track number.
List<Track> _sortedByAlbumThenNumber(
  List<Track> tracks,
  Map<String, String> albumTitles,
) {
  final decorated =
      [
        for (final track in tracks)
          (
            title: (albumTitles[track.albumId] ?? '').toLowerCase(),
            track: track,
          ),
      ]..sort((a, b) {
        final titleCompare = a.title.compareTo(b.title);
        if (titleCompare != 0) return titleCompare;
        return _byDiscAndTrackNumber(a.track, b.track);
      });
  return [for (final entry in decorated) entry.track];
}
