import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist.freezed.dart';

/// A user-created playlist.
@freezed
abstract class Playlist with _$Playlist {
  /// Creates a [Playlist].
  const factory Playlist({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Playlist;
}
