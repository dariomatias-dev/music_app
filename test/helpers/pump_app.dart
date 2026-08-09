import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps [child] wrapped in [ProviderScope] and [MaterialApp], standardizing
/// the bootstrap used across widget tests.
Future<void> pumpApp(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(home: child),
    ),
  );
}
