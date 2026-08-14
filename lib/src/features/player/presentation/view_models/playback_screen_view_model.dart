import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/queue/presentation/view_models/queue_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playback_screen_view_model.g.dart';

/// The track currently loaded for the playback screen, or `null` when
/// nothing is playing.
@riverpod
class PlaybackScreenViewModel extends _$PlaybackScreenViewModel {
  @override
  QueueMediaItem? build() {
    final queue = ref.watch(queueViewModelProvider);
    final currentIndex = ref.watch(
      playbackViewModelProvider.select(
        (state) => state.value?.currentIndex,
      ),
    );
    if (currentIndex == null || currentIndex >= queue.length) return null;
    return queue[currentIndex];
  }
}
