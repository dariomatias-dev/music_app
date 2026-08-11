import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Standard transition for most routes: a fade with a small vertical rise
/// coming in, and a fade with a slight scale-down going out.
class AppPageTransitionsBuilder extends PageTransitionsBuilder {
  /// Creates an [AppPageTransitionsBuilder].
  const AppPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final incoming = CurvedAnimation(
      parent: animation,
      curve: AppCurves.emphasized,
    );
    final outgoing = CurvedAnimation(
      parent: secondaryAnimation,
      curve: AppCurves.emphasized,
    );

    return FadeTransition(
      opacity: incoming,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.035),
          end: Offset.zero,
        ).animate(incoming),
        child: FadeTransition(
          opacity: Tween<double>(begin: 1, end: 0).animate(outgoing),
          child: ScaleTransition(
            scale: Tween<double>(begin: 1, end: 0.97).animate(outgoing),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// The app's default [PageTransitionsTheme], applied to every route unless
/// overridden (e.g. the player screen's vertical transition).
const appPageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: AppPageTransitionsBuilder(),
    TargetPlatform.iOS: AppPageTransitionsBuilder(),
  },
);

/// Builds a [Page] that slides in vertically from the bottom, coherent with
/// opening the player from the mini player tucked at the bottom of the
/// screen.
Page<T> buildVerticalTransitionPage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final incoming = CurvedAnimation(
        parent: animation,
        curve: AppCurves.emphasized,
      );
      return SlideTransition(
        position: Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(incoming),
        child: child,
      );
    },
  );
}

/// Builds a [Hero] tag prefixed by [origin], since the four main tabs share
/// the same routes and would otherwise produce duplicate tags for the same
/// item (e.g. the same track appearing in both Home and Search).
String heroTagFor({required String origin, required String id}) =>
    '$origin-$id';
