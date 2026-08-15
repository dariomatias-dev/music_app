import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// One tile of a playlist cover mosaic: a track's artwork, identified by a
/// seed (its id, for the procedural fallback) and the cached album artwork
/// path, when any.
typedef PlaylistCoverTrack = ({String seed, String? artworkPath});

/// A playlist's cover: a 2x2 mosaic composed from up to 4 of its tracks'
/// artwork, repeating them if there are fewer than 4. Falls back to a
/// single procedural cover, keyed by [playlistId], for an empty playlist.
class PlaylistCoverArt extends StatelessWidget {
  /// Creates a [PlaylistCoverArt].
  const PlaylistCoverArt({
    required this.playlistId,
    required this.tracks,
    required this.size,
    this.radius = AppRadius.large,
    super.key,
  });

  /// The playlist, used as the fallback cover's seed when [tracks] is
  /// empty.
  final String playlistId;

  /// Up to 4 tracks to compose the mosaic from (extras are ignored).
  final List<PlaylistCoverTrack> tracks;

  /// The cover's side length.
  final double size;

  /// Corner radius applied to the whole mosaic.
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return AppArtwork(seed: playlistId, size: size, radius: radius);
    }

    final half = size / 2;
    final quadrants = List.generate(4, (i) => tracks[i % tracks.length]);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _tile(quadrants[0], half),
                _tile(quadrants[1], half),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _tile(quadrants[2], half),
                _tile(quadrants[3], half),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(PlaylistCoverTrack track, double side) {
    final path = track.artworkPath;
    if (path == null) {
      return AppArtwork(seed: track.seed, size: side, radius: 0);
    }
    return Image.file(
      File(path),
      width: side,
      height: side,
      fit: BoxFit.cover,
    );
  }
}
