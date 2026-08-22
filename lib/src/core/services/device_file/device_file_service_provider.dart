import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/services/device_file/device_file_service.dart';
import 'package:music_app/src/core/services/device_file/file_picker_device_file_service.dart';

/// Provides the [DeviceFileService] used across the app.
final deviceFileServiceProvider = Provider<DeviceFileService>(
  (ref) => const FilePickerDeviceFileService(),
);
