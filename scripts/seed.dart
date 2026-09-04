/// Fills a database file with the development library, with no device, no
/// emulator and no build.
///
/// ```sh
/// dart run scripts/seed.dart [path/to/music_app.sqlite]
/// ```
///
/// Defaults to `build/seed/music_app.sqlite`. Push the result over the
/// app's own database to open a populated app:
///
/// ```sh
/// dart run scripts/seed.dart
/// adb push build/seed/music_app.sqlite \
///   /data/data/br.com.dariomatias.music_app/app_flutter/music_app.sqlite
/// ```
///
/// Running the app itself with `--dart-define=SEED_ENABLED=true` seeds in
/// place instead, and is the shorter path when a device is attached.
library;

import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/seeds/dev_seeds.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/open.dart';

/// Where the seeded database lands when no path is given.
const _defaultPath = 'build/seed/music_app.sqlite';

/// Names a Linux distribution may install SQLite under.
///
/// The app gets its copy from `sqlite3_flutter_libs`, which is a Flutter
/// plugin and so absent here; a plain Dart process has to find the system
/// one, and only some distributions ship the unversioned symlink the
/// `sqlite3` package looks for by default.
const _linuxLibraryNames = ['libsqlite3.so', 'libsqlite3.so.0'];

Future<void> main(List<String> arguments) async {
  if (Platform.isLinux) _useSystemSqlite();

  final path = arguments.isEmpty ? _defaultPath : arguments.first;
  final file = File(path);
  await file.parent.create(recursive: true);

  final database = AppDatabase(NativeDatabase(file));
  try {
    await runDevSeeds(database);
  } finally {
    await database.close();
  }

  stdout.writeln('Seeded ${p.absolute(path)}');
}

void _useSystemSqlite() {
  open.overrideFor(OperatingSystem.linux, () {
    for (final name in _linuxLibraryNames) {
      try {
        return DynamicLibrary.open(name);
      } on Object {
        continue;
      }
    }
    throw StateError(
      'SQLite was not found. Install it (libsqlite3-0 on Debian and '
      'Ubuntu, sqlite-libs on Fedora) and run this again.',
    );
  });
}
