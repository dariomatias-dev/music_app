import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/features/history/data/providers/history_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';

/// Ids of up to 20 recently played tracks, most recent first.
final recentTrackIdsProvider = StreamProvider<List<String>>(
  (ref) => ref.watch(playHistoryRepositoryProvider).watchRecentTrackIds(),
);

/// The recently played, non-missing tracks, resolved and in order.
final recentTracksProvider = Provider<List<Track>>((ref) {
  final ids = ref.watch(recentTrackIdsProvider).value ?? const [];
  final tracks = ref.watch(tracksStreamProvider).value ?? const [];
  final tracksById = {for (final track in tracks) track.id: track};

  final result = <Track>[];
  for (final id in ids) {
    final track = tracksById[id];
    if (track != null && !track.isMissing) result.add(track);
  }
  return result;
});
