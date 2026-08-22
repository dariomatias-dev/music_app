import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reads the current wall-clock time.
typedef Clock = DateTime Function();

/// Provides the [Clock] used to render time-dependent content.
///
/// Overriding it keeps widgets that branch on the current time deterministic
/// in tests, instead of changing behaviour with the hour the suite runs.
final clockProvider = Provider<Clock>((ref) => DateTime.now);
