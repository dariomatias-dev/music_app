import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist.freezed.dart';

/// An indexed artist.
@freezed
abstract class Artist with _$Artist {
  /// Creates an [Artist].
  const factory Artist({
    required String id,
    required String sourceId,
    required String name,
    required int albumCount,
    required int trackCount,
  }) = _Artist;
}
