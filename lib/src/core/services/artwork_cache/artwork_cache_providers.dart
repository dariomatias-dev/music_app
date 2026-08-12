import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/services/artwork_cache/artwork_cache.dart';
import 'package:music_app/src/core/services/artwork_cache/file_system_artwork_cache.dart';

/// Provides the [ArtworkCache] used across the app.
final artworkCacheProvider = Provider<ArtworkCache>(
  (ref) => const FileSystemArtworkCache(),
);
