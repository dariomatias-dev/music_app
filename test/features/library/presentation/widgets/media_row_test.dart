import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/widgets/cached_square_image.dart';
import 'package:music_app/src/features/library/presentation/widgets/media_row.dart';

void main() {
  testWidgets('shows the title and a procedural cover by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: MediaRow(seed: 'track-1', title: 'Night Drive', onTap: () {}),
        ),
      ),
    );

    expect(find.text('Night Drive'), findsOneWidget);
    expect(find.byType(AppArtwork), findsOneWidget);
  });

  testWidgets('shows the subtitle when given', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: MediaRow(
            seed: 'track-1',
            title: 'Night Drive',
            subtitle: 'Nightbird',
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Nightbird'), findsOneWidget);
  });

  testWidgets('omits the subtitle line when null or empty', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Column(
            children: [
              MediaRow(seed: 'a', title: 'A', onTap: () {}),
              MediaRow(seed: 'b', title: 'B', subtitle: '', onTap: () {}),
            ],
          ),
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('shows the trailing widget when given', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: MediaRow(
            seed: 'track-1',
            title: 'Night Drive',
            onTap: () {},
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: MediaRow(
            seed: 'track-1',
            title: 'Night Drive',
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Night Drive'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets(
    'does not overflow with long trailing text at a large text scale',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
            child: Scaffold(
              body: SizedBox(
                width: 400,
                child: MediaRow(
                  seed: 'track-1',
                  title: 'A fairly long track title that takes real space',
                  onTap: () {},
                  trailing: const Text(
                    '99:59:59 remaining in this very long queue',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    },
  );

  group('embedded artwork', () {
    testWidgets('replaces the procedural cover with the file', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: MediaRow(
              seed: 'track-1',
              title: 'Night Drive',
              artworkPath: '/covers/album-1.jpg',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CachedSquareImage), findsOneWidget);
      expect(find.byType(AppArtwork), findsNothing);
      expect(find.byType(ClipRRect), findsOneWidget);
      tester.takeException();
    });

    testWidgets('clips it to a circle when asked', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: MediaRow(
              seed: 'artist-1',
              title: 'Charcoal',
              artworkPath: '/covers/artist-1.jpg',
              circle: true,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(ClipOval), findsOneWidget);
      expect(find.byType(ClipRRect), findsNothing);
      tester.takeException();
    });
  });
}
