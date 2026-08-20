import 'package:flutter/widgets.dart';
import 'package:music_app/src/core/navigation/app_router.dart';

/// Navigation into album and artist detail screens.
abstract final class LibraryNavigator {
  /// Pushes the album detail screen for [albumId].
  static Future<void> openAlbum(
    BuildContext context, {
    required String albumId,
  }) {
    return AlbumRoute(albumId: albumId).push(context);
  }

  /// Pushes the artist detail screen for [artistId].
  static Future<void> openArtist(
    BuildContext context, {
    required String artistId,
  }) {
    return ArtistRoute(artistId: artistId).push(context);
  }
}
