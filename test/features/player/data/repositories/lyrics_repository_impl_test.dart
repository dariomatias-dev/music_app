import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:music_app/src/core/services/lyrics_reader/lyrics_reader.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source_impl.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/player/data/repositories/lyrics_repository_impl.dart';
import 'package:music_app/src/features/player/domain/entities/lyrics.dart';

class _SequentialIdGenerator implements IdGenerator {
  var _next = 0;

  @override
  String generate() => 'id-${_next++}';
}

class _FakeLyricsReader implements LyricsReader {
  _FakeLyricsReader({this.embedded, this.sidecar});

  final String? embedded;
  final String? sidecar;
  int embeddedReadCount = 0;

  @override
  Future<String?> readEmbedded(String filePath) async {
    embeddedReadCount++;
    return embedded;
  }

  @override
  Future<String?> readSidecar(String filePath) async => sidecar;
}

void main() {
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    final dataSource = LibraryLocalDataSourceImpl(database);
    await dataSource.upsertArtist(
      const Artist(
        id: 'artist-1',
        sourceId: 'artist-1',
        name: 'Charcoal',
        albumCount: 1,
        trackCount: 1,
      ),
    );
    await dataSource.upsertAlbum(
      const Album(
        id: 'album-1',
        sourceId: 'album-1',
        title: 'Chill Vibes',
        artistId: 'artist-1',
        trackCount: 1,
        totalDuration: Duration(minutes: 3),
      ),
    );
    await dataSource.upsertTrack(
      Track(
        id: 'track-1',
        sourceId: 'track-1',
        filePath: '/music/track-1.mp3',
        title: 'Night Drive',
        artistId: 'artist-1',
        albumId: 'album-1',
        duration: const Duration(minutes: 3),
        format: 'mp3',
        fileSize: 1000,
        hasEmbeddedArtwork: false,
        dateAdded: DateTime(2026),
        dateModified: DateTime(2026),
      ),
    );
  });

  tearDown(() => database.close());

  test('resolve prefers embedded lyrics over a sidecar file', () async {
    final repository = LyricsRepositoryImpl(
      database,
      _SequentialIdGenerator(),
      _FakeLyricsReader(embedded: 'Embedded lyrics', sidecar: 'File lyrics'),
    );

    final lyrics = await repository.resolve('track-1', '/music/track-1.mp3');

    expect(lyrics.source, LyricsSource.embedded);
    expect(lyrics.content, 'Embedded lyrics');
  });

  test('resolve falls back to a sidecar file', () async {
    final repository = LyricsRepositoryImpl(
      database,
      _SequentialIdGenerator(),
      _FakeLyricsReader(sidecar: 'File lyrics'),
    );

    final lyrics = await repository.resolve('track-1', '/music/track-1.mp3');

    expect(lyrics.source, LyricsSource.file);
    expect(lyrics.content, 'File lyrics');
  });

  test('resolve falls back to none when nothing is found', () async {
    final repository = LyricsRepositoryImpl(
      database,
      _SequentialIdGenerator(),
      _FakeLyricsReader(),
    );

    final lyrics = await repository.resolve('track-1', '/music/track-1.mp3');

    expect(lyrics.source, LyricsSource.none);
    expect(lyrics.content, isNull);
  });

  test('resolve caches the result and does not re-read the file', () async {
    final reader = _FakeLyricsReader(embedded: 'Embedded lyrics');
    final repository = LyricsRepositoryImpl(
      database,
      _SequentialIdGenerator(),
      reader,
    );

    await repository.resolve('track-1', '/music/track-1.mp3');
    final second = await repository.resolve(
      'track-1',
      '/music/track-1.mp3',
    );

    expect(second.content, 'Embedded lyrics');
    expect(reader.embeddedReadCount, 1);
  });

  test('watchLyrics reflects the cached entry once resolved', () async {
    final repository = LyricsRepositoryImpl(
      database,
      _SequentialIdGenerator(),
      _FakeLyricsReader(embedded: 'Embedded lyrics'),
    );

    expect(await repository.watchLyrics('track-1').first, isNull);

    await repository.resolve('track-1', '/music/track-1.mp3');

    expect(
      (await repository.watchLyrics('track-1').first)?.content,
      'Embedded lyrics',
    );
  });
}
