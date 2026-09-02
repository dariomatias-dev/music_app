import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_spacing.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// Diameter of the circle the icon sits in.
const _iconContainerSize = 60.0;

/// Icon size inside that circle. Between `AppSizes.iconMedium` and
/// `iconLarge`, and particular to this layout rather than a step anyone
/// else should reach for.
const _iconSize = 26.0;

/// Title size, a step below what `AppTypography.rowTitle` carries.
const _titleFontSize = 15.0;

/// Gap between title and message, tighter than the smallest spacing step.
const _titleToMessageGap = 5.0;

/// Line height of the message, loosened for a centred paragraph.
const _messageLineHeight = 1.45;

/// The skeleton every state component is built on: an icon in a circle, a
/// title, a message, and whatever the state offers to do about it.
///
/// Deliberately not exported from `app_ui.dart`. The four states are the
/// public API; this exists so that changing how all of them look, or what
/// they measure, happens once instead of four times.
class AppStateLayout extends StatelessWidget {
  /// Creates an [AppStateLayout].
  const AppStateLayout({
    required this.icon,
    required this.title,
    required this.message,
    this.children = const [],
    super.key,
  });

  /// Contextual icon.
  final IconData icon;

  /// Short title.
  final String title;

  /// Longer explanatory message.
  final String message;

  /// Rendered below the message, in order. Each state supplies its own
  /// spacing, since what follows the message differs between them.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: _iconContainerSize,
              height: _iconContainerSize,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: _iconSize, color: colors.textTertiary),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.rowTitle.copyWith(
                color: colors.textPrimary,
                fontSize: _titleFontSize,
              ),
            ),
            const SizedBox(height: _titleToMessageGap),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.rowSubtitle.copyWith(
                color: colors.textSecondary,
                height: _messageLineHeight,
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
