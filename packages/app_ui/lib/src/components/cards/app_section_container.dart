import 'package:app_ui/src/components/cards/app_card.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_radius.dart';
import 'package:flutter/material.dart';

/// Groups related content (e.g. a set of settings rows) into a single
/// rounded surface.
///
/// Unlike [AppCard], which represents one discrete, often tappable card,
/// this is a passive grouping surface for several items.
class AppSectionContainer extends StatelessWidget {
  /// Creates an [AppSectionContainer].
  const AppSectionContainer({required this.child, super.key});

  /// The section's content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
