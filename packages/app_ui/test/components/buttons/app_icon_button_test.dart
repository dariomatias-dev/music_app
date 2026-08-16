import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('tapping calls onPressed', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _app(
        AppIconButton(
          icon: Icons.favorite_border,
          semanticLabel: 'Favorite',
          onPressed: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.byType(AppIconButton));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('changing the icon animates to the new one', (tester) async {
    await tester.pumpWidget(
      _app(
        const AppIconButton(
          icon: Icons.favorite_border,
          semanticLabel: 'Favorite',
          onPressed: null,
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNothing);

    await tester.pumpWidget(
      _app(
        const AppIconButton(
          icon: Icons.favorite,
          semanticLabel: 'Favorite',
          onPressed: null,
        ),
      ),
    );
    // Mid-flight: both the outgoing and incoming icons are mounted while
    // the AnimatedSwitcher cross-fades between them.
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite_border), findsNothing);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
