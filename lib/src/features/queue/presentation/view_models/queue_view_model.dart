import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/audio/audio_player_service.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/queue/data/providers/queue_data_providers.dart';
import 'package:music_app/src/features/queue/domain/playback_session.dart';
import 'package:music_app/src/features/settings/presentation/view_models/playback_preferences_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'queue_view_model.g.dart';

/// The ordered list of items currently loaded into the playback queue,
/// resolved with display metadata (title, artist, artwork).
///
/// Playback state itself (position, playing, current index, shuffle, loop
/// mode) lives in `PlaybackViewModel`; this only tracks what's in the
/// queue, so the UI can show track details for the mini player, the queue
/// screen and the currently playing item.
@Riverpod(keepAlive: true)
class QueueViewModel extends _$QueueViewModel {
  @override
  List<QueueMediaItem> build() {
    final isPlayingProvider = playbackViewModelProvider.select(
      (state) => state.value?.playing,
    );
    ref.listen(isPlayingProvider, (previous, current) {
      if (current == null) return;
      final wasPlaying = previous ?? false;
      if (wasPlaying && !current) unawaited(saveSession());
    });
    return const [];
  }

  /// Replaces the queue with [tracks] (e.g. from an album, playlist or
  /// search result) and starts playing from [startIndex].
  Future<void> playFromSource(
    List<Track> tracks, {
    required int startIndex,
  }) async {
    final items = await _resolveQueueMediaItems(tracks);
    state = items;
    final handler = ref.read(audioHandlerProvider);
    await handler.setQueue(items, initialIndex: startIndex);
    final defaultSpeed = ref
        .read(playbackPreferencesViewModelProvider)
        .value
        ?.defaultSpeed;
    if (defaultSpeed != null) {
      await ref.read(audioPlayerServiceProvider).setSpeed(defaultSpeed);
    }
    await handler.play();
  }

  /// Appends [track] to the end of the queue.
  Future<void> addToEnd(Track track) async {
    final item = (await _resolveQueueMediaItems([track])).single;
    state = [...state, item];
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
    state = [...state]..insert(insertAt, item);
    await ref.read(audioHandlerProvider).insertNext(item);
  }

  /// Moves the item at [oldIndex] to [newIndex] (already the final
  /// position, as reported by `ReorderableListView.onReorderItem`).
  Future<void> reorder(int oldIndex, int newIndex) async {
    final updated = [...state];
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    state = updated;
    await ref.read(audioHandlerProvider).moveInQueue(oldIndex, newIndex);
  }

  /// Removes the item at [index] from the queue.
  Future<void> removeAt(int index) async {
    state = [...state]..removeAt(index);
    await ref.read(audioHandlerProvider).removeFromQueue(index);
  }

  /// Removes every queue item for [trackId] (it may appear more than
  /// once, e.g. added both directly and via "play next").
  Future<void> removeTrackFromQueue(String trackId) async {
    final indices = [
      for (var i = 0; i < state.length; i++)
        if (state[i].id == trackId) i,
    ];
    for (final index in indices.reversed) {
      await removeAt(index);
    }
  }

  /// Removes every item from the queue and stops playback.
  Future<void> clear() async {
    state = const [];
    await ref.read(audioHandlerProvider).setQueue(const []);
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

  /// Persists the current queue, track and position, so it can be restored
  /// the next time the app starts.
  Future<void> saveSession() async {
    if (state.isEmpty) return;

    final snapshot = ref.read(audioPlayerServiceProvider).snapshot;
    await ref
        .read(playbackSessionStorageProvider)
        .save(
          PlaybackSession(
            trackIds: state.map((item) => item.id).toList(),
            currentIndex: snapshot.currentIndex ?? 0,
            position: snapshot.position,
          ),
        );
  }

  /// Restores the last saved session, if any, loading the queue without
  /// starting playback.
  ///
  /// Tracks that are missing or no longer indexed are dropped; if the
  /// track that was playing was dropped, restores at the beginning of the
  /// surviving queue instead of its saved position.
  Future<void> restoreSession() async {
    final session = await ref.read(playbackSessionStorageProvider).load();
    if (session == null) return;

    final tracksById = {
      for (final track
          in await ref.read(libraryRepositoryProvider).watchTracks().first)
        track.id: track,
    };

    final survivingIds = session.trackIds.where((id) {
      final track = tracksById[id];
      return track != null && !track.isMissing;
    }).toList();
    final restoredTracks = survivingIds.map((id) => tracksById[id]!).toList();
    if (restoredTracks.isEmpty) return;

    final originalCurrentId =
        session.currentIndex >= 0 &&
            session.currentIndex < session.trackIds.length
        ? session.trackIds[session.currentIndex]
        : null;
    final restoredIndex = originalCurrentId == null
        ? -1
        : survivingIds.indexOf(originalCurrentId);
    final startIndex = restoredIndex >= 0 ? restoredIndex : 0;

    final items = await _resolveQueueMediaItems(restoredTracks);
    state = items;
    await ref
        .read(audioHandlerProvider)
        .setQueue(
          items,
          initialIndex: startIndex,
          initialPosition: restoredIndex >= 0 ? session.position : null,
        );
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
        artistId: track.artistId,
        album: album?.title,
        albumId: track.albumId,
        duration: track.duration,
        artworkPath: album?.artworkPath,
      );
    }).toList();
  }
}
