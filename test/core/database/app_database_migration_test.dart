import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

/// The `playlist_table` as it shipped in schema v1: no `description` and no
/// `is_favorite`. Everything else in v1 matches v2, so only this table is
/// rebuilt to reproduce an upgrading install.
const _playlistTableV1 =
    'CREATE TABLE "playlist_table" ('
    ' "id" TEXT NOT NULL, '
    '"name" TEXT NOT NULL, '
    '"is_favorites_playlist" INTEGER NOT NULL DEFAULT 0 '
    'CHECK ("is_favorites_playlist" IN (0, 1)), '
    '"created_at" INTEGER NOT NULL, '
    '"updated_at" INTEGER NOT NULL, '
    'PRIMARY KEY ("id"))';

/// The four tables that referenced a track or a playlist without a cascade,
/// as they shipped through schema v3: identical to v4 but for the missing
/// `ON DELETE CASCADE`.
const _favoriteTableV3 =
    'CREATE TABLE "favorite_table" ("id" TEXT NOT NULL, '
    '"track_id" TEXT NOT NULL REFERENCES track_table (id), '
    '"created_at" INTEGER NOT NULL, PRIMARY KEY ("id"), '
    'UNIQUE ("track_id"))';

const _lyricsTableV3 =
    'CREATE TABLE "lyrics_table" ("id" TEXT NOT NULL, '
    '"track_id" TEXT NOT NULL REFERENCES track_table (id), '
    '"content" TEXT NULL, "source" TEXT NOT NULL, '
    '"fetched_at" INTEGER NOT NULL, PRIMARY KEY ("id"), '
    'UNIQUE ("track_id"))';

const _playEventTableV3 =
    'CREATE TABLE "play_event_table" ("id" TEXT NOT NULL, '
    '"track_id" TEXT NOT NULL REFERENCES track_table (id), '
    '"started_at" INTEGER NOT NULL, "played_duration" INTEGER NOT NULL, '
    '"completed" INTEGER NOT NULL CHECK ("completed" IN (0, 1)), '
    'PRIMARY KEY ("id"))';

const _playlistTrackTableV3 =
    'CREATE TABLE "playlist_track_table" '
    '("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
    '"playlist_id" TEXT NOT NULL REFERENCES playlist_table (id), '
    '"track_id" TEXT NOT NULL REFERENCES track_table (id), '
    '"position" INTEGER NOT NULL)';

const _tablesV3 = <String>[
  _favoriteTableV3,
  _lyricsTableV3,
  _playEventTableV3,
  _playlistTrackTableV3,
];

/// Seconds since epoch, the encoding drift uses for `DateTimeColumn`.
int _epochSeconds(DateTime value) =>
    value.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;

void main() {
  late Directory directory;
  late String databasePath;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('music_app_migration');
    databasePath = p.join(directory.path, 'music_app.sqlite');
  });

  tearDown(() => directory.delete(recursive: true));

  /// Removes every index drift created, leaving the file as an install
  /// predating schema v3, which is where the indexes were introduced.
  void dropIndexes() {
    final raw = sqlite3.open(databasePath);
    final indexes = raw
        .select("SELECT name FROM sqlite_master WHERE type = 'index'")
        .map((row) => row['name'] as String?)
        .whereType<String>()
        // Indexes SQLite creates for UNIQUE constraints cannot be dropped,
        // and are not the ones v3 adds.
        .where((name) => !name.startsWith('sqlite_autoindex'));
    for (final name in indexes) {
      raw.execute('DROP INDEX "$name"');
    }
    raw.dispose();
  }

  /// Writes a database file carrying the v1 schema and the rows an existing
  /// install would already hold.
  ///
  /// Drift lays down every table first, then `playlist_table` is rolled back
  /// to its v1 shape, so the rest of the schema stays byte-for-byte real.
  Future<void> seedSchemaV1() async {
    final current = AppDatabase(NativeDatabase(File(databasePath)));
    await current.customSelect('SELECT 1').getSingle();
    await current.close();

    dropIndexes();
    sqlite3.open(databasePath)
      ..execute('DROP TABLE playlist_table')
      ..execute(_playlistTableV1)
      ..execute(
        'INSERT INTO playlist_table '
        '(id, name, is_favorites_playlist, created_at, updated_at) '
        'VALUES (?, ?, ?, ?, ?)',
        [
          'playlist-1',
          'Road Trip',
          0,
          _epochSeconds(DateTime.utc(2024)),
          _epochSeconds(DateTime.utc(2024, 6)),
        ],
      )
      ..execute('PRAGMA user_version = 1')
      ..dispose();
  }

  /// Writes a database file carrying the v2 schema: identical to v3 except
  /// that none of the indexes v3 adds exist yet.
  Future<void> seedSchemaV2() async {
    final current = AppDatabase(NativeDatabase(File(databasePath)));
    await current.customSelect('SELECT 1').getSingle();
    await current.close();

    dropIndexes();
    sqlite3.open(databasePath)
      ..execute('PRAGMA user_version = 2')
      ..dispose();
  }

  /// The names of every index the database file at [databasePath] holds.
  Future<List<String>> indexNames(AppDatabase database) => database
      .customSelect("SELECT name FROM sqlite_master WHERE type = 'index'")
      .map((row) => row.read<String>('name'))
      .get();

  /// Opens the database at [databasePath], forcing the lazy connection open
  /// so the migration runs before the returned instance is used.
  Future<AppDatabase> openDatabase() async {
    final database = AppDatabase(NativeDatabase(File(databasePath)));
    addTearDown(database.close);
    await database.customSelect('SELECT 1').getSingle();
    return database;
  }

  test('a fresh install is created at the current schema version', () async {
    final database = await openDatabase();

    final version = await database
        .customSelect('PRAGMA user_version')
        .getSingle();

    expect(version.data['user_version'], database.schemaVersion);
  });

  test('a fresh install has every table the app queries', () async {
    final database = await openDatabase();

    final tables = await database
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
        .map((row) => row.read<String>('name'))
        .get();

    expect(
      tables,
      containsAll(database.allTables.map((table) => table.actualTableName)),
    );
  });

  group('upgrading from schema v1', () {
    test('moves the database to the current schema version', () async {
      await seedSchemaV1();

      final database = await openDatabase();
      final version = await database
          .customSelect('PRAGMA user_version')
          .getSingle();

      expect(version.data['user_version'], database.schemaVersion);
    });

    test('keeps playlists the user already created', () async {
      await seedSchemaV1();

      final database = await openDatabase();
      final playlists = await database.select(database.playlistTable).get();

      expect(playlists, hasLength(1));
      expect(playlists.single.id, 'playlist-1');
      expect(playlists.single.name, 'Road Trip');
      expect(playlists.single.createdAt, DateTime.utc(2024).toLocal());
      expect(playlists.single.updatedAt, DateTime.utc(2024, 6).toLocal());
    });

    test('backfills the columns v2 added', () async {
      await seedSchemaV1();

      final database = await openDatabase();
      final playlist = await database
          .select(database.playlistTable)
          .getSingle();

      expect(playlist.description, isNull);
      expect(playlist.isFavorite, isFalse);
      expect(playlist.isFavoritesPlaylist, isFalse);
    });

    test('accepts writes to the columns v2 added', () async {
      await seedSchemaV1();

      final database = await openDatabase();
      await (database.update(
        database.playlistTable,
      )..where((row) => row.id.equals('playlist-1'))).write(
        const PlaylistTableCompanion(
          description: Value('Songs for the drive'),
          isFavorite: Value(true),
        ),
      );

      final playlist = await database
          .select(database.playlistTable)
          .getSingle();

      expect(playlist.description, 'Songs for the drive');
      expect(playlist.isFavorite, isTrue);
    });

    test('is a no-op when the database is already current', () async {
      final database = await openDatabase();
      await database
          .into(database.playlistTable)
          .insert(
            PlaylistTableCompanion.insert(
              id: 'playlist-1',
              name: 'Road Trip',
              description: const Value('Songs for the drive'),
              createdAt: DateTime.utc(2024),
              updatedAt: DateTime.utc(2024),
            ),
          );
      await database.close();

      final reopened = await openDatabase();
      final playlist = await reopened
          .select(reopened.playlistTable)
          .getSingle();

      expect(playlist.description, 'Songs for the drive');
    });
  });

  group('upgrading from schema v2', () {
    test('moves the database to the current schema version', () async {
      await seedSchemaV2();

      final database = await openDatabase();
      final version = await database
          .customSelect('PRAGMA user_version')
          .getSingle();

      expect(version.data['user_version'], database.schemaVersion);
    });

    test('creates the indexes v3 added', () async {
      await seedSchemaV2();

      final database = await openDatabase();

      expect(
        await indexNames(database),
        containsAll(
          database.allSchemaEntities.whereType<Index>().map(
            (index) => index.entityName,
          ),
        ),
      );
    });

    test('keeps rows an existing install already holds', () async {
      await seedSchemaV2();

      final seeded = await openDatabase();
      await seeded
          .into(seeded.playlistTable)
          .insert(
            PlaylistTableCompanion.insert(
              id: 'playlist-1',
              name: 'Road Trip',
              createdAt: DateTime.utc(2024),
              updatedAt: DateTime.utc(2024),
            ),
          );

      final playlists = await seeded.select(seeded.playlistTable).get();

      expect(playlists.single.name, 'Road Trip');
    });
  });

  test('a fresh install has every index the app relies on', () async {
    final database = await openDatabase();

    expect(
      await indexNames(database),
      containsAll(
        database.allSchemaEntities.whereType<Index>().map(
          (index) => index.entityName,
        ),
      ),
    );
  });

  test('schemaVersion is 4, and a bump needs a migration and a test', () async {
    final database = await openDatabase();

    expect(database.schemaVersion, 4);
  });

  group('upgrading from schema v3', () {
    /// Writes a database file carrying the v3 schema, with the rows a real
    /// install would hold plus the orphans deletes left behind while no
    /// cascade was enforcing anything.
    Future<void> seedSchemaV3() async {
      final current = AppDatabase(NativeDatabase(File(databasePath)));
      await current.customSelect('SELECT 1').getSingle();
      await current.close();

      final raw = sqlite3.open(databasePath);
      for (final table in [
        'favorite_table',
        'lyrics_table',
        'play_event_table',
        'playlist_track_table',
      ]) {
        raw.execute('DROP TABLE "$table"');
      }
      _tablesV3.forEach(raw.execute);
      // The indexes v3 attached to the tables just recreated above.
      raw
        ..execute(
          'CREATE INDEX playlist_track_playlist ON playlist_track_table '
          '(playlist_id, position)',
        )
        ..execute(
          'CREATE INDEX playlist_track_track ON playlist_track_table '
          '(track_id)',
        )
        ..execute(
          'CREATE INDEX play_event_started_at ON play_event_table '
          '(started_at)',
        )
        ..execute(
          'INSERT INTO artist_table (id, source_id, name, album_count, '
          'track_count) VALUES (?, ?, ?, ?, ?)',
          ['artist-1', 'artist-1', 'Nina Simone', 1, 1],
        )
        ..execute(
          'INSERT INTO album_table (id, source_id, title, artist_id, '
          'track_count, total_duration) VALUES (?, ?, ?, ?, ?, ?)',
          ['album-1', 'album-1', 'Pastel Blues', 'artist-1', 1, 1000],
        )
        ..execute(
          'INSERT INTO track_table (id, source_id, file_path, title, '
          'artist_id, album_id, duration, format, file_size, '
          'has_embedded_artwork, date_added, date_modified) '
          'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            'track-1',
            'track-1',
            '/music/sinnerman.mp3',
            'Sinnerman',
            'artist-1',
            'album-1',
            1000,
            'mp3',
            2048,
            0,
            _epochSeconds(DateTime.utc(2024)),
            _epochSeconds(DateTime.utc(2024)),
          ],
        )
        ..execute(
          'INSERT INTO playlist_table (id, name, is_favorite, '
          'is_favorites_playlist, created_at, updated_at) '
          'VALUES (?, ?, ?, ?, ?, ?)',
          [
            'playlist-1',
            'Road Trip',
            0,
            0,
            _epochSeconds(DateTime.utc(2024)),
            _epochSeconds(DateTime.utc(2024)),
          ],
        );

      for (final trackId in ['track-1', 'ghost-track']) {
        raw
          ..execute(
            'INSERT INTO favorite_table (id, track_id, created_at) '
            'VALUES (?, ?, ?)',
            ['fav-$trackId', trackId, _epochSeconds(DateTime.utc(2024))],
          )
          ..execute(
            'INSERT INTO lyrics_table (id, track_id, content, source, '
            'fetched_at) VALUES (?, ?, ?, ?, ?)',
            [
              'lyr-$trackId',
              trackId,
              'oh sinnerman',
              'embedded',
              _epochSeconds(DateTime.utc(2024)),
            ],
          )
          ..execute(
            'INSERT INTO play_event_table (id, track_id, started_at, '
            'played_duration, completed) VALUES (?, ?, ?, ?, ?)',
            [
              'evt-$trackId',
              trackId,
              _epochSeconds(DateTime.utc(2024)),
              1000,
              1,
            ],
          )
          ..execute(
            'INSERT INTO playlist_track_table (playlist_id, track_id, '
            'position) VALUES (?, ?, ?)',
            ['playlist-1', trackId, 0],
          );
      }

      raw
        ..execute(
          'INSERT INTO playlist_track_table (playlist_id, track_id, position) '
          'VALUES (?, ?, ?)',
          ['ghost-playlist', 'track-1', 1],
        )
        ..execute('PRAGMA user_version = 3')
        ..dispose();
    }

    test('moves the database to the current schema version', () async {
      await seedSchemaV3();

      final database = await openDatabase();
      final version = await database
          .customSelect('PRAGMA user_version')
          .getSingle();

      expect(version.data['user_version'], database.schemaVersion);
    });

    test('keeps the rows that point at something that exists', () async {
      await seedSchemaV3();

      final database = await openDatabase();

      expect(
        (await database.select(database.favoriteTable).get()).single.trackId,
        'track-1',
      );
      expect(
        (await database.select(database.lyricsTable).get()).single.trackId,
        'track-1',
      );
      expect(
        (await database.select(database.playEventTable).get()).single.trackId,
        'track-1',
      );
      expect(
        (await database.select(database.playlistTrackTable).get())
            .single
            .playlistId,
        'playlist-1',
      );
    });

    test('enforces foreign keys once the upgrade is done', () async {
      await seedSchemaV3();

      final database = await openDatabase();
      final pragma = await database
          .customSelect('PRAGMA foreign_keys')
          .getSingle();

      expect(pragma.data['foreign_keys'], 1);
      await expectLater(
        database.customStatement(
          'INSERT INTO favorite_table (id, track_id, created_at) '
          "VALUES ('f2', 'ghost-track', 0)",
        ),
        throwsA(anything),
      );
    });

    test('cascades a deleted track to everything referencing it', () async {
      await seedSchemaV3();

      final database = await openDatabase();
      await database.trackDao.deleteById('track-1');

      expect(await database.select(database.favoriteTable).get(), isEmpty);
      expect(await database.select(database.lyricsTable).get(), isEmpty);
      expect(await database.select(database.playEventTable).get(), isEmpty);
      expect(
        await database.select(database.playlistTrackTable).get(),
        isEmpty,
      );
    });

    test('cascades a deleted playlist to its entries', () async {
      await seedSchemaV3();

      final database = await openDatabase();
      await database.playlistDao.deleteById('playlist-1');

      expect(
        await database.select(database.playlistTrackTable).get(),
        isEmpty,
      );
    });

    test('keeps the indexes the recreated tables carry', () async {
      await seedSchemaV3();

      final database = await openDatabase();

      expect(
        await indexNames(database),
        containsAll(
          database.allSchemaEntities.whereType<Index>().map(
            (index) => index.entityName,
          ),
        ),
      );
    });
  });
}
