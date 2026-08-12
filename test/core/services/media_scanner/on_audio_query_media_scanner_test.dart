import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/services/media_scanner/media_scanner.dart';
import 'package:music_app/src/core/services/media_scanner/on_audio_query_media_scanner.dart';
import 'package:on_audio_query/on_audio_query.dart';

SongModel _song({
  int id = 1,
  String data = '/storage/emulated/0/Music/song.mp3',
  String title = 'Song',
  int duration = 60000,
  String fileExtension = 'mp3',
  int size = 1000000,
  int dateAdded = 1700000000,
  int dateModified = 1700000000,
  String? artist,
  String? album,
}) {
  return SongModel({
    '_id': id,
    '_data': data,
    'title': title,
    'duration': duration,
    'file_extension': fileExtension,
    '_size': size,
    'date_added': dateAdded,
    'date_modified': dateModified,
    'artist': artist,
    'album': album,
  });
}

void main() {
  group('filterAndMapSongs', () {
    test('ignores unsupported formats', () {
      final songs = [_song(fileExtension: 'wma')];

      final result = filterAndMapSongs(
        songs,
        includedFolders: const [],
        excludedFolders: const [],
        minimumDuration: const Duration(seconds: 30),
      );

      expect(result, isEmpty);
    });

    test('ignores files shorter than the minimum duration', () {
      final songs = [_song(duration: 10000)];

      final result = filterAndMapSongs(
        songs,
        includedFolders: const [],
        excludedFolders: const [],
        minimumDuration: const Duration(seconds: 30),
      );

      expect(result, isEmpty);
    });

    test('keeps only files inside an included folder', () {
      final songs = [
        _song(data: '/storage/emulated/0/Music/a.mp3'),
        _song(id: 2, data: '/storage/emulated/0/Podcasts/b.mp3'),
      ];

      final result = filterAndMapSongs(
        songs,
        includedFolders: const ['/storage/emulated/0/Music'],
        excludedFolders: const [],
        minimumDuration: const Duration(seconds: 30),
      );

      expect(result, hasLength(1));
      expect(result.single.mediaStoreId, 1);
    });

    test('drops files inside an excluded folder', () {
      final songs = [
        _song(data: '/storage/emulated/0/Music/a.mp3'),
        _song(id: 2, data: '/storage/emulated/0/Music/Ringtones/b.mp3'),
      ];

      final result = filterAndMapSongs(
        songs,
        includedFolders: const [],
        excludedFolders: const ['/storage/emulated/0/Music/Ringtones'],
        minimumDuration: const Duration(seconds: 30),
      );

      expect(result, hasLength(1));
      expect(result.single.mediaStoreId, 1);
    });

    test('maps a supported song to a ScannedAudioFile', () {
      final songs = [
        _song(
          id: 7,
          data: '/storage/emulated/0/Music/night-drive.mp3',
          title: 'Night Drive',
          duration: 210000,
          fileExtension: 'MP3',
          size: 5000000,
          dateModified: 1700003600,
          artist: 'Charcoal',
          album: 'Chill Vibes',
        ),
      ];

      final result = filterAndMapSongs(
        songs,
        includedFolders: const [],
        excludedFolders: const [],
        minimumDuration: const Duration(seconds: 30),
      );

      expect(result, hasLength(1));
      final file = result.single;
      expect(file, isA<ScannedAudioFile>());
      expect(file.mediaStoreId, 7);
      expect(file.filePath, '/storage/emulated/0/Music/night-drive.mp3');
      expect(file.title, 'Night Drive');
      expect(file.duration, const Duration(milliseconds: 210000));
      expect(file.fileExtension, 'mp3');
      expect(file.fileSize, 5000000);
      expect(
        file.dateAdded,
        DateTime.fromMillisecondsSinceEpoch(1700000000 * 1000),
      );
      expect(
        file.dateModified,
        DateTime.fromMillisecondsSinceEpoch(1700003600 * 1000),
      );
      expect(file.artist, 'Charcoal');
      expect(file.album, 'Chill Vibes');
    });
  });
}
