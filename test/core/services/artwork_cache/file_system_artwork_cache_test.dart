import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/errors/app_exception.dart';
import 'package:music_app/src/core/services/artwork_cache/file_system_artwork_cache.dart';

void main() {
  late Directory tempDirectory;
  late FileSystemArtworkCache cache;

  setUp(() {
    tempDirectory = Directory.systemTemp.createTempSync('artwork_cache_test');
    cache = FileSystemArtworkCache(root: () async => tempDirectory);
  });

  tearDown(() => tempDirectory.deleteSync(recursive: true));

  test('saves data and reports its path back', () async {
    final data = Uint8List.fromList([1, 2, 3]);

    final savedPath = await cache.save(
      id: 'track-1',
      data: data,
      mimeType: 'image/jpeg',
    );

    expect(savedPath, endsWith('track-1.jpg'));
    expect(await File(savedPath).readAsBytes(), data);
    expect(await cache.pathFor('track-1'), savedPath);
  });

  test('picks the extension matching the mime type', () async {
    final savedPath = await cache.save(
      id: 'track-2',
      data: Uint8List.fromList([1]),
      mimeType: 'image/png',
    );

    expect(savedPath, endsWith('track-2.png'));
  });

  test('pathFor returns null when nothing is cached', () async {
    expect(await cache.pathFor('missing'), isNull);
  });

  test('delete removes the cached file', () async {
    final savedPath = await cache.save(
      id: 'track-3',
      data: Uint8List.fromList([1]),
      mimeType: 'image/jpeg',
    );

    await cache.delete('track-3');

    expect(await cache.pathFor('track-3'), isNull);
    expect(File(savedPath).existsSync(), isFalse);
  });

  test('clear removes every cached file', () async {
    await cache.save(
      id: 'track-4',
      data: Uint8List.fromList([1]),
      mimeType: 'image/jpeg',
    );
    await cache.save(
      id: 'track-5',
      data: Uint8List.fromList([1]),
      mimeType: 'image/png',
    );

    await cache.clear();

    expect(await cache.pathFor('track-4'), isNull);
    expect(await cache.pathFor('track-5'), isNull);
  });

  group('failures', () {
    late FileSystemArtworkCache failing;

    setUp(() {
      failing = FileSystemArtworkCache(
        root: () async => throw const FileSystemException('no cache dir'),
      );
    });

    test('save reports a FileException', () async {
      await expectLater(
        () => failing.save(
          id: 'track-1',
          data: Uint8List.fromList([1]),
          mimeType: 'image/jpeg',
        ),
        throwsA(isA<FileException>()),
      );
    });

    test('pathFor reports a FileException', () async {
      await expectLater(
        () => failing.pathFor('track-1'),
        throwsA(isA<FileException>()),
      );
    });

    test('delete reports a FileException', () async {
      await expectLater(
        () => failing.delete('track-1'),
        throwsA(isA<FileException>()),
      );
    });

    test('clear reports a FileException', () async {
      await expectLater(failing.clear, throwsA(isA<FileException>()));
    });
  });
}
