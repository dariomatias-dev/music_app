import 'package:flutter/widgets.dart';
import 'package:music_app/src/core/navigation/app_router.dart';

/// Navigation into the storage screen.
abstract final class StorageNavigator {
  /// Pushes the storage screen.
  static Future<void> openStorage(BuildContext context) {
    return const StorageRoute().push(context);
  }
}
