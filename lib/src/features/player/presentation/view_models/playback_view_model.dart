import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playback_view_model.g.dart';

/// The single source of truth for playback state across the app.
///
/// Consumers should watch narrow slices with `.select` (e.g. only
/// [PlaybackState.playing]) rather than the whole state, since the
/// playback position updates frequently during playback.
@riverpod
class PlaybackViewModel extends _$PlaybackViewModel {
  @override
  Stream<PlaybackState> build() async* {
    final service = ref.watch(audioPlayerServiceProvider);
    yield PlaybackState.fromSnapshot(service.snapshot);
    yield* service.snapshotStream.map(PlaybackState.fromSnapshot);
  }
}
