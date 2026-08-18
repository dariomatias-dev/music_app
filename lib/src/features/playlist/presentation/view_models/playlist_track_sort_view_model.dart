import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playlist_track_sort_view_model.g.dart';

/// How a playlist screen orders its tracks.
enum PlaylistTrackSort {
  /// The playlist's own manual order (reorderable).
  custom,

  /// Alphabetically by title.
  title,

  /// Alphabetically by artist name.
  artist,

  /// Longest first.
  duration,
}

/// The current playlist screen's sort order.
@riverpod
class PlaylistTrackSortViewModel extends _$PlaylistTrackSortViewModel {
  @override
  PlaylistTrackSort build() => PlaylistTrackSort.custom;

  /// The order currently applied.
  PlaylistTrackSort get order => state;

  /// Switches to [order].
  set order(PlaylistTrackSort order) => state = order;
}
