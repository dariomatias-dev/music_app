import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:music_app/src/core/services/lyrics_reader/lyrics_reader.dart';
import 'package:music_app/src/features/player/domain/entities/lyrics.dart';
import 'package:music_app/src/features/player/domain/repositories/lyrics_repository.dart';

/// [LyricsRepository] implementation backed by [AppDatabase] and a
/// [LyricsReader].
class LyricsRepositoryImpl implements LyricsRepository {
  /// Creates a [LyricsRepositoryImpl].
  const LyricsRepositoryImpl(this._database, this._idGenerator, this._reader);

  final AppDatabase _database;
  final IdGenerator _idGenerator;
  final LyricsReader _reader;

  @override
  Stream<Lyrics?> watchLyrics(String trackId) {
    return _database.lyricsDao
        .watchByTrackId(trackId)
        .map((row) => row == null ? null : _toEntity(row));
  }

  @override
  Future<Lyrics> resolve(String trackId, String filePath) async {
    final cached = await _database.lyricsDao.getByTrackId(trackId);
    if (cached != null) return _toEntity(cached);

    final embedded = await _reader.readEmbedded(filePath);
    if (embedded != null) {
      return _persist(trackId, embedded, LyricsSource.embedded);
    }

    final sidecar = await _reader.readSidecar(filePath);
    if (sidecar != null) {
      return _persist(trackId, sidecar, LyricsSource.file);
    }

    return _persist(trackId, null, LyricsSource.none);
  }

  Future<Lyrics> _persist(
    String trackId,
    String? content,
    LyricsSource source,
  ) async {
    await _database.lyricsDao.insertOne(
      LyricsTableCompanion.insert(
        id: _idGenerator.generate(),
        trackId: trackId,
        content: Value(content),
        source: source.name,
        fetchedAt: DateTime.now(),
      ),
    );
    return Lyrics(trackId: trackId, content: content, source: source);
  }

  Lyrics _toEntity(LyricsRow row) => Lyrics(
    trackId: row.trackId,
    content: row.content,
    source: LyricsSource.values.byName(row.source),
  );
}
