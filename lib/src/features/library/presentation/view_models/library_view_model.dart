import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_view_model.g.dart';

/// The library's content types, switched between with a segmented control.
enum LibrarySection {
  /// User-created playlists.
  playlists,

  /// Every indexed track.
  tracks,

  /// Every indexed album.
  albums,

  /// Every indexed artist.
  artists,

  /// Favorited tracks.
  favorites,
}

/// Which [LibrarySection] the library screen is currently showing.
@riverpod
class LibraryViewModel extends _$LibraryViewModel {
  @override
  LibrarySection build() => LibrarySection.playlists;

  /// The section currently shown.
  LibrarySection get section => state;

  /// Switches to [section].
  set section(LibrarySection section) => state = section;
}
