import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/features/playlist/presentation/view_models/playlist_track_sort_view_model.dart';

void main() {
  test("defaults to the playlist's custom order", () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(playlistTrackSortViewModelProvider),
      PlaylistTrackSort.custom,
    );
  });

  test('order setter switches the current order', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(playlistTrackSortViewModelProvider.notifier).order =
        PlaylistTrackSort.duration;

    expect(
      container.read(playlistTrackSortViewModelProvider),
      PlaylistTrackSort.duration,
    );
    expect(
      container.read(playlistTrackSortViewModelProvider.notifier).order,
      PlaylistTrackSort.duration,
    );
  });
}
