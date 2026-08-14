import 'package:flutter/material.dart';

/// Temporary placeholder for the playback ("Now Playing") screen.
///
/// Fully built in a later stage: ViewModel, cover, controls and handling
/// of an absent track.
class PlaybackScreen extends StatelessWidget {
  /// Creates a [PlaybackScreen].
  const PlaybackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox.shrink());
  }
}
