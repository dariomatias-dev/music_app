import 'package:flutter/widgets.dart';
import 'package:music_app/src/core/navigation/app_router.dart';

/// Navigation into the statistics screen.
abstract final class StatisticsNavigator {
  /// Pushes the statistics screen.
  static Future<void> openStatistics(BuildContext context) {
    return const StatisticsRoute().push(context);
  }
}
