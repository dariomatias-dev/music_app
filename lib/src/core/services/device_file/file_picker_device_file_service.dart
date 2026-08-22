import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:music_app/src/core/services/device_file/device_file_service.dart';

/// [DeviceFileService] implementation backed by the `file_picker` plugin.
class FilePickerDeviceFileService implements DeviceFileService {
  /// Creates a [FilePickerDeviceFileService].
  const FilePickerDeviceFileService();

  @override
  Future<void> saveFile({
    required String fileName,
    required Uint8List bytes,
  }) {
    return FilePicker.saveFile(fileName: fileName, bytes: bytes);
  }

  @override
  Future<Uint8List?> pickFile({List<String>? allowedExtensions}) async {
    final result = await FilePicker.pickFiles(
      type: allowedExtensions == null ? FileType.any : FileType.custom,
      allowedExtensions: allowedExtensions,
      withData: true,
    );
    return result?.files.singleOrNull?.bytes;
  }
}
