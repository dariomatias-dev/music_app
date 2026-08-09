import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:music_app/src/core/services/id_generator/uuid_v7_generator.dart';

/// Provides the [IdGenerator] used across the app.
final idGeneratorProvider = Provider<IdGenerator>(
  (ref) => const UuidV7Generator(),
);
