import 'package:flutter/foundation.dart';
import 'package:music_app/src/core/constants/audio_constants.dart';
import 'package:music_app/src/core/constants/supported_formats.dart';
import 'package:music_app/src/core/errors/app_exception.dart';
import 'package:music_app/src/core/permissions/media_permission_service.dart';
import 'package:music_app/src/core/services/media_scanner/media_scanner.dart';
import 'package:on_audio_query/on_audio_query.dart';

/// [MediaScanner] implementation backed by `on_audio_query`.
class OnAudioQueryMediaScanner implements MediaScanner {
  /// Creates an [OnAudioQueryMediaScanner].
  const OnAudioQueryMediaScanner(this._query, this._permissionService);

  final OnAudioQuery _query;
  final MediaPermissionService _permissionService;

  @override
  Future<List<ScannedAudioFile>> scan({
    List<String> includedFolders = const [],
    List<String> excludedFolders = const [],
    Duration minimumDuration = AudioConstants.minimumTrackDuration,
  }) async {
    final status = await _permissionService.request();
    if (status != MediaPermissionStatus.granted) {
      throw const PermissionException(
        'Media access permission was not granted.',
      );
    }

    final songs = await _query.querySongs();

    return filterAndMapSongs(
      songs,
      includedFolders: includedFolders,
      excludedFolders: excludedFolders,
      minimumDuration: minimumDuration,
    );
  }
}

/// Filters [songs] by supported format, minimum duration and folder
/// membership, then maps them to [ScannedAudioFile].
///
/// Exposed for testing, since [SongModel] can be built directly from a map
/// without a platform channel.
@visibleForTesting
List<ScannedAudioFile> filterAndMapSongs(
  List<SongModel> songs, {
  required List<String> includedFolders,
  required List<String> excludedFolders,
  required Duration minimumDuration,
}) {
  return songs
      .where(_hasSupportedFormat)
      .where((song) => _isLongEnough(song, minimumDuration))
      .where((song) => _isIncluded(song, includedFolders))
      .where((song) => !_isExcluded(song, excludedFolders))
      .map(_toScannedAudioFile)
      .toList();
}

bool _hasSupportedFormat(SongModel song) {
  return SupportedFormats.extensions.contains(
    song.fileExtension.toLowerCase(),
  );
}

bool _isLongEnough(SongModel song, Duration minimumDuration) {
  return Duration(milliseconds: song.duration ?? 0) >= minimumDuration;
}

bool _isIncluded(SongModel song, List<String> includedFolders) {
  if (includedFolders.isEmpty) return true;
  return includedFolders.any((folder) => song.data.startsWith(folder));
}

bool _isExcluded(SongModel song, List<String> excludedFolders) {
  return excludedFolders.any((folder) => song.data.startsWith(folder));
}

ScannedAudioFile _toScannedAudioFile(SongModel song) {
  return ScannedAudioFile(
    mediaStoreId: song.id,
    filePath: song.data,
    title: song.title,
    duration: Duration(milliseconds: song.duration ?? 0),
    fileExtension: song.fileExtension.toLowerCase(),
    fileSize: song.size,
    // The media store reports date_added/date_modified in Unix seconds.
    dateAdded: _fromEpochSeconds(song.dateAdded),
    dateModified: _fromEpochSeconds(song.dateModified),
    artist: song.artist,
    album: song.album,
  );
}

DateTime _fromEpochSeconds(int? epochSeconds) {
  if (epochSeconds == null) return DateTime.now();
  return DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000);
}
