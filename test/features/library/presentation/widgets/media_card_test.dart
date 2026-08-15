import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/features/library/presentation/widgets/media_card.dart';

void main() {
  testWidgets('shows the title and a procedural cover by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: MediaCard(seed: 'album-1', title: 'Chill Vibes', onTap: () {}),
        ),
      ),
    );

    expect(find.text('Chill Vibes'), findsOneWidget);
    expect(find.byType(AppArtwork), findsOneWidget);
  });

  testWidgets('shows the subtitle when given', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: MediaCard(
            seed: 'album-1',
            title: 'Chill Vibes',
            subtitle: 'Charcoal',
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Charcoal'), findsOneWidget);
  });

  testWidgets('omits the subtitle line when null or empty', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Column(
            children: [
              MediaCard(seed: 'a', title: 'A', onTap: () {}),
              MediaCard(seed: 'b', title: 'B', subtitle: '', onTap: () {}),
            ],
          ),
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: MediaCard(
            seed: 'album-1',
            title: 'Chill Vibes',
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Chill Vibes'));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
