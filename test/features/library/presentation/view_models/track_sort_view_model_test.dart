import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/features/library/presentation/view_models/track_sort_view_model.dart';

void main() {
  test('defaults to sorting by title', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(trackSortViewModelProvider), TrackSort.title);
  });

  test('order setter switches the current order', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(trackSortViewModelProvider.notifier).order =
        TrackSort.duration;

    expect(container.read(trackSortViewModelProvider), TrackSort.duration);
    expect(
      container.read(trackSortViewModelProvider.notifier).order,
      TrackSort.duration,
    );
  });
}
