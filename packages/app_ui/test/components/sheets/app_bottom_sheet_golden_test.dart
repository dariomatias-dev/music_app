import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _showSheet(WidgetTester tester, ThemeData theme) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                onPressed: () => AppBottomSheet.show<void>(
                  context,
                  builder: (sheetContext) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppSheetHeader(
                        artworkSeed: 'track-1',
                        title: 'Night Drive',
                        subtitle: 'Chill Vibes · Charcoal',
                      ),
                      AppSheetAction(
                        icon: Icons.playlist_add,
                        label: 'Add to playlist',
                        onTap: () {},
                      ),
                      AppSheetAction(
                        icon: Icons.delete_outline,
                        label: 'Remove from playlist',
                        destructive: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                child: const Text('Trigger'),
              ),
            );
          },
        ),
      ),
    ),
  );
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('AppBottomSheet - light', (tester) async {
    await _showSheet(tester, AppTheme.light);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/app_bottom_sheet_light.png'),
    );
  });

  testWidgets('AppBottomSheet - dark', (tester) async {
    await _showSheet(tester, AppTheme.dark);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/app_bottom_sheet_dark.png'),
    );
  });
}
