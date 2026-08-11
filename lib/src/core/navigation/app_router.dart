import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/src/core/navigation/main_shell.dart';
import 'package:music_app/src/core/navigation/not_found_screen.dart';
import 'package:music_app/src/core/navigation/route_names.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/features/home/presentation/screens/home_screen.dart';
import 'package:music_app/src/features/library/presentation/screens/library_screen.dart';
import 'package:music_app/src/features/search/presentation/screens/search_screen.dart';
import 'package:music_app/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:music_app/src/features/splash/presentation/screens/splash_screen.dart';

/// Provides the app's [GoRouter].
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    routes: [
      GoRoute(
        name: RouteNames.splash,
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
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
