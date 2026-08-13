import 'dart:convert';

import 'package:music_app/src/core/constants/preference_keys.dart';
import 'package:music_app/src/core/storage/key_value_storage.dart';
import 'package:music_app/src/features/queue/domain/playback_session.dart';

/// Persists and restores the last [PlaybackSession].
class PlaybackSessionStorage {
  /// Creates a [PlaybackSessionStorage] backed by [_storage].
  const PlaybackSessionStorage(this._storage);

  final KeyValueStorage _storage;

  /// Persists [session], replacing any previously saved session.
  Future<void> save(PlaybackSession session) {
    final json = jsonEncode({
      'trackIds': session.trackIds,
      'currentIndex': session.currentIndex,
      'positionMs': session.position.inMilliseconds,
    });
    return _storage.setString(PreferenceKeys.playbackSession, json);
  }

  /// Reads the last saved session, or `null` when none exists.
  Future<PlaybackSession?> load() async {
    final raw = await _storage.getString(PreferenceKeys.playbackSession);
    if (raw == null) return null;

    final map = jsonDecode(raw) as Map<String, dynamic>;
    return PlaybackSession(
      trackIds: (map['trackIds'] as List<dynamic>).cast<String>(),
      currentIndex: map['currentIndex'] as int,
      position: Duration(milliseconds: map['positionMs'] as int),
    );
  }

  /// Removes the saved session.
  Future<void> clear() => _storage.remove(PreferenceKeys.playbackSession);
}
