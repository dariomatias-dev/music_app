import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

/// Animated bars marking the currently playing row.
///
/// The bars move only while [playing], so the indicator itself says whether
/// audio is running, independent of any icon nearby.
class AppPlaybackIndicator extends StatefulWidget {
  /// Creates an [AppPlaybackIndicator].
  const AppPlaybackIndicator({
    required this.playing,
    this.color,
    this.size = 16,
    super.key,
  });

  /// Whether the bars animate.
  final bool playing;

  /// Bar color. Defaults to the theme's primary text color.
  final Color? color;

  /// The indicator's side length.
  final double size;

  @override
  State<AppPlaybackIndicator> createState() => _AppPlaybackIndicatorState();
}

class _AppPlaybackIndicatorState extends State<AppPlaybackIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    if (widget.playing) unawaited(_controller.repeat());
  }

  @override
  void didUpdateWidget(covariant AppPlaybackIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.playing && !_controller.isAnimating) {
      unawaited(_controller.repeat());
    } else if (!widget.playing && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? context.colors.textPrimary;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _EqualizerPainter(
            progress: _controller.value,
            color: color,
            playing: widget.playing,
          ),
        ),
      ),
    );
  }
}

class _EqualizerPainter extends CustomPainter {
  _EqualizerPainter({
    required this.progress,
    required this.color,
    required this.playing,
  });

  final double progress;
  final Color color;
  final bool playing;

  @override
  void paint(Canvas canvas, Size size) {
    const bars = 4;
    final slot = size.width / bars;
    final barWidth = slot * 0.5;
    for (var i = 0; i < bars; i++) {
      final phase = progress * math.pi * 2 + i * 1.1;
      final height = playing
          ? size.height * (0.25 + 0.75 * (0.5 + 0.5 * math.sin(phase)).abs())
          : size.height * 0.3;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            i * slot + (slot - barWidth) / 2,
            size.height - height,
            barWidth,
            height,
          ),
          Radius.circular(barWidth),
        ),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _EqualizerPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.playing != playing;
}
