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

  /// Writes a database file carrying the v1 schema and the rows an existing
  /// install would already hold.
  ///
  /// Drift lays down every table first, then `playlist_table` is rolled back
  /// to its v1 shape, so the rest of the schema stays byte-for-byte real.
  Future<void> seedSchemaV1() async {
    final current = AppDatabase(NativeDatabase(File(databasePath)));
    await current.customSelect('SELECT 1').getSingle();
    await current.close();

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

  test('schemaVersion is 2, and a bump needs a migration and a test', () async {
    final database = await openDatabase();

    expect(database.schemaVersion, 2);
  });
}
