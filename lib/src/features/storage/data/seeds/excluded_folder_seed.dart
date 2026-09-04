import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/seeds/seed.dart';

/// Excludes one folder from the library scan, so the storage screen shows
/// both states side by side instead of a list where every row is included.
///
/// The path is one the library seed does not write tracks into: excluding a
/// seeded folder would contradict the library sitting next to it, where
/// those tracks are indexed and playing.
class ExcludedFolderSeed implements Seed {
  /// Creates an [ExcludedFolderSeed] writing into the given database.
  const ExcludedFolderSeed(this._database);

  final AppDatabase _database;

  /// Folders that start out excluded.
  static const _paths = [
    '/storage/emulated/0/Podcasts',
    '/storage/emulated/0/Recordings',
  ];

  @override
  Future<void> run() async {
    for (final path in _paths) {
      await _database.excludedFolderDao.exclude(path);
    }
  }
}
