import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Opens the database file the app keeps in its documents directory.
///
/// Lazy: resolving the directory is a platform call, and the app builds its
/// provider graph before there is anything to query.
QueryExecutor openAppDatabaseConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = p.join(directory.path, appDatabaseFileName);
    return NativeDatabase.createInBackground(File(file));
  });
}
