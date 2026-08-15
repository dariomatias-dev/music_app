import 'dart:async';

import 'package:music_app/src/features/search/domain/repositories/search_history_repository.dart';

/// In-memory [SearchHistoryRepository] for tests.
class FakeSearchHistoryRepository implements SearchHistoryRepository {
  FakeSearchHistoryRepository([List<String> terms = const []])
    : _terms = List.of(terms);

  final List<String> _terms;
  final _controller = StreamController<List<String>>.broadcast();

  void _emit() => _controller.add(List.of(_terms));

  @override
  Stream<List<String>> watchRecentTerms({int limit = 20}) async* {
    yield _terms.take(limit).toList();
    yield* _controller.stream.map((terms) => terms.take(limit).toList());
  }

  @override
  Future<void> record(String term) async {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return;
    _terms
      ..remove(trimmed)
      ..insert(0, trimmed);
    _emit();
  }

  @override
  Future<void> remove(String term) async {
    _terms.remove(term);
    _emit();
  }

  @override
  Future<void> clear() async {
    _terms.clear();
    _emit();
  }
}
