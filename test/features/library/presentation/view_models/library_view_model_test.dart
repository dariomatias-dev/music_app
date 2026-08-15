import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/features/library/presentation/view_models/library_view_model.dart';

void main() {
  test('defaults to the tracks section', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(libraryViewModelProvider), LibrarySection.tracks);
  });

  test('section setter switches the current section', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(libraryViewModelProvider.notifier).section =
        LibrarySection.albums;

    expect(container.read(libraryViewModelProvider), LibrarySection.albums);
  });
}
