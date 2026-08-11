import 'package:flutter/material.dart';

/// Temporary placeholder for the splash screen.
///
/// Fully built in a later stage: initializing dependencies and deciding the
/// initial destination.
class SplashScreen extends StatelessWidget {
  /// Creates a [SplashScreen].
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox.shrink());
  }
}
