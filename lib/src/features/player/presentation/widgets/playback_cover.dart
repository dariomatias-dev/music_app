import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/features/player/presentation/widgets/track_artwork.dart';

/// The playback screen's large cover.
///
/// Breathes gently while playing, follows a horizontal drag with a slight
/// tilt, and cross-fades when the track changes. Sized to fit both the
/// screen's width and height, so short screens don't overflow.
class PlaybackCover extends StatefulWidget {
  /// Creates a [PlaybackCover].
  const PlaybackCover({required this.item, required this.playing, super.key});

  /// The track whose artwork to show.
  final QueueMediaItem item;

  /// Whether playback is active, driving the breathing animation.
  final bool playing;

  @override
  State<PlaybackCover> createState() => _PlaybackCoverState();
}

class _PlaybackCoverState extends State<PlaybackCover>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breath = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4200),
  )..repeat(reverse: true);

  var _dragX = 0.0;

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final screenSize = MediaQuery.sizeOf(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final artSize = math
        .min(screenSize.width - 96, screenSize.height * 0.38)
        .clamp(140.0, 320.0);
    // Rubber-band the drag so the cover never runs off with the finger.
    final offset = _dragX.sign * (_dragX.abs() * 0.55).clamp(0.0, 90.0);
    final tilt = offset / artSize * 0.10;

    return GestureDetector(
      onHorizontalDragStart: (_) => setState(() => _dragX = 0),
      onHorizontalDragUpdate: (details) =>
          setState(() => _dragX += details.delta.dx),
      onHorizontalDragEnd: (_) => setState(() => _dragX = 0),
      child: AnimatedBuilder(
        animation: _breath,
        builder: (context, child) {
          final t = Curves.easeInOut.transform(_breath.value);
          final scale =
              (widget.playing && !reduceMotion ? 1 + 0.018 * t : 1.0) -
              (offset.abs() / artSize) * 0.06;
          return Transform.translate(
            offset: Offset(offset, 0),
            child: Transform.rotate(
              angle: tilt,
              child: Transform.scale(scale: scale, child: child),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.extraLarge),
            boxShadow: AppElevations.high(colors.shadow),
          ),
          child: AnimatedSwitcher(
            duration: AppDurations.base,
            switchInCurve: AppCurves.emphasized,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.94, end: 1).animate(animation),
                child: child,
              ),
            ),
            child: TrackArtwork(
              key: ValueKey(widget.item.id),
              item: widget.item,
              size: artSize,
              radius: AppRadius.extraLarge,
            ),
          ),
        ),
      ),
    );
  }
}
