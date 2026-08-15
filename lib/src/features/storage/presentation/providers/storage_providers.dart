import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/storage/data/providers/storage_data_providers.dart';
import 'package:music_app/src/features/storage/domain/entities/folder_usage.dart';
import 'package:path/path.dart' as p;

/// Total on-disk space used by every indexed, non-missing track.
final totalStorageUsageProvider = Provider<int>((ref) {
  final tracks = ref.watch(tracksStreamProvider).value ?? const [];
  var total = 0;
  for (final track in tracks) {
    if (!track.isMissing) total += track.fileSize;
  }
  return total;
});

/// Paths of every folder the user has excluded from the library scan.
final excludedFoldersProvider = StreamProvider<List<String>>(
  (ref) => ref.watch(excludedFolderRepositoryProvider).watchExcludedFolders(),
);

/// Every indexed, non-missing track, grouped by its containing directory.
final folderTracksProvider = Provider<Map<String, List<Track>>>((ref) {
  final tracks = ref.watch(tracksStreamProvider).value ?? const [];

  final byFolder = <String, List<Track>>{};
  for (final track in tracks) {
    if (track.isMissing) continue;
    byFolder.putIfAbsent(p.dirname(track.filePath), () => []).add(track);
  }
  return byFolder;
});

/// Space used per folder, grouping every indexed, non-missing track by its
/// containing directory, largest folder first.
final folderUsageProvider = Provider<List<FolderUsage>>((ref) {
  final folderTracks = ref.watch(folderTracksProvider);
  final excludedFolders = ref.watch(excludedFoldersProvider).value ?? const [];

  final result = [
    for (final entry in folderTracks.entries)
      FolderUsage(
        path: entry.key,
        sizeBytes: entry.value.fold(0, (sum, track) => sum + track.fileSize),
        trackCount: entry.value.length,
        isIncluded: !excludedFolders.contains(entry.key),
      ),
  ]..sort((a, b) => b.sizeBytes.compareTo(a.sizeBytes));
  return result;
});
