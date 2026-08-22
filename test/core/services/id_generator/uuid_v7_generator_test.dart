import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/services/id_generator/uuid_v7_generator.dart';

void main() {
  const generator = UuidV7Generator();

  test('produces a canonical uuid string', () {
    expect(
      generator.generate(),
      matches(
        RegExp(r'^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$'),
      ),
    );
  });

  test('stamps it as version 7', () {
    expect(generator.generate().split('-')[2][0], '7');
  });

  test('never repeats an id', () {
    final ids = {for (var i = 0; i < 500; i++) generator.generate()};

    expect(ids, hasLength(500));
  });

  test(
    'sorts a later id after an earlier one, since v7 is time-ordered',
    () async {
      final first = generator.generate();
      await Future<void>.delayed(const Duration(milliseconds: 2));
      final second = generator.generate();

      expect(second.compareTo(first), greaterThan(0));
    },
  );
}
