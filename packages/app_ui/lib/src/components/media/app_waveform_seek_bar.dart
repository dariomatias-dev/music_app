import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/src/animations/pressable.dart';
import 'package:app_ui/src/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Scrubbable waveform progress track.
///
/// Bars near the playhead breathe while [isPlaying]. Tap to seek directly,
/// or drag anywhere to scrub; [onSeek] fires continuously while dragging.
class AppWaveformSeekBar extends StatefulWidget {
  /// Creates an [AppWaveformSeekBar].
  const AppWaveformSeekBar({
    required this.progress,
    required this.isPlaying,
    required this.seed,
    required this.onSeek,
    this.height = 44,
    this.barCount = 72,
    super.key,
  });

  /// Playback progress, from 0 to 1.
  final double progress;

  /// Whether the waveform breathes near the playhead.
  final bool isPlaying;

  /// Seeds the deterministic bar heights, so the same track always draws
  /// the same waveform shape.
  final int seed;

  /// Called with the new progress (0 to 1) while tapping or dragging.
  final ValueChanged<double> onSeek;

  /// The track's height.
  final double height;

  /// Number of bars drawn.
  final int barCount;

  @override
  State<AppWaveformSeekBar> createState() => _AppWaveformSeekBarState();
}

class _AppWaveformSeekBarState extends State<AppWaveformSeekBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  late List<double> _amps = _buildAmps(widget.seed, widget.barCount);
  double? _dragProgress;

  static List<double> _buildAmps(int seed, int count) {
    final random = math.Random(seed);
    return List.generate(count, (i) {
      // Slow swell + per-bar noise reads like a real waveform; a single
      // sine envelope would just taper at both ends.
      final swell = 0.5 + 0.5 * math.sin(i * 0.19 + seed % 7);
      final noise = random.nextDouble();
      return (0.30 + swell * 0.34 + noise * 0.34).clamp(0.15, 1.0);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPulse();
  }

  @override
  void didUpdateWidget(AppWaveformSeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seed != widget.seed ||
        oldWidget.barCount != widget.barCount) {
      _amps = _buildAmps(widget.seed, widget.barCount);
    }
    _syncPulse();
  }

  void _syncPulse() {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (widget.isPlaying && !reduceMotion && !_pulse.isAnimating) {
      unawaited(_pulse.repeat());
    } else if ((!widget.isPlaying || reduceMotion) && _pulse.isAnimating) {
      _pulse.stop();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _handle(Offset local, double width, {bool commit = false}) {
    final progress = (local.dx / width).clamp(0.0, 1.0);
    setState(() => _dragProgress = commit ? null : progress);
    widget.onSeek(progress);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            if (Pressable.hapticsEnabled) {
              unawaited(HapticFeedback.selectionClick());
            }
            _handle(details.localPosition, width, commit: true);
          },
          onHorizontalDragStart: (details) =>
              _handle(details.localPosition, width),
          onHorizontalDragUpdate: (details) =>
              _handle(details.localPosition, width),
          onHorizontalDragEnd: (_) {
            if (Pressable.hapticsEnabled) {
              unawaited(HapticFeedback.selectionClick());
            }
            setState(() => _dragProgress = null);
          },
          child: SizedBox(
            height: widget.height,
            width: width,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) => CustomPaint(
                painter: _WaveformPainter(
                  amps: _amps,
                  progress: _dragProgress ?? widget.progress,
                  phase: _pulse.value,
                  animate: widget.isPlaying && !reduceMotion,
                  played: colors.textPrimary,
                  remaining: colors.textPrimary.withValues(alpha: 0.20),
                  scrubbing: _dragProgress != null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WaveformPainter extends CustomPainter {
  _WaveformPainter({
    required this.amps,
    required this.progress,
    required this.phase,
    required this.animate,
    required this.played,
    required this.remaining,
    required this.scrubbing,
  });

  final List<double> amps;
  final double progress;
  final double phase;
  final bool animate;
  final Color played;
  final Color remaining;
  final bool scrubbing;

  @override
  void paint(Canvas canvas, Size size) {
    final n = amps.length;
    final slot = size.width / n;
    final barWidth = math.max(1.5, slot * 0.52);
    final mid = size.height / 2;
    final playedBars = progress * n;

    for (var i = 0; i < n; i++) {
      var amplitude = amps[i];
      if (animate) {
        final wobble = math.sin((phase * math.pi * 2) + i * 0.55) * 0.5 + 0.5;
        final near = 1 - ((i - playedBars).abs() / 12).clamp(0.0, 1.0);
        amplitude = (amplitude * (1 + wobble * 0.35 * near)).clamp(0.1, 1.0);
      }
      final height = math.max<double>(
        2,
        amplitude * size.height * (scrubbing ? 1.0 : 0.92),
      );
      final x = i * slot + (slot - barWidth) / 2;
      final isPlayed = i < playedBars;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, mid - height / 2, barWidth, height),
          Radius.circular(barWidth),
        ),
        Paint()..color = isPlayed ? played : remaining,
      );
    }

    final playheadX = (progress * size.width).clamp(0.0, size.width);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(playheadX - 1.5, 0, 3, size.height),
        const Radius.circular(3),
      ),
      Paint()..color = played,
    );
    if (scrubbing) {
      canvas.drawCircle(Offset(playheadX, mid), 7, Paint()..color = played);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.phase != phase ||
      oldDelegate.animate != animate ||
      oldDelegate.scrubbing != scrubbing ||
      oldDelegate.played != played;
}
