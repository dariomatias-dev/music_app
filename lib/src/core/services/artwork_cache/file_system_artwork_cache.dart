import 'dart:io';
import 'dart:typed_data';

import 'package:music_app/src/core/errors/app_exception.dart';
import 'package:music_app/src/core/services/artwork_cache/artwork_cache.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const _extensionsByMimeType = {'image/png': 'png', 'image/jpeg': 'jpg'};
const _knownExtensions = ['jpg', 'png'];
const _fallbackExtension = 'jpg';

/// [ArtworkCache] implementation backed by the platform's cache directory.
class FileSystemArtworkCache implements ArtworkCache {
  /// Creates a [FileSystemArtworkCache].
  ///
  /// Reads from the platform's cache directory, or from [root] when
  /// provided (useful for tests).
  const FileSystemArtworkCache({Future<Directory> Function()? root})
    : _root = root ?? getApplicationCacheDirectory;

  final Future<Directory> Function() _root;

  @override
  Future<String> save({
    required String id,
    required Uint8List data,
    required String mimeType,
  }) async {
    return FileException.guard('Could not cache artwork for $id.', () async {
      final directory = await _cacheDirectory();
      final extension = _extensionsByMimeType[mimeType] ?? _fallbackExtension;
      final file = File(p.join(directory.path, '$id.$extension'));
      await file.writeAsBytes(data);
      return file.path;
    });
  }

  @override
  Future<String?> pathFor(String id) async {
    return FileException.guard(
      'Could not read cached artwork for $id.',
      () async {
        final directory = await _cacheDirectory();
        for (final extension in _knownExtensions) {
          final file = File(p.join(directory.path, '$id.$extension'));
          if (file.existsSync()) return file.path;
        }
        return null;
      },
    );
  }

  @override
  Future<void> delete(String id) async {
    return FileException.guard(
      'Could not delete cached artwork for $id.',
      () async {
        final directory = await _cacheDirectory();
        for (final extension in _knownExtensions) {
          final file = File(p.join(directory.path, '$id.$extension'));
          if (file.existsSync()) await file.delete();
        }
      },
    );
  }

  @override
  Future<void> clear() async {
    return FileException.guard('Could not clear the artwork cache.', () async {
      final directory = await _cacheDirectory();
      if (directory.existsSync()) await directory.delete(recursive: true);
    });
  }

  Future<Directory> _cacheDirectory() async {
    final root = await _root();
    final directory = Directory(p.join(root.path, 'artwork_cache'));
    if (!directory.existsSync()) await directory.create(recursive: true);
    return directory;
  }
}
