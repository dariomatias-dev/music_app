import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('asserts when showBack is true but no back label is given', () {
    expect(() => AppTopBar(title: 'Queue'), throwsAssertionError);
  });

  test('allows showBack false without a back label', () {
    expect(
      () => const AppTopBar(showBack: false, title: 'Search'),
      returnsNormally,
    );
  });
}
