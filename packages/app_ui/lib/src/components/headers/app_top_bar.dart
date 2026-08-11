import 'package:app_ui/src/components/buttons/app_icon_button.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_durations.dart';
import 'package:app_ui/src/tokens/app_metrics.dart';
import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

/// The top bar used by every screen.
class AppTopBar extends StatelessWidget {
  /// Creates an [AppTopBar].
  const AppTopBar({
    this.backButtonSemanticLabel,
    this.title,
    this.leading,
    this.trailing,
    this.onBack,
    this.centerTitle = true,
    this.showBack = true,
    super.key,
  }) : assert(
         !showBack || backButtonSemanticLabel != null,
         'backButtonSemanticLabel is required when showBack is true and '
         'leading is not set.',
       );

  /// Spoken by screen readers for the default back button. Required when
  /// [showBack] is `true` and [leading] is not set.
  final String? backButtonSemanticLabel;

  /// The bar's title.
  final String? title;

  /// Custom leading widget, replacing the default back button.
  final Widget? leading;

  /// Custom trailing widget.
  final Widget? trailing;

  /// Called when the default back button is tapped. Defaults to popping
  /// the current route.
  final VoidCallback? onBack;

  /// Whether the title is centered.
  final bool centerTitle;

  /// Whether the default back button is shown when [leading] is not set.
  /// Root tabs, which have nothing to go back to, pass `false`.
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: AppMetrics.appBarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: Row(
          children: [
            leading ??
                (showBack
                    ? AppIconButton(
                        icon: Icons.arrow_back,
                        semanticLabel: backButtonSemanticLabel!,
                        onPressed:
                            onBack ?? () => Navigator.of(context).maybePop(),
                      )
                    : const SizedBox(width: 44)),
            Expanded(
              child: AnimatedSwitcher(
                duration: AppDurations.resolve(context, AppDurations.base),
                child: Text(
                  title ?? '',
                  key: ValueKey(title),
                  textAlign: centerTitle ? TextAlign.center : TextAlign.left,
                  style: AppTypography.appBar.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ),
            trailing ?? const SizedBox(width: 44),
          ],
        ),
      ),
    );
  }
}
