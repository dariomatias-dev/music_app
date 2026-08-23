import 'dart:async';

import 'package:music_app/src/features/player/domain/entities/lyrics.dart';
import 'package:music_app/src/features/player/domain/repositories/lyrics_repository.dart';

/// In-memory [LyricsRepository] for tests.
class FakeLyricsRepository implements LyricsRepository {
  FakeLyricsRepository({String? content})
    : _content = content,
      _source = content == null ? LyricsSource.none : LyricsSource.file,
      _throws = false;

  /// A [FakeLyricsRepository] whose [resolve] always fails, for testing the
  /// error path.
  FakeLyricsRepository.throwing()
    : _content = null,
      _source = LyricsSource.none,
      _throws = true;

  final String? _content;
  final LyricsSource _source;
  final bool _throws;
  final _controllers = <String, StreamController<Lyrics?>>{};

  StreamController<Lyrics?> _controllerFor(String trackId) =>
      _controllers.putIfAbsent(trackId, StreamController<Lyrics?>.broadcast);

  @override
  Stream<Lyrics?> watchLyrics(String trackId) async* {
    yield null;
    yield* _controllerFor(trackId).stream;
  }

  @override
  Future<Lyrics> resolve(String trackId, String filePath) async {
    if (_throws) throw Exception('could not read lyrics');
    final lyrics = Lyrics(trackId: trackId, content: _content, source: _source);
    _controllerFor(trackId).add(lyrics);
    return lyrics;
  }
}
