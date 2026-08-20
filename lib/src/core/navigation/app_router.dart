import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/src/core/navigation/main_shell.dart';
import 'package:music_app/src/core/navigation/not_found_screen.dart';
import 'package:music_app/src/core/navigation/route_redirect.dart';
import 'package:music_app/src/core/navigation/route_transitions.dart';
import 'package:music_app/src/features/home/presentation/screens/home_screen.dart';
import 'package:music_app/src/features/library/presentation/screens/album_screen.dart';
import 'package:music_app/src/features/library/presentation/screens/artist_screen.dart';
import 'package:music_app/src/features/library/presentation/screens/library_screen.dart';
import 'package:music_app/src/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:music_app/src/features/onboarding/presentation/screens/permission_screen.dart';
import 'package:music_app/src/features/player/presentation/screens/lyrics_screen.dart';
import 'package:music_app/src/features/player/presentation/screens/playback_screen.dart';
import 'package:music_app/src/features/playlist/presentation/screens/playlist_screen.dart';
import 'package:music_app/src/features/queue/presentation/screens/queue_screen.dart';
import 'package:music_app/src/features/search/presentation/screens/search_screen.dart';
import 'package:music_app/src/features/settings/presentation/screens/about_screen.dart';
import 'package:music_app/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:music_app/src/features/splash/presentation/screens/splash_screen.dart';
import 'package:music_app/src/features/statistics/presentation/screens/statistics_screen.dart';
import 'package:music_app/src/features/storage/presentation/screens/storage_screen.dart';

part 'app_router.g.dart';

/// Provides the app's [GoRouter].
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: const SplashRoute().location,
    redirect: (context, state) => appRouteRedirect(ref: ref, state: state),
    routes: $appRoutes,
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});

/// The splash route.
@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData with $SplashRoute {
  /// Creates a [SplashRoute].
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SplashScreen();
}

/// The onboarding route.
@TypedGoRoute<OnboardingRoute>(path: '/onboarding')
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  /// Creates an [OnboardingRoute].
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OnboardingScreen();
}

/// The media permission route.
@TypedGoRoute<PermissionsRoute>(path: '/permissions')
class PermissionsRoute extends GoRouteData with $PermissionsRoute {
  /// Creates a [PermissionsRoute].
  const PermissionsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PermissionScreen();
}

/// The album detail screen for [albumId].
@TypedGoRoute<AlbumRoute>(path: '/albums/:albumId')
class AlbumRoute extends GoRouteData with $AlbumRoute {
  /// Creates an [AlbumRoute].
  const AlbumRoute({required this.albumId});

  /// The album to show.
  final String albumId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      AlbumScreen(albumId: albumId);
}

/// The artist detail screen for [artistId].
@TypedGoRoute<ArtistRoute>(path: '/artists/:artistId')
class ArtistRoute extends GoRouteData with $ArtistRoute {
  /// Creates an [ArtistRoute].
  const ArtistRoute({required this.artistId});

  /// The artist to show.
  final String artistId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ArtistScreen(artistId: artistId);
}

/// The playlist detail screen for [playlistId].
@TypedGoRoute<PlaylistRoute>(path: '/playlists/:playlistId')
class PlaylistRoute extends GoRouteData with $PlaylistRoute {
  /// Creates a [PlaylistRoute].
  const PlaylistRoute({required this.playlistId});

  /// The playlist to show.
  final String playlistId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PlaylistScreen(playlistId: playlistId);
}

/// The storage screen.
@TypedGoRoute<StorageRoute>(path: '/storage')
class StorageRoute extends GoRouteData with $StorageRoute {
  /// Creates a [StorageRoute].
  const StorageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const StorageScreen();
}

/// The statistics screen.
@TypedGoRoute<StatisticsRoute>(path: '/statistics')
class StatisticsRoute extends GoRouteData with $StatisticsRoute {
  /// Creates a [StatisticsRoute].
  const StatisticsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const StatisticsScreen();
}

/// The about screen.
@TypedGoRoute<AboutRoute>(path: '/about')
class AboutRoute extends GoRouteData with $AboutRoute {
  /// Creates an [AboutRoute].
  const AboutRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AboutScreen();
}

/// The playback screen, and the routes nested under it.
@TypedGoRoute<PlayerRoute>(
  path: '/player',
  routes: [
    TypedGoRoute<LyricsRoute>(path: 'lyrics'),
    TypedGoRoute<QueueRoute>(path: 'queue'),
  ],
)
class PlayerRoute extends GoRouteData with $PlayerRoute {
  /// Creates a [PlayerRoute].
  const PlayerRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildVerticalTransitionPage(
      key: state.pageKey,
      child: const PlaybackScreen(),
    );
  }
}

/// The lyrics screen, nested under [PlayerRoute].
class LyricsRoute extends GoRouteData with $LyricsRoute {
  /// Creates a [LyricsRoute].
  const LyricsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LyricsScreen();
}

/// The playback queue screen, nested under [PlayerRoute].
class QueueRoute extends GoRouteData with $QueueRoute {
  /// Creates a [QueueRoute].
  const QueueRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const QueueScreen();
}

/// The main shell hosting the four root tabs, each its own branch so its
/// navigation state is preserved when switching tabs.
@TypedStatefulShellRoute<MainShellRouteData>(
  branches: [
    TypedStatefulShellBranch<HomeBranchData>(
      routes: [TypedGoRoute<HomeRoute>(path: '/home')],
    ),
    TypedStatefulShellBranch<SearchBranchData>(
      routes: [TypedGoRoute<SearchRoute>(path: '/search')],
    ),
    TypedStatefulShellBranch<LibraryBranchData>(
      routes: [TypedGoRoute<LibraryRoute>(path: '/library')],
    ),
    TypedStatefulShellBranch<SettingsBranchData>(
      routes: [TypedGoRoute<SettingsRoute>(path: '/settings')],
    ),
  ],
)
class MainShellRouteData extends StatefulShellRouteData {
  /// Creates a [MainShellRouteData].
  const MainShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MainShell(navigationShell: navigationShell);
  }
}

/// The Home tab's branch.
class HomeBranchData extends StatefulShellBranchData {
  /// Creates a [HomeBranchData].
  const HomeBranchData();
}

/// The Home tab.
class HomeRoute extends GoRouteData with $HomeRoute {
  /// Creates a [HomeRoute].
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

/// The Search tab's branch.
class SearchBranchData extends StatefulShellBranchData {
  /// Creates a [SearchBranchData].
  const SearchBranchData();
}

/// The Search tab.
class SearchRoute extends GoRouteData with $SearchRoute {
  /// Creates a [SearchRoute].
  const SearchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SearchScreen();
}

/// The Library tab's branch.
class LibraryBranchData extends StatefulShellBranchData {
  /// Creates a [LibraryBranchData].
  const LibraryBranchData();
}

/// The Library tab.
class LibraryRoute extends GoRouteData with $LibraryRoute {
  /// Creates a [LibraryRoute].
  const LibraryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LibraryScreen();
}

/// The Settings tab's branch.
class SettingsBranchData extends StatefulShellBranchData {
  /// Creates a [SettingsBranchData].
  const SettingsBranchData();
}

/// The Settings tab.
class SettingsRoute extends GoRouteData with $SettingsRoute {
  /// Creates a [SettingsRoute].
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}
