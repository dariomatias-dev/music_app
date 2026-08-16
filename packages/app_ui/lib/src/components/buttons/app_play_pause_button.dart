import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/src/animations/pressable.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:app_ui/src/tokens/app_durations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A filled, circular play/pause button with a morphing icon, an optional
/// progress ring, and a small bounce whenever [isPlaying] changes.
class AppPlayPauseButton extends StatefulWidget {
  /// Creates an [AppPlayPauseButton].
  const AppPlayPauseButton({
    required this.isPlaying,
    required this.onTap,
    this.progress,
    this.size = 64,
    this.filled = true,
    super.key,
  });

  /// Whether the button shows the pause icon (`true`) or the play icon
  /// (`false`).
  final bool isPlaying;

  /// Called when tapped.
  final VoidCallback onTap;

  /// Playback progress, from 0 to 1. When `null`, no ring is drawn.
  final double? progress;

  /// The button's diameter.
  final double size;

  /// Whether the button is filled with the accent color, or outlined.
  final bool filled;

  @override
  State<AppPlayPauseButton> createState() => _AppPlayPauseButtonState();
}

class _AppPlayPauseButtonState extends State<AppPlayPauseButton>
    with TickerProviderStateMixin {
  late final AnimationController _icon = AnimationController(
    vsync: this,
    duration: AppDurations.base,
    value: widget.isPlaying ? 1 : 0,
  );
  late final AnimationController _bounce = AnimationController(
    vsync: this,
    duration: AppDurations.page,
    value: 1,
  );

  @override
  void didUpdateWidget(AppPlayPauseButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPlaying != widget.isPlaying) {
      if (widget.isPlaying) {
        unawaited(_icon.forward());
      } else {
        unawaited(_icon.reverse());
      }
      _bounce.value = 0;
      unawaited(_bounce.forward());
    }
  }

  @override
  void dispose() {
    _icon.dispose();
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = widget.filled ? colors.onAccent : colors.textPrimary;
    final ringSize = widget.size + 8;

    return SizedBox(
      width: ringSize,
      height: ringSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.progress case final progress?)
            CustomPaint(
              size: Size.square(ringSize - 4),
              painter: _ProgressRingPainter(
                progress: progress,
                track: colors.textPrimary.withValues(alpha: 0.12),
                fill: colors.textPrimary,
              ),
            ),
          Pressable(
            scale: 0.9,
            haptic: false,
            onTap: () {
              if (Pressable.hapticsEnabled) {
                unawaited(HapticFeedback.mediumImpact());
              }
              widget.onTap();
            },
            child: AnimatedBuilder(
              animation: _bounce,
              builder: (context, child) {
                final t = Curves.elasticOut.transform(
                  _bounce.value.clamp(0.001, 1),
                );
                return Transform.scale(scale: 0.92 + 0.08 * t, child: child);
              },
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.filled ? colors.accent : Colors.transparent,
                  border: widget.filled
                      ? null
                      : Border.all(color: colors.divider, width: 1.5),
                  boxShadow: widget.filled
                      ? [
                          BoxShadow(
                            color: colors.shadow,
                            blurRadius: widget.size * 0.28,
                            spreadRadius: -2,
                            offset: Offset(0, widget.size * 0.10),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Semantics(
                    button: true,
                    label: widget.isPlaying ? 'Pause' : 'Play',
                    child: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: _icon,
                      size: widget.size * 0.42,
                      color: foreground,
                    ),
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

class _ProgressRingPainter extends CustomPainter {
  _ProgressRingPainter({
    required this.progress,
    required this.track,
    required this.fill,
  });

  final double progress;
  final Color track;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: size.shortestSide / 2 - 1.5,
    );
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(rect.center, rect.width / 2, stroke..color = track);
    if (progress <= 0) return;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0.0, 1.0),
      false,
      stroke..color = fill,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.fill != fill;
}
