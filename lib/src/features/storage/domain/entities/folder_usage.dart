import 'package:freezed_annotation/freezed_annotation.dart';

part 'folder_usage.freezed.dart';

/// How much on-disk space a folder's indexed tracks take up.
@freezed
abstract class FolderUsage with _$FolderUsage {
  /// Creates a [FolderUsage].
  const factory FolderUsage({
    required String path,
    required int sizeBytes,
    required int trackCount,
  }) = _FolderUsage;
}
