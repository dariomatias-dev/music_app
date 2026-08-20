import 'package:flutter/widgets.dart';
import 'package:music_app/src/core/navigation/app_router.dart';

/// Navigation into the playback screen and the routes nested under it.
abstract final class PlayerNavigator {
  /// Pushes the playback screen.
  static Future<void> openPlayer(BuildContext context) {
    return const PlayerRoute().push(context);
  }

  /// Pushes the lyrics screen, nested under the playback screen.
  static Future<void> openLyrics(BuildContext context) {
    return const LyricsRoute().push(context);
  }

  /// Pushes the playback queue screen, nested under the playback screen.
  static Future<void> openQueue(BuildContext context) {
    return const QueueRoute().push(context);
  }
}
