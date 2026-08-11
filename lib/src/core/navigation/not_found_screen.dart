import 'package:flutter/material.dart';

/// Shown when navigating to an unknown route.
class NotFoundScreen extends StatelessWidget {
  /// Creates a [NotFoundScreen].
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Icon(Icons.error_outline)));
  }
}
