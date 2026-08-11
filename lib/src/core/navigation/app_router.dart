import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/src/core/navigation/not_found_screen.dart';
import 'package:music_app/src/core/navigation/route_names.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
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
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
