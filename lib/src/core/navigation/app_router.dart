import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/src/core/navigation/main_shell.dart';
import 'package:music_app/src/core/navigation/not_found_screen.dart';
import 'package:music_app/src/core/navigation/route_names.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
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
import 'package:music_app/src/features/queue/presentation/screens/queue_screen.dart';
import 'package:music_app/src/features/search/presentation/screens/search_screen.dart';
import 'package:music_app/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:music_app/src/features/splash/presentation/screens/splash_screen.dart';

/// Provides the app's [GoRouter].
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    redirect: (context, state) => appRouteRedirect(ref: ref, state: state),
    routes: [
      GoRoute(
        name: RouteNames.splash,
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: RouteNames.onboarding,
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        name: RouteNames.permissions,
        path: RoutePaths.permissions,
        builder: (context, state) => const PermissionScreen(),
      ),
      GoRoute(
        name: RouteNames.album,
        path: RoutePaths.albumPattern,
        builder: (context, state) => AlbumScreen(
          albumId: state.pathParameters['albumId']!,
        ),
      ),
      GoRoute(
        name: RouteNames.artist,
        path: RoutePaths.artistPattern,
        builder: (context, state) => ArtistScreen(
          artistId: state.pathParameters['artistId']!,
        ),
      ),
      GoRoute(
        name: RouteNames.player,
        path: RoutePaths.player,
        pageBuilder: (context, state) => buildVerticalTransitionPage(
          key: state.pageKey,
          child: const PlaybackScreen(),
        ),
        routes: [
          GoRoute(
            name: RouteNames.lyrics,
            path: 'lyrics',
            builder: (context, state) => const LyricsScreen(),
          ),
          GoRoute(
            name: RouteNames.queue,
            path: 'queue',
            builder: (context, state) => const QueueScreen(),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.home,
                path: RoutePaths.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.search,
                path: RoutePaths.search,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.library,
                path: RoutePaths.library,
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.settings,
                path: RoutePaths.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
