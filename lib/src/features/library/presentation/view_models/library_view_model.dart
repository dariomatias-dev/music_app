import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_view_model.g.dart';

/// The library's content types, switched between with a segmented control.
enum LibrarySection {
  /// Every indexed track.
  tracks,

  /// Every indexed album.
  albums,

  /// Every indexed artist.
  artists,

  /// User-created playlists.
  playlists,

  /// Favorited tracks.
  favorites,
}

/// Which [LibrarySection] the library screen is currently showing.
@riverpod
class LibraryViewModel extends _$LibraryViewModel {
  @override
  LibrarySection build() => LibrarySection.tracks;

  /// The section currently shown.
  LibrarySection get section => state;

  /// Switches to [section].
  set section(LibrarySection section) => state = section;
}
