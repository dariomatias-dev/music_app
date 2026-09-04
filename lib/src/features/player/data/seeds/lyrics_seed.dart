import 'package:drift/drift.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/seeds/seed.dart';
import 'package:music_app/src/features/library/data/seeds/library_seed.dart';
import 'package:music_app/src/features/player/domain/entities/lyrics.dart';

/// Caches lyrics for a few of the seeded tracks: one read from an embedded
/// tag, one from a sidecar file, and one resolved to nothing.
///
/// The third is the state the lyrics screen would otherwise only reach on a
/// device with a track that has no lyrics anywhere, and it renders
/// differently from a track whose lyrics were never looked up at all.
///
/// Runs after the library seed, whose tracks it points at.
class LyricsSeed implements Seed {
  /// Creates a [LyricsSeed] writing into the given database, dating the
  /// entries relative to [clock].
  LyricsSeed(this._database, {required DateTime Function() clock})
    : _clock = clock;

  final AppDatabase _database;
  final DateTime Function() _clock;

  /// Each entry as (position in the seeded tracks, source, content).
  static const _entries = <(int, LyricsSource, String?)>[
    (0, LyricsSource.embedded, _nightDrive),
    (9, LyricsSource.file, _mareCheia),
    (5, LyricsSource.none, null),
  ];

  static const _nightDrive = '''
Headlights on an empty road
Nothing on the radio
Keep the window open, let the summer through

The city fades behind us
The map has run out of names
There is nowhere left to be tonight''';

  static const _mareCheia = '''
[00:12.00] A maré cheia leva o que ficou
[00:21.50] Areia fina entre os dedos, devagar
[00:33.10] O vento sul aprendeu o meu nome
[00:45.00] E ninguém mais vem me chamar''';

  @override
  Future<void> run() async {
    final now = _clock();
    final trackIds = seedTrackIds;

    for (final (index, entry) in _entries.indexed) {
      final (position, source, content) = entry;
      if (position >= trackIds.length) continue;

      final trackId = trackIds[position];
      await (_database.delete(
        _database.lyricsTable,
      )..where((row) => row.trackId.equals(trackId))).go();
      await _database.lyricsDao.insertOne(
        LyricsTableCompanion.insert(
          id: 'seed-lyrics-$index',
          trackId: trackId,
          content: Value(content),
          source: source.name,
          fetchedAt: now.subtract(Duration(days: index + 1)),
        ),
      );
    }
  }
}
