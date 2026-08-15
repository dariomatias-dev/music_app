import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_play_count.freezed.dart';

/// How many plays were recorded on a single calendar day.
@freezed
abstract class DailyPlayCount with _$DailyPlayCount {
  /// Creates a [DailyPlayCount].
  const factory DailyPlayCount({
    required DateTime date,
    required int playCount,
  }) = _DailyPlayCount;
}
