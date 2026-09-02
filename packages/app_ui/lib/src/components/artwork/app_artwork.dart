import 'dart:math' as math;
import 'dart:typed_data';

import 'package:app_ui/src/tokens/app_radius.dart';
import 'package:flutter/material.dart';

/// A track, album or artist cover.
///
/// Shows the embedded image at [imageBytes] when present. Otherwise, draws a
/// deterministic procedural cover from [seed] (e.g. a track id), so the same
/// item always gets the same generated artwork.
class AppArtwork extends StatelessWidget {
  /// Creates an [AppArtwork].
  const AppArtwork({
    required this.seed,
    this.imageBytes,
    this.size,
    this.radius = AppRadius.medium,
    this.circle = false,
    super.key,
  });

  /// Identifier used to deterministically generate the procedural cover
  /// when [imageBytes] is not provided.
  final String seed;

  /// Bytes of an embedded cover image, if any.
  final Uint8List? imageBytes;

  /// The side length of the (square) artwork. When `null`, fills the
  /// available space.
  final double? size;

  /// Corner radius applied when [circle] is `false`.
  final double radius;

  /// Whether to clip the artwork as a circle instead of a rounded square.
  final bool circle;

  @override
  Widget build(BuildContext context) {
    final image = imageBytes;
    // Decoded at the size it is drawn at whenever that is known. Embedded
    // cover art routinely arrives at a thousand pixels a side and is shown
    // in a list row at forty, and decoding it whole costs the memory of
    // the pixels that get thrown away. Left full when `size` is null,
    // since the artwork then fills whatever space it is given.
    final decodeSize = size == null
        ? null
        : (size! * MediaQuery.devicePixelRatioOf(context)).round();
    final content = image != null
        ? Image.memory(
            image,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            width: double.infinity,
            height: double.infinity,
            cacheWidth: decodeSize,
            cacheHeight: decodeSize,
          )
        : CustomPaint(
            painter: _ArtworkPainter(seed: _fnv1aHash(seed)),
            isComplex: true,
            size: size == null ? Size.infinite : Size.square(size!),
          );

    final clipped = circle
        ? ClipOval(child: content)
        : ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: content,
          );

    if (size == null) return clipped;
    return SizedBox(width: size, height: size, child: clipped);
  }
}

/// Deterministic 32-bit FNV-1a hash, since [String.hashCode] is not
/// guaranteed to be stable across runs.
int _fnv1aHash(String input) {
  var hash = 0x811c9dc5;
  for (final codeUnit in input.codeUnits) {
    hash ^= codeUnit;
    hash = (hash * 0x01000193) & 0xFFFFFFFF;
  }
  return hash;
}

class _ArtworkPainter extends CustomPainter {
  _ArtworkPainter({required this.seed});

  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(seed);
    final rect = Offset.zero & size;
    // Seeds are hashes, so `seed % 5` alone would still clump; re-hash first.
    final variant = math.Random(seed * 2654435761 % 100003).nextInt(5);

    final topTone = 0.05 + rnd.nextDouble() * 0.16;
    final bottomTone = topTone + 0.34 + rnd.nextDouble() * 0.40;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_gray(topTone), _gray(bottomTone.clamp(0.0, 0.92))],
        ).createShader(rect),
    );

    switch (variant) {
      case 0:
        _paintForest(canvas, size, rnd);
      case 1:
        _paintCrackedDisc(canvas, size, rnd);
      case 2:
        _paintRidges(canvas, size, rnd);
      case 3:
        _paintFigureInFog(canvas, size, rnd);
      default:
        _paintLongExposure(canvas, size, rnd);
    }

    _paintHaze(canvas, size);
    _paintVignette(canvas, size);
    if (size.shortestSide > 40) _paintGrain(canvas, size, rnd);
  }

  Color _gray(double t) {
    final v = (t.clamp(0.0, 1.0) * 255).round();
    return Color.fromARGB(255, v, v, v);
  }

  void _paintForest(Canvas canvas, Size size, math.Random rnd) {
    // Three depth layers of conifers, back layers lighter (aerial
    // perspective).
    for (var layer = 0; layer < 3; layer++) {
      final tone = 0.34 - layer * 0.11;
      final paint = Paint()
        ..color = _gray(tone).withValues(alpha: 0.65 + layer * 0.15);
      final baseline = size.height * (0.72 + layer * 0.12);
      final count = 5 + layer * 3;
      for (var i = 0; i < count; i++) {
        final x = size.width * ((i + rnd.nextDouble() * 0.8) / count);
        final h =
            size.height * (0.18 + rnd.nextDouble() * 0.3) * (1 + layer * 0.25);
        final w = h * (0.20 + rnd.nextDouble() * 0.12);
        final path = Path()
          ..moveTo(x, baseline - h)
          ..lineTo(x + w, baseline)
          ..lineTo(x - w, baseline)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  void _paintCrackedDisc(Canvas canvas, Size size, math.Random rnd) {
    final center = Offset(size.width * 0.5, size.height * 0.48);
    final radius = size.shortestSide * (0.28 + rnd.nextDouble() * 0.06);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [_gray(0.96), _gray(0.72), _gray(0.55)],
          stops: const [0.0, 0.7, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    // Radial fracture lines.
    final crack = Paint()
      ..color = _gray(0.12).withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.8, size.shortestSide * 0.006);

    final spokes = 6 + rnd.nextInt(4);
    for (var i = 0; i < spokes; i++) {
      final angle = (i / spokes) * math.pi * 2 + rnd.nextDouble() * 0.4;
      final path = Path()..moveTo(center.dx, center.dy);
      var r = radius * 0.1;
      var a = angle;
      while (r < radius) {
        r += radius * (0.14 + rnd.nextDouble() * 0.1);
        a += (rnd.nextDouble() - 0.5) * 0.55;
        path.lineTo(center.dx + math.cos(a) * r, center.dy + math.sin(a) * r);
      }
      canvas.drawPath(path, crack);
    }

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = _gray(0.2).withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1, size.shortestSide * 0.008),
    );
  }

  void _paintRidges(Canvas canvas, Size size, math.Random rnd) {
    for (var layer = 0; layer < 4; layer++) {
      final baseY = size.height * (0.45 + layer * 0.14);
      final amp = size.height * (0.10 - layer * 0.015);
      final path = Path()..moveTo(0, baseY);
      var x = 0.0;
      var up = true;
      while (x < size.width) {
        final step = size.width * (0.12 + rnd.nextDouble() * 0.16);
        final y = baseY + (up ? -amp : amp * 0.4) * (0.5 + rnd.nextDouble());
        path
          ..lineTo(x + step * 0.5, y)
          ..lineTo(x + step, baseY + (rnd.nextDouble() - 0.5) * amp * 0.3);
        x += step;
        up = !up;
      }
      path
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(
        path,
        Paint()..color = _gray(0.5 - layer * 0.11).withValues(alpha: 0.8),
      );
    }
  }

  void _paintFigureInFog(Canvas canvas, Size size, math.Random rnd) {
    final groundY = size.height * 0.80;

    // Low sun behind the horizon.
    final glowCenter = Offset(
      size.width * (0.3 + rnd.nextDouble() * 0.4),
      groundY,
    );
    canvas
      ..drawCircle(
        glowCenter,
        size.shortestSide * 0.55,
        Paint()
          ..shader =
              RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.32),
                  Colors.white.withValues(alpha: 0),
                ],
              ).createShader(
                Rect.fromCircle(
                  center: glowCenter,
                  radius: size.shortestSide * 0.55,
                ),
              ),
      )
      ..drawRect(
        Rect.fromLTRB(0, groundY, size.width, size.height),
        Paint()..color = _gray(0.07).withValues(alpha: 0.92),
      );

    final x = size.width * (0.32 + rnd.nextDouble() * 0.36);
    final h = size.height * 0.17;
    final w = h * 0.24;
    final body = Path()
      ..moveTo(x - w * 0.5, groundY)
      ..lineTo(x - w * 0.35, groundY - h * 0.62)
      ..lineTo(x, groundY - h)
      ..lineTo(x + w * 0.35, groundY - h * 0.62)
      ..lineTo(x + w * 0.5, groundY)
      ..close();
    canvas
      ..drawPath(body, Paint()..color = _gray(0.08).withValues(alpha: 0.9))
      ..drawCircle(
        Offset(x, groundY - h - w * 0.35),
        w * 0.34,
        Paint()..color = _gray(0.08).withValues(alpha: 0.9),
      );
  }

  /// Still water under a low horizon: mirrored bands and a stretched
  /// highlight, the calmest of the five looks.
  void _paintLongExposure(Canvas canvas, Size size, math.Random rnd) {
    final horizon = size.height * (0.42 + rnd.nextDouble() * 0.12);

    canvas.drawRect(
      Rect.fromLTRB(0, horizon, size.width, size.height),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_gray(0.30), _gray(0.06)],
        ).createShader(Rect.fromLTRB(0, horizon, size.width, size.height)),
    );

    // Reflected highlight, faded on both axes so it has no hard edge even at
    // thumbnail size.
    final x = size.width * (0.3 + rnd.nextDouble() * 0.4);
    final glow = Rect.fromCenter(
      center: Offset(x, horizon + (size.height - horizon) * 0.35),
      width: size.width * 0.42,
      height: (size.height - horizon) * 1.4,
    );
    canvas.drawRect(
      glow,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.26),
            Colors.white.withValues(alpha: 0),
          ],
        ).createShader(glow),
    );

    // Ripple lines are lost below thumbnail size and only add noise there.
    if (size.shortestSide > 70) {
      final line = Paint()
        ..color = Colors.white.withValues(alpha: 0.10)
        ..strokeWidth = math.max(0.7, size.shortestSide * 0.004);
      for (var i = 0; i < 9; i++) {
        final y =
            horizon + (size.height - horizon) * (i / 9) + rnd.nextDouble() * 4;
        final half = size.width * (0.10 + rnd.nextDouble() * 0.30);
        canvas.drawLine(Offset(x - half, y), Offset(x + half, y), line);
      }
    }

    canvas.drawLine(
      Offset(0, horizon),
      Offset(size.width, horizon),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.18)
        ..strokeWidth = math.max(0.8, size.shortestSide * 0.005),
    );
  }

  void _paintHaze(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.white.withValues(alpha: 0.10),
            Colors.white.withValues(alpha: 0),
          ],
          stops: const [0.0, 0.5],
        ).createShader(rect),
    );
  }

  void _paintVignette(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          radius: 0.85,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.18),
            Colors.black.withValues(alpha: 0.42),
          ],
          stops: const [0.55, 0.82, 1.0],
        ).createShader(rect),
    );
  }

  void _paintGrain(Canvas canvas, Size size, math.Random rnd) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.05);
    final dots = (size.width * size.height / 260).clamp(40, 900).toInt();
    for (var i = 0; i < dots; i++) {
      canvas.drawCircle(
        Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        0.6,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ArtworkPainter oldDelegate) =>
      oldDelegate.seed != seed;
}
