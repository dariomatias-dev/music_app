import 'dart:async';

import 'package:music_app/src/features/storage/domain/repositories/excluded_folder_repository.dart';

/// In-memory [ExcludedFolderRepository] for tests.
class FakeExcludedFolderRepository implements ExcludedFolderRepository {
  FakeExcludedFolderRepository([List<String> excludedFolders = const []])
    : _excludedFolders = List.of(excludedFolders);

  final List<String> _excludedFolders;
  final _controller = StreamController<List<String>>.broadcast();

  void _emit() => _controller.add(List.of(_excludedFolders));

  @override
  Stream<List<String>> watchExcludedFolders() async* {
    yield List.of(_excludedFolders);
    yield* _controller.stream;
  }

  @override
  Future<void> exclude(String path) async {
    if (_excludedFolders.contains(path)) return;
    _excludedFolders.add(path);
    _emit();
  }

  @override
  Future<void> include(String path) async {
    _excludedFolders.remove(path);
    _emit();
  }
}
