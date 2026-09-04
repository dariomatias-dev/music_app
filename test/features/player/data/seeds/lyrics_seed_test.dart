import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/features/library/data/seeds/library_seed.dart';
import 'package:music_app/src/features/player/data/seeds/lyrics_seed.dart';
import 'package:music_app/src/features/player/domain/entities/lyrics.dart';

void main() {
  late AppDatabase database;

  DateTime clock() => DateTime(2026, 3, 15, 10, 30);

  Future<List<LyricsRow>> rows() => database.select(database.lyricsTable).get();

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await LibrarySeed(database, clock: clock).run();
    await LyricsSeed(database, clock: clock).run();
  });

  test('caches lyrics from every source the app resolves', () async {
    final sources = (await rows()).map((row) => row.source).toSet();

    expect(sources, {
      LyricsSource.embedded.name,
      LyricsSource.file.name,
      LyricsSource.none.name,
    });
  });

  test('leaves the content empty for a track with none', () async {
    final resolvedToNothing = (await rows()).firstWhere(
      (row) => row.source == LyricsSource.none.name,
    );

    expect(resolvedToNothing.content, isNull);
  });

  test('running twice keeps one entry per track', () async {
    await LyricsSeed(database, clock: clock).run();

    final entries = await rows();

    expect(
      entries.map((row) => row.trackId).toSet().length,
      entries.length,
    );
  });
}
