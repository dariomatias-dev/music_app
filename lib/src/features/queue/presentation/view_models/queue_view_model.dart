import 'package:music_app/src/core/audio/audio_player_service.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'queue_view_model.g.dart';

/// The ordered list of tracks currently loaded into the playback queue.
///
/// Playback state itself (position, playing, current index, shuffle, loop
/// mode) lives in `PlaybackViewModel`; this only tracks which [Track]s are
/// in the queue, so the UI can show track details for the queue and for the
/// currently playing item.
@riverpod
class QueueViewModel extends _$QueueViewModel {
  @override
  List<Track> build() => const [];

  /// Replaces the queue with [tracks] (e.g. from an album, playlist or
  /// search result) and starts playing from [startIndex].
  Future<void> playFromSource(
    List<Track> tracks, {
    required int startIndex,
  }) async {
    final items = await _resolveQueueMediaItems(tracks);
    state = tracks;
    final handler = ref.read(audioHandlerProvider);
    await handler.setQueue(items, initialIndex: startIndex);
    await handler.play();
  }

  /// Appends [track] to the end of the queue.
  Future<void> addToEnd(Track track) async {
    final item = (await _resolveQueueMediaItems([track])).single;
    state = [...state, track];
    await ref.read(audioHandlerProvider).addToQueue(item);
  }

  /// Inserts [track] right after the currently playing item.
  Future<void> playNext(Track track) async {
    final item = (await _resolveQueueMediaItems([track])).single;
    final currentIndex = ref
        .read(audioPlayerServiceProvider)
        .snapshot
        .currentIndex;
    final insertAt = (currentIndex ?? -1) + 1;
    state = [...state]..insert(insertAt, track);
    await ref.read(audioHandlerProvider).insertNext(item);
  }

  /// Enables or disables shuffle order.
  Future<void> setShuffleModeEnabled({required bool enabled}) {
    return ref
        .read(audioPlayerServiceProvider)
        .setShuffleModeEnabled(enabled: enabled);
  }

  /// Sets the repeat behavior.
  Future<void> setLoopMode(AudioLoopMode mode) {
    return ref.read(audioPlayerServiceProvider).setLoopMode(mode);
  }

  Future<List<QueueMediaItem>> _resolveQueueMediaItems(
    List<Track> tracks,
  ) async {
    final repository = ref.read(libraryRepositoryProvider);
    final artists = <String, Artist>{
      for (final artist in await repository.watchArtists().first)
        artist.id: artist,
    };
    final albums = <String, Album>{
      for (final album in await repository.watchAlbums().first) album.id: album,
    };

    return tracks.map((track) {
      final artist = artists[track.artistId];
      final album = albums[track.albumId];
      return QueueMediaItem(
        id: track.id,
        filePath: track.filePath,
        title: track.title,
        artist: artist?.name,
        album: album?.title,
        duration: track.duration,
        artworkPath: album?.artworkPath,
      );
    }).toList();
  }
}
