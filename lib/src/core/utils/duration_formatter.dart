/// Formats [duration] as `m:ss` (e.g. `3:05`).
String formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

/// Formats [duration] coarsely, in hours and minutes (e.g. `4h 12m`, or
/// just `12m` under an hour). Meant for long totals, where `m:ss` would be
/// unreadable.
String formatLongDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
}
