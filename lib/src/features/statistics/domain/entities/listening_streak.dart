import 'package:freezed_annotation/freezed_annotation.dart';

part 'listening_streak.freezed.dart';

/// The user's streaks of consecutive days with at least one play.
@freezed
abstract class ListeningStreak with _$ListeningStreak {
  /// Creates a [ListeningStreak].
  const factory ListeningStreak({
    /// Consecutive days up to and including today (or yesterday, if today
    /// hasn't had a play yet but the streak isn't broken).
    required int currentDays,

    /// The longest streak ever recorded.
    required int longestDays,
  }) = _ListeningStreak;
}
