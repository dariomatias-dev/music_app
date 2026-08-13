import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/queue/data/playback_session_storage.dart';

/// Provides the [PlaybackSessionStorage] used across the queue feature.
final playbackSessionStorageProvider = Provider<PlaybackSessionStorage>(
  (ref) => PlaybackSessionStorage(ref.watch(keyValueStorageProvider)),
);
