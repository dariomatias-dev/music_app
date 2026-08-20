import 'package:flutter/widgets.dart';
import 'package:music_app/src/core/navigation/app_router.dart';

/// Navigation into the playlist detail screen.
abstract final class PlaylistNavigator {
  /// Pushes the playlist detail screen for [playlistId].
  static Future<void> openPlaylist(
    BuildContext context, {
    required String playlistId,
  }) {
    return PlaylistRoute(playlistId: playlistId).push(context);
  }
}
