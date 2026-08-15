/// Paths of every route, used for navigation instead of literal strings.
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

  /// Route pattern for the album detail screen, for registration; use
  /// [album] to build a concrete path for navigation.
  static const albumPattern = '/albums/:albumId';

  /// The album detail screen for [albumId].
  static String album(String albumId) => '/albums/$albumId';

  /// Route pattern for the artist detail screen, for registration; use
  /// [artist] to build a concrete path for navigation.
  static const artistPattern = '/artists/:artistId';

  /// The artist detail screen for [artistId].
  static String artist(String artistId) => '/artists/$artistId';
}
