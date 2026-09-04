import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/playlist/domain/entities/playlist.dart';
import 'package:music_app/src/features/playlist/presentation/providers/playlist_providers.dart';
import 'package:music_app/src/features/search/presentation/view_models/search_view_model.dart';

/// Matches for the current search term, capped and grouped by type.
class SearchResults {
  /// Creates a [SearchResults].
  const SearchResults({
    this.tracks = const [],
    this.albums = const [],
    this.artists = const [],
    this.playlists = const [],
  });

  /// Matching tracks.
  final List<Track> tracks;

  /// Matching albums.
  final List<Album> albums;

  /// Matching artists.
  final List<Artist> artists;

  /// Matching playlists.
  final List<Playlist> playlists;

  /// Whether every group is empty.
  bool get isEmpty =>
      tracks.isEmpty && albums.isEmpty && artists.isEmpty && playlists.isEmpty;
}

/// Maximum matches kept per group.
const _maxPerGroup = 20;

/// Tracks, albums, artists and playlists whose name contains the current
/// search term (case-insensitive), empty while the term itself is empty.
final searchResultsProvider = Provider<SearchResults>((ref) {
  final term = ref.watch(searchViewModelProvider).toLowerCase();
  if (term.isEmpty) return const SearchResults();

  bool matches(String text) => text.toLowerCase().contains(term);

  final tracks = ref.watch(tracksStreamProvider).value ?? const [];
  final albums = ref.watch(visibleAlbumsProvider);
  final artists = ref.watch(visibleArtistsProvider);
  final playlists = ref.watch(playlistsProvider).value ?? const [];

  return SearchResults(
    tracks: tracks
        .where((track) => !track.isMissing && matches(track.title))
        .take(_maxPerGroup)
        .toList(),
    albums: albums
        .where((album) => matches(album.title))
        .take(_maxPerGroup)
        .toList(),
    artists: artists
        .where((artist) => matches(artist.name))
        .take(_maxPerGroup)
        .toList(),
    playlists: playlists
        .where((playlist) => matches(playlist.name))
        .take(_maxPerGroup)
        .toList(),
  );
});
