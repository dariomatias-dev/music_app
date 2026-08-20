/// Paths of every route, used for route registration and redirect
/// comparisons.
///
/// Navigation to a route with parameters (album, artist, playlist) should
/// go through its navigator in `navigation/navigators/`, which pushes by
/// name with typed parameters instead of building a path here.
abstract final class RoutePaths {
  /// The splash route.
  static const splash = '/splash';

  /// The onboarding route.
  static const onboarding = '/onboarding';

  /// The media permission route.
  static const permissions = '/permissions';

  /// The Home tab.
  static const home = '/home';

  /// The Search tab.
  static const search = '/search';

  /// The Library tab.
  static const library = '/library';

  /// The Settings tab.
  static const settings = '/settings';

  /// The playback screen.
  static const player = '/player';

  /// The lyrics screen.
  static const lyrics = '/player/lyrics';

  /// The playback queue screen.
  static const queue = '/player/queue';

  /// Route pattern for the album detail screen, for registration.
  static const albumPattern = '/albums/:albumId';

  /// Route pattern for the artist detail screen, for registration.
  static const artistPattern = '/artists/:artistId';

  /// Route pattern for the playlist detail screen, for registration.
  static const playlistPattern = '/playlists/:playlistId';

  /// The storage screen.
  ///
  /// A stub until Fase 19.
  static const storage = '/storage';

  /// The statistics screen.
  static const statistics = '/statistics';

  /// The about screen.
  static const about = '/about';
}
