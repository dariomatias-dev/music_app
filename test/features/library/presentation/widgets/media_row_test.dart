import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
}
