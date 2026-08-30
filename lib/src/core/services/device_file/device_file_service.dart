import 'dart:typed_data';

import 'package:music_app/src/core/errors/app_exception.dart';

/// Lets the user save bytes to, or pick bytes from, a file on the device.
///
/// Both methods report a failure of the underlying picker as a
/// [FileException].
abstract interface class DeviceFileService {
  /// Lets the user choose where to save [bytes], suggesting [fileName].
  Future<void> saveFile({required String fileName, required Uint8List bytes});

  /// Lets the user pick a file, returning its bytes, or `null` if the user
  /// cancelled or the platform couldn't read them.
  Future<Uint8List?> pickFile({List<String>? allowedExtensions});
}
