import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/storage/key_value_storage.dart';

/// Provides the [KeyValueStorage] used across the app.
///
/// Must be overridden with a real implementation before the app starts,
/// since building it requires an async instance from the underlying
/// persistence package.
final keyValueStorageProvider = Provider<KeyValueStorage>((ref) {
  throw UnimplementedError('keyValueStorageProvider was not overridden');
});
