import 'package:app_ui/src/components/buttons/app_primary_button.dart';
import 'package:app_ui/src/components/states/app_state_layout.dart';
import 'package:app_ui/src/tokens/app_spacing.dart';
import 'package:flutter/material.dart';

/// Shown when the main available action is repeating an operation (e.g.
/// re-scanning the library), without necessarily being an error.
class AppRetryState extends StatelessWidget {
  /// Creates an [AppRetryState].
  const AppRetryState({
    required this.icon,
    required this.title,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
    super.key,
  });

  /// Contextual icon.
  final IconData icon;

  /// Short title.
  final String title;

  /// Explanatory message.
  final String message;

  /// Label of the retry action.
  final String retryLabel;

  /// Called when the retry action is tapped.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AppStateLayout(
      icon: icon,
      title: title,
      message: message,
      children: [
        const SizedBox(height: AppSpacing.lg),
        AppPrimaryButton(label: retryLabel, onPressed: onRetry),
      ],
    );
  }
}
