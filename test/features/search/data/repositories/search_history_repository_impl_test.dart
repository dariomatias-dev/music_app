import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:music_app/src/features/search/data/repositories/search_history_repository_impl.dart';

class _SequentialIdGenerator implements IdGenerator {
  int _next = 0;

  @override
  String generate() => 'id-${_next++}';
}

void main() {
  late AppDatabase database;
  late SearchHistoryRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = SearchHistoryRepositoryImpl(
      database,
      _SequentialIdGenerator(),
    );
  });

  tearDown(() => database.close());

  test('watchRecentTerms lists most recently searched first', () async {
    await repository.record('chill');
    await repository.record('night drive');

    expect(await repository.watchRecentTerms().first, [
      'night drive',
      'chill',
    ]);
  });

  test('record moves an existing term back to the front', () async {
    await repository.record('chill');
    await repository.record('night drive');
    await repository.record('chill');

    expect(await repository.watchRecentTerms().first, [
      'chill',
      'night drive',
    ]);
  });

  test('record does not duplicate an already-recorded term', () async {
    await repository.record('chill');
    await repository.record('chill');

    expect(await repository.watchRecentTerms().first, ['chill']);
  });

  test('record trims the term and ignores a blank one', () async {
    await repository.record('  chill  ');
    await repository.record('   ');

    expect(await repository.watchRecentTerms().first, ['chill']);
  });

  test('watchRecentTerms respects the limit', () async {
    await repository.record('a');
    await repository.record('b');
    await repository.record('c');

    expect(await repository.watchRecentTerms(limit: 2).first, ['c', 'b']);
  });

  test('remove deletes a single term', () async {
    await repository.record('chill');
    await repository.record('night drive');

    await repository.remove('chill');

    expect(await repository.watchRecentTerms().first, ['night drive']);
  });

  test('clear removes every term', () async {
    await repository.record('chill');
    await repository.record('night drive');

    await repository.clear();

    expect(await repository.watchRecentTerms().first, isEmpty);
  });
}
