import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/features/search/presentation/view_models/search_view_model.dart';

void main() {
  // Without an external listener, a bare ProviderContainer disposes an
  // autoDispose Notifier as soon as nothing is watching it, cancelling its
  // pending debounce Timer before it fires.
  ProviderContainer buildContainer() {
    return ProviderContainer()..listen(searchViewModelProvider, (_, _) {});
  }

  test('starts with an empty term', () {
    final container = buildContainer();
    addTearDown(container.dispose);

    expect(container.read(searchViewModelProvider), '');
  });

  test('updateTerm only applies after typing pauses', () async {
    final container = buildContainer();
    addTearDown(container.dispose);

    container.read(searchViewModelProvider.notifier).updateTerm('a');
    await Future<void>.delayed(const Duration(milliseconds: 100));
    container.read(searchViewModelProvider.notifier).updateTerm('al');
    await Future<void>.delayed(const Duration(milliseconds: 100));
    container.read(searchViewModelProvider.notifier).updateTerm('alb');

    // Still within the debounce window of the last keystroke.
    await Future<void>.delayed(const Duration(milliseconds: 200));
    expect(container.read(searchViewModelProvider), '');

    await Future<void>.delayed(const Duration(milliseconds: 200));
    expect(container.read(searchViewModelProvider), 'alb');
  });

  test('updateTerm trims the settled term', () async {
    final container = buildContainer();
    addTearDown(container.dispose);

    container.read(searchViewModelProvider.notifier).updateTerm('  Chill  ');
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(container.read(searchViewModelProvider), 'Chill');
  });

  test('clear resets immediately, without waiting on the debounce', () async {
    final container = buildContainer();
    addTearDown(container.dispose);

    container.read(searchViewModelProvider.notifier).updateTerm('Chill');
    await Future<void>.delayed(const Duration(milliseconds: 400));
    expect(container.read(searchViewModelProvider), 'Chill');

    container.read(searchViewModelProvider.notifier).clear();
    expect(container.read(searchViewModelProvider), '');

    // A pending debounce from before clear() must not overwrite it.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    expect(container.read(searchViewModelProvider), '');
  });
}
