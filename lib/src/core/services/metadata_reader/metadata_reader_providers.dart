import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/services/metadata_reader/metadata_god_reader.dart';
import 'package:music_app/src/core/services/metadata_reader/metadata_reader.dart';

/// Provides the [MetadataReader] used across the app.
final metadataReaderProvider = Provider<MetadataReader>(
  (ref) => const MetadataGodReader(),
);
