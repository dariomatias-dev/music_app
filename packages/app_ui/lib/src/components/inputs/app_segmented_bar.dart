import 'package:app_ui/src/animations/pressable.dart';
import 'package:app_ui/src/components/inputs/app_filter_chip.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_curves.dart';
import 'package:app_ui/src/tokens/app_durations.dart';
import 'package:app_ui/src/tokens/app_radius.dart';
import 'package:flutter/material.dart';

/// A pill-shaped segmented control with a sliding selection indicator.
///
/// Used to switch between several views of the same list (e.g. a stats
/// window), as opposed to filtering, which belongs in [AppFilterChip]
/// instead.
class AppSegmentedBar extends StatelessWidget {
  /// Creates an [AppSegmentedBar].
  const AppSegmentedBar({
    required this.labels,
    required this.index,
    required this.onChanged,
    super.key,
  });

  /// The segments' labels.
  final List<String> labels;

  /// The selected segment's index.
  final int index;

  /// Called with the new index when a segment is tapped.
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: 38,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final slot = constraints.maxWidth / labels.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: AppDurations.resolve(context, AppDurations.base),
                curve: AppCurves.emphasized,
                left: slot * index,
                top: 0,
                bottom: 0,
                width: slot,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < labels.length; i++)
                    Expanded(
                      child: Semantics(
                        button: true,
                        selected: i == index,
                        child: Pressable(
                          onTap: () => onChanged(i),
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: AppDurations.resolve(
                                context,
                                AppDurations.base,
                              ),
                              style: DefaultTextStyle.of(context).style
                                  .copyWith(
                                    fontSize: 12,
                                    fontWeight: i == index
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    letterSpacing: -0.2,
                                    color: i == index
                                        ? colors.textPrimary
                                        : colors.textSecondary,
                                  ),
                              child: Text(
                                labels[i],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
