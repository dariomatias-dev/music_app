import 'dart:typed_data';

import 'package:music_app/src/core/errors/app_exception.dart';

/// Disk cache for cover artwork extracted from audio files.
///
/// Every method reports a failed disk operation as a [FileException].
abstract interface class ArtworkCache {
  /// Writes [data] to the cache under [id] and returns the resulting file
  /// path.
  Future<String> save({
    required String id,
    required Uint8List data,
    required String mimeType,
  });

  /// Returns the cached file path for [id], or null if nothing is cached.
  Future<String?> pathFor(String id);

  /// Removes the cached artwork for [id], if any.
  Future<void> delete(String id);

  /// Removes every cached artwork.
  Future<void> clear();
}
