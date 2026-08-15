import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// A minimal bar chart: one bar per entry in [values], scaled relative to
/// the largest value.
class StatisticsBarChart extends StatelessWidget {
  /// Creates a [StatisticsBarChart].
  const StatisticsBarChart({required this.values, this.height = 96, super.key});

  /// The bars' values, left to right.
  final List<int> values;

  /// The chart's height.
  final double height;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return SizedBox(height: height);

    final colors = context.colors;
    final maxValue = values.reduce(math.max);

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final value in values)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: FractionallySizedBox(
                  alignment: Alignment.bottomCenter,
                  heightFactor: maxValue == 0
                      ? 0.02
                      : math.max(value / maxValue, 0.02),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: value == 0 ? colors.surface : colors.accent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
