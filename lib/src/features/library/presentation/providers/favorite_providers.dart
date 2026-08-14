import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_providers.g.dart';

/// Watches whether the track with [trackId] is favorited.
@riverpod
Stream<bool> isFavorite(Ref ref, String trackId) {
  return ref.watch(favoriteRepositoryProvider).watchIsFavorite(trackId);
}
