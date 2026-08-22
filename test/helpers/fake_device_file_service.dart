import 'dart:typed_data';

import 'package:music_app/src/core/services/device_file/device_file_service.dart';

/// In-memory [DeviceFileService] for tests.
class FakeDeviceFileService implements DeviceFileService {
  /// Bytes to return from the next [pickFile] call, `null` simulates the
  /// user cancelling.
  Uint8List? fileToPick;

  /// Whether [saveFile] should throw, simulating a platform failure.
  bool saveShouldThrow = false;

  /// The file name passed to the most recent [saveFile] call.
  String? savedFileName;

  /// The bytes passed to the most recent [saveFile] call.
  Uint8List? savedBytes;

  @override
  Future<void> saveFile({
    required String fileName,
    required Uint8List bytes,
  }) async {
    if (saveShouldThrow) throw Exception('save failed');
    savedFileName = fileName;
    savedBytes = bytes;
  }

  @override
  Future<Uint8List?> pickFile({List<String>? allowedExtensions}) async {
    return fileToPick;
  }
}
