import 'package:app_ui/src/components/states/app_state_layout.dart';
import 'package:flutter/material.dart';

/// Shown when an operation succeeds but there is no data to display.
class AppEmptyState extends StatelessWidget {
  /// Creates an [AppEmptyState].
  const AppEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
  });

  /// Contextual icon.
  final IconData icon;

  /// Short title.
  final String title;

  /// Longer explanatory message.
  final String message;

  @override
  Widget build(BuildContext context) {
    return AppStateLayout(icon: icon, title: title, message: message);
  }
}
