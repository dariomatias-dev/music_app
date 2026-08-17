/// Formats [speed] as a playback speed label (e.g. `1x`, `1.5x`), dropping
/// the decimal point entirely for whole numbers instead of showing `1.0x`.
String formatPlaybackSpeed(double speed) {
  final formatted = speed % 1 == 0
      ? speed.toInt().toString()
      : speed.toString();
  return '${formatted}x';
}
