import 'package:freezed_annotation/freezed_annotation.dart';

part 'track.freezed.dart';

/// An indexed audio track.
@freezed
abstract class Track with _$Track {
  /// Creates a [Track].
  const factory Track({
    required String id,
    required String sourceId,
    required String filePath,
    required String title,
    required String artistId,
    required String albumId,
    required Duration duration,
    required String format,
    required int fileSize,
    required bool hasEmbeddedArtwork,
    required DateTime dateAdded,
    required DateTime dateModified,
    @Default(false) bool isMissing,
    int? trackNumber,
    int? discNumber,
    int? year,
    String? genre,
    int? bitrate,
    int? sampleRate,
  }) = _Track;
}
