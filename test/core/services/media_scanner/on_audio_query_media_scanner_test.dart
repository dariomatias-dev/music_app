import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_app/src/core/errors/app_exception.dart';
import 'package:music_app/src/core/permissions/media_permission_service.dart';
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

class _MockOnAudioQuery extends Mock implements OnAudioQuery {}

class _FakeMediaPermissionService implements MediaPermissionService {
  _FakeMediaPermissionService(this.status);

  final MediaPermissionStatus status;
  int requestCount = 0;

  @override
  Future<MediaPermissionStatus> check() async => status;

  @override
  Future<MediaPermissionStatus> request() async {
    requestCount++;
    return status;
  }

  @override
  Future<void> openSystemSettings() async {}
}

void main() {
  group('scan', () {
    late _MockOnAudioQuery query;

    setUp(() {
      query = _MockOnAudioQuery();
      when(
        () => query.querySongs(
          sortType: any(named: 'sortType'),
          orderType: any(named: 'orderType'),
          uriType: any(named: 'uriType'),
          ignoreCase: any(named: 'ignoreCase'),
          path: any(named: 'path'),
        ),
      ).thenAnswer((_) async => [_song(title: 'Night Drive')]);
    });

    test('requests the media permission before querying', () async {
      final permissions = _FakeMediaPermissionService(
        MediaPermissionStatus.granted,
      );
      final scanner = OnAudioQueryMediaScanner(query, permissions);

      await scanner.scan();

      expect(permissions.requestCount, 1);
    });

    test('returns the mapped songs once permission is granted', () async {
      final scanner = OnAudioQueryMediaScanner(
        query,
        _FakeMediaPermissionService(MediaPermissionStatus.granted),
      );

      final files = await scanner.scan();

      expect(files.single.title, 'Night Drive');
    });

    test('refuses to query when permission is denied', () async {
      final scanner = OnAudioQueryMediaScanner(
        query,
        _FakeMediaPermissionService(MediaPermissionStatus.denied),
      );

      await expectLater(
        scanner.scan,
        throwsA(isA<PermissionException>()),
      );
      verifyNever(
        () => query.querySongs(
          sortType: any(named: 'sortType'),
          orderType: any(named: 'orderType'),
          uriType: any(named: 'uriType'),
          ignoreCase: any(named: 'ignoreCase'),
          path: any(named: 'path'),
        ),
      );
    });

    test('refuses to query when permission is permanently denied', () async {
      final scanner = OnAudioQueryMediaScanner(
        query,
        _FakeMediaPermissionService(MediaPermissionStatus.permanentlyDenied),
      );

      await expectLater(scanner.scan, throwsA(isA<PermissionException>()));
    });

    test('passes the folder filters through to the mapping', () async {
      final scanner = OnAudioQueryMediaScanner(
        query,
        _FakeMediaPermissionService(MediaPermissionStatus.granted),
      );

      final files = await scanner.scan(
        excludedFolders: const ['/storage/emulated/0/Music'],
      );

      expect(files, isEmpty);
    });
  });

  test('notifyFileRemoved asks the platform to rescan the path', () async {
    final query = _MockOnAudioQuery();
    when(() => query.scanMedia(any())).thenAnswer((_) async => true);
    final scanner = OnAudioQueryMediaScanner(
      query,
      _FakeMediaPermissionService(MediaPermissionStatus.granted),
    );

    await scanner.notifyFileRemoved('/music/gone.mp3');

    verify(() => query.scanMedia('/music/gone.mp3')).called(1);
  });

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
