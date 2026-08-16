import 'dart:io';

import 'package:flutter/material.dart';

/// A square image loaded from a file on disk (typically cached artwork).
///
/// Decodes at [size] logical pixels (scaled by the device's pixel ratio)
/// rather than the source file's full resolution: embedded album art can
/// be far larger than the thumbnail it's shown at, and decoding it at full
/// size wastes memory for no visible benefit.
class CachedSquareImage extends StatelessWidget {
  /// Creates a [CachedSquareImage].
  const CachedSquareImage({required this.path, required this.size, super.key});

  /// Path to the image file.
  final String path;

  /// The image's side length, in logical pixels.
  final double size;

  @override
  Widget build(BuildContext context) {
    final cacheSize = (size * MediaQuery.devicePixelRatioOf(context)).round();
    return Image.file(
      File(path),
      width: size,
      height: size,
      fit: BoxFit.cover,
      cacheWidth: cacheSize,
      cacheHeight: cacheSize,
    );
  }
}
