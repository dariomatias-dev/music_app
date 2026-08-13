import 'dart:async';

import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playback_view_model.g.dart';

/// The single source of truth for playback state across the app.
///
/// Consumers should watch narrow slices with `.select` (e.g. only
/// [PlaybackState.playing]) rather than the whole state, since the
/// playback position updates frequently during playback.
@Riverpod(keepAlive: true)
class PlaybackViewModel extends _$PlaybackViewModel {
  @override
  Stream<PlaybackState> build() {
    final service = ref.watch(audioPlayerServiceProvider);

    // A plain `yield current; yield* service.snapshotStream;` generator
    // would only subscribe to the engine's stream once something starts
    // consuming this provider's stream (pull-based), which can happen
    // after the engine has already emitted further snapshots, losing
    // them. Subscribing eagerly here, into a controller that buffers
    // until listened to, avoids that gap.
    final controller = StreamController<PlaybackState>()
      ..add(PlaybackState.fromSnapshot(service.snapshot));
    final subscription = service.snapshotStream.listen(
      (snapshot) => controller.add(PlaybackState.fromSnapshot(snapshot)),
      onDone: controller.close,
    );
    ref.onDispose(() {
      unawaited(subscription.cancel());
      unawaited(controller.close());
    });

    return controller.stream;
  }
}
