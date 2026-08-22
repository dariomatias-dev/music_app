import 'dart:typed_data';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A 1x1 transparent PNG, enough to exercise the embedded-image branch.
final _pngBytes = Uint8List.fromList([
  0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, //
  0x00, 0x00, 0x00, 0x0d, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1f, 0x15, 0xc4,
  0x89, 0x00, 0x00, 0x00, 0x0a, 0x49, 0x44, 0x41,
  0x54, 0x78, 0x9c, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0d, 0x0a, 0x2d, 0xb4, 0x00,
  0x00, 0x00, 0x00, 0x49, 0x45, 0x4e, 0x44, 0xae,
  0x42, 0x60, 0x82,
]);

Widget _app(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  testWidgets('draws the embedded image when there is one', (tester) async {
    await tester.pumpWidget(
      _app(AppArtwork(seed: 'track-1', imageBytes: _pngBytes, size: 64)),
    );

    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
    expect(
      tester.widget<Image>(find.byType(Image)).fit,
      BoxFit.cover,
    );
  });

  testWidgets('generates a cover when there is no embedded image', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const AppArtwork(seed: 'track-1', size: 64)));

    expect(find.byType(Image), findsNothing);
  });

  testWidgets('clips to a rounded square by default', (tester) async {
    await tester.pumpWidget(_app(const AppArtwork(seed: 'track-1', size: 64)));

    expect(find.byType(ClipRRect), findsOneWidget);
    expect(find.byType(ClipOval), findsNothing);
  });

  testWidgets('clips to a circle when asked', (tester) async {
    await tester.pumpWidget(
      _app(const AppArtwork(seed: 'artist-1', size: 64, circle: true)),
    );

    expect(find.byType(ClipOval), findsOneWidget);
    expect(find.byType(ClipRRect), findsNothing);
  });

  testWidgets('is laid out square at the requested size', (tester) async {
    await tester.pumpWidget(_app(const AppArtwork(seed: 'track-1', size: 64)));

    expect(tester.getSize(find.byType(AppArtwork)), const Size(64, 64));
  });

  testWidgets('fills the available space when given no size', (tester) async {
    await tester.pumpWidget(
      _app(
        const SizedBox(
          width: 120,
          height: 200,
          child: AppArtwork(seed: 'track-1'),
        ),
      ),
    );

    expect(tester.getSize(find.byType(AppArtwork)), const Size(120, 200));
  });

  testWidgets('paints every procedural variant without failing', (
    tester,
  ) async {
    for (var i = 0; i < 25; i++) {
      await tester.pumpWidget(
        _app(AppArtwork(seed: 'seed-$i', size: 96)),
      );
      await tester.pump();

      expect(tester.takeException(), isNull, reason: 'seed-$i failed to paint');
    }
  });

  testWidgets('paints at thumbnail sizes, where grain is skipped', (
    tester,
  ) async {
    for (var i = 0; i < 25; i++) {
      await tester.pumpWidget(_app(AppArtwork(seed: 'seed-$i', size: 24)));
      await tester.pump();

      expect(tester.takeException(), isNull, reason: 'seed-$i failed to paint');
    }
  });

  testWidgets('the same seed always draws the same cover', (tester) async {
    await tester.pumpWidget(_app(const AppArtwork(seed: 'track-1', size: 96)));
    final first = tester.widget<CustomPaint>(
      find.descendant(
        of: find.byType(AppArtwork),
        matching: find.byType(CustomPaint),
      ),
    );

    await tester.pumpWidget(_app(const AppArtwork(seed: 'track-1', size: 96)));
    final second = tester.widget<CustomPaint>(
      find.descendant(
        of: find.byType(AppArtwork),
        matching: find.byType(CustomPaint),
      ),
    );

    expect(second.painter!.shouldRepaint(first.painter!), isFalse);
  });

  testWidgets('a different seed draws a different cover', (tester) async {
    await tester.pumpWidget(_app(const AppArtwork(seed: 'track-1', size: 96)));
    final first = tester.widget<CustomPaint>(
      find.descendant(
        of: find.byType(AppArtwork),
        matching: find.byType(CustomPaint),
      ),
    );

    await tester.pumpWidget(_app(const AppArtwork(seed: 'track-2', size: 96)));
    final second = tester.widget<CustomPaint>(
      find.descendant(
        of: find.byType(AppArtwork),
        matching: find.byType(CustomPaint),
      ),
    );

    expect(second.painter!.shouldRepaint(first.painter!), isTrue);
  });
}
