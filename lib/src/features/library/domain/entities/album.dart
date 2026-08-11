import 'package:freezed_annotation/freezed_annotation.dart';

part 'album.freezed.dart';

/// An indexed album.
@freezed
abstract class Album with _$Album {
  /// Creates an [Album].
  const factory Album({
    required String id,
    required String sourceId,
    required String title,
    required String artistId,
    required int trackCount,
    required Duration totalDuration,
    int? year,
    String? artworkPath,
  }) = _Album;
}
