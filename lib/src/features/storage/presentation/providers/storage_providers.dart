import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
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

/// Space used per folder, grouping every indexed, non-missing track by its
/// containing directory, largest folder first.
final folderUsageProvider = Provider<List<FolderUsage>>((ref) {
  final tracks = ref.watch(tracksStreamProvider).value ?? const [];

  final sizeByFolder = <String, int>{};
  final countByFolder = <String, int>{};
  for (final track in tracks) {
    if (track.isMissing) continue;
    final folder = p.dirname(track.filePath);
    sizeByFolder[folder] = (sizeByFolder[folder] ?? 0) + track.fileSize;
    countByFolder[folder] = (countByFolder[folder] ?? 0) + 1;
  }

  final result = [
    for (final folder in sizeByFolder.keys)
      FolderUsage(
        path: folder,
        sizeBytes: sizeByFolder[folder]!,
        trackCount: countByFolder[folder]!,
      ),
  ]..sort((a, b) => b.sizeBytes.compareTo(a.sizeBytes));
  return result;
});
