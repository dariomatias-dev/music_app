/// Technical constants related to audio scanning and playback.
abstract final class AudioConstants {
  /// Files shorter than this are ignored by the library scanner (e.g.
  /// notification sounds, ringtones).
  static const minimumTrackDuration = Duration(seconds: 30);
}
