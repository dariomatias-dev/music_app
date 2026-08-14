import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/services/lyrics_reader/file_lyrics_reader.dart';
import 'package:path/path.dart' as p;

List<int> _synchsafe(int value) {
  return [
    (value >> 21) & 0x7F,
    (value >> 14) & 0x7F,
    (value >> 7) & 0x7F,
    value & 0x7F,
  ];
}

List<int> _bigEndian(int value) {
  return [
    (value >> 24) & 0xFF,
    (value >> 16) & 0xFF,
    (value >> 8) & 0xFF,
    value & 0xFF,
  ];
}

Uint8List _mp3WithUslt(
  String lyrics, {
  int encoding = 3,
  bool synchsafeFrameSize = false,
  bool frameUnsynchronized = false,
}) {
  final textBytes = switch (encoding) {
    0 => latin1.encode(lyrics),
    3 => utf8.encode(lyrics),
    _ => throw UnsupportedError('Test helper only covers encodings 0 and 3'),
  };
  final frameContent = [encoding, ...utf8.encode('eng'), 0x00, ...textBytes];
  final frameSizeBytes = synchsafeFrameSize
      ? _synchsafe(frameContent.length)
      : _bigEndian(frameContent.length);
  final frame = [
    ...utf8.encode('USLT'),
    ...frameSizeBytes,
    0,
    if (frameUnsynchronized) 0x02 else 0x00,
    ...frameContent,
  ];
  final header = [
    ...utf8.encode('ID3'),
    3, 0, // major version 3, revision 0
    0, // flags
    ..._synchsafe(frame.length),
  ];
  return Uint8List.fromList([...header, ...frame]);
}

void main() {
  late Directory tempDir;
  late FileLyricsReader reader;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('lyrics_reader_test');
    reader = const FileLyricsReader();
  });

  tearDown(() => tempDir.delete(recursive: true));

  group('readEmbedded', () {
    test('reads a UTF-8 USLT frame from an ID3v2.3 tag', () async {
      final file = File(p.join(tempDir.path, 'song.mp3'));
      await file.writeAsBytes(_mp3WithUslt('Line one\nLine two'));

      expect(await reader.readEmbedded(file.path), 'Line one\nLine two');
    });

    test('reads a Latin-1 USLT frame', () async {
      final file = File(p.join(tempDir.path, 'song.mp3'));
      await file.writeAsBytes(_mp3WithUslt('Café', encoding: 0));

      expect(await reader.readEmbedded(file.path), 'Café');
    });

    test('returns null for non-mp3 files', () async {
      final file = File(p.join(tempDir.path, 'song.flac'));
      await file.writeAsBytes(_mp3WithUslt('Ignored'));

      expect(await reader.readEmbedded(file.path), isNull);
    });

    test('returns null when there is no ID3 tag', () async {
      final file = File(p.join(tempDir.path, 'song.mp3'));
      await file.writeAsBytes([0xFF, 0xFB, 0x90, 0x00]);

      expect(await reader.readEmbedded(file.path), isNull);
    });

    test('returns null for a missing file', () async {
      final missing = p.join(tempDir.path, 'missing.mp3');

      expect(await reader.readEmbedded(missing), isNull);
    });
  });

  group('readSidecar', () {
    test('reads a matching .lrc file', () async {
      final audio = p.join(tempDir.path, 'song.mp3');
      await File(p.join(tempDir.path, 'song.lrc')).writeAsString(
        '[00:01.00]Line one\n[00:05.00]Line two',
      );

      expect(
        await reader.readSidecar(audio),
        '[00:01.00]Line one\n[00:05.00]Line two',
      );
    });

    test('returns null when no sidecar file exists', () async {
      final audio = p.join(tempDir.path, 'song.mp3');

      expect(await reader.readSidecar(audio), isNull);
    });
  });
}
