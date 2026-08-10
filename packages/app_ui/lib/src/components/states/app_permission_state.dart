import 'package:app_ui/src/components/buttons/app_primary_button.dart';
import 'package:app_ui/src/components/buttons/app_text_button.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// Shown when the media access permission is not granted.
class AppPermissionState extends StatelessWidget {
  /// Creates an [AppPermissionState].
  const AppPermissionState({
    required this.icon,
    required this.title,
    required this.message,
    required this.grantLabel,
    required this.onGrant,
    this.isPermanentlyDenied = false,
    this.openSettingsLabel,
    this.onOpenSettings,
    super.key,
  });

  /// Contextual icon.
  final IconData icon;

  /// Short title.
  final String title;

  /// Explanation of why the permission is needed.
  final String message;

  /// Label of the action that requests the permission.
  final String grantLabel;

  /// Called when the grant action is tapped.
  final VoidCallback onGrant;

  /// Whether the permission was permanently denied, in which case only the
  /// system settings can change it.
  final bool isPermanentlyDenied;

  /// Label of the action that opens the system settings. Required together
  /// with [onOpenSettings] when [isPermanentlyDenied] is `true`.
  final String? openSettingsLabel;

  /// Called when the open-settings action is tapped.
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final settingsLabel = openSettingsLabel;
    final openSettings = onOpenSettings;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 26, color: colors.textTertiary),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.rowTitle.copyWith(
                color: colors.textPrimary,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.rowSubtitle.copyWith(
                color: colors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            if (isPermanentlyDenied)
              AppPrimaryButton(
                label: settingsLabel ?? grantLabel,
                onPressed: openSettings,
              )
            else ...[
              AppPrimaryButton(label: grantLabel, onPressed: onGrant),
              if (settingsLabel != null && openSettings != null) ...[
                const SizedBox(height: 8),
                AppTextButton(label: settingsLabel, onPressed: openSettings),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
