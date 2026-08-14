import 'dart:async';

import 'package:music_app/src/features/library/domain/repositories/favorite_repository.dart';

/// In-memory [FavoriteRepository] for tests.
class FakeFavoriteRepository implements FavoriteRepository {
  final Map<String, StreamController<bool>> _controllers = {};
  final Set<String> _favorited = {};

  StreamController<bool> _controllerFor(String trackId) =>
      _controllers.putIfAbsent(trackId, StreamController<bool>.broadcast);

  @override
  Stream<bool> watchIsFavorite(String trackId) async* {
    yield _favorited.contains(trackId);
    yield* _controllerFor(trackId).stream;
  }

  @override
  Future<void> setFavorite(String trackId, {required bool isFavorite}) async {
    if (isFavorite) {
      _favorited.add(trackId);
    } else {
      _favorited.remove(trackId);
    }
    _controllerFor(trackId).add(isFavorite);
  }
}
