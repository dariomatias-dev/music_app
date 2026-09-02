import 'dart:io';

import 'package:music_app/src/core/errors/app_exception.dart';
import 'package:music_app/src/core/services/media_scanner/media_scanner.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';

/// Permanently deletes a track's file from the device and every trace of
/// it from the app: the library index, its playlists and favorites.
///
/// Does not touch the live playback queue, since that's session state
/// rather than persisted data; callers own removing it from there.
class DeleteTrackFile {
  /// Creates a [DeleteTrackFile].
  const DeleteTrackFile({
    required LibraryLocalDataSource dataSource,
    required MediaScanner mediaScanner,
  }) : _dataSource = dataSource,
       _mediaScanner = mediaScanner;

  final LibraryLocalDataSource _dataSource;
  final MediaScanner _mediaScanner;

  /// Deletes [track]'s file and every reference to it.
  ///
  /// The file is deleted first; if that fails (e.g. the platform denies
  /// the delete under scoped storage) this throws a [FileException],
  /// nothing else is touched, and the track stays intact.
  ///
  /// Playlist entries, favorites, cached lyrics and play events go with
  /// the row: the schema cascades them, so this does not clear them one
  /// by one. Doing that here would only cover this path, and leave the
  /// two definitions of what belongs to a track free to drift apart.
  Future<void> call(Track track) async {
    await FileException.guard('Could not delete ${track.filePath}.', () async {
      final file = File(track.filePath);
      if (file.existsSync()) await file.delete();
    });
    await _mediaScanner.notifyFileRemoved(track.filePath);
    await _dataSource.deleteTrack(track.id);
  }
}
