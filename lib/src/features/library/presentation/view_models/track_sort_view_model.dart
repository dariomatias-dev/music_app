import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'track_sort_view_model.g.dart';

/// How the Tracks tab orders its list.
enum TrackSort {
  /// Alphabetically by title.
  title,

  /// Alphabetically by artist name.
  artist,

  /// Most recently added first.
  dateAdded,

  /// Longest first.
  duration,
}

/// The Tracks tab's current sort order.
@riverpod
class TrackSortViewModel extends _$TrackSortViewModel {
  @override
  TrackSort build() => TrackSort.title;

  /// The order currently applied.
  TrackSort get order => state;

  /// Switches to [order].
  set order(TrackSort order) => state = order;
}
