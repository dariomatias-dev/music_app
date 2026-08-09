import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:uuid/uuid.dart';

/// [IdGenerator] implementation producing UUID v7 identifiers.
class UuidV7Generator implements IdGenerator {
  /// Creates a [UuidV7Generator].
  const UuidV7Generator();

  static const _uuid = Uuid();

  @override
  String generate() => _uuid.v7();
}
