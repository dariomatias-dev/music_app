import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_play_count.freezed.dart';

/// How many times a track has been played.
@freezed
abstract class TrackPlayCount with _$TrackPlayCount {
  /// Creates a [TrackPlayCount].
  const factory TrackPlayCount({
    required String trackId,
    required int playCount,
  }) = _TrackPlayCount;
}
