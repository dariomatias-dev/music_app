import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_golden.dart';

void main() {
  const galleryKey = Key('gallery');

  Widget buildGallery() {
    return SizedBox(
      key: galleryKey,
      width: 320,
      height: 260,
      child: AppScaffold(
        topBar: const AppTopBar(
          title: 'Library',
          showBack: false,
          backButtonSemanticLabel: 'Back',
        ),
        body: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) =>
              ListTile(title: Text('Track $index')),
        ),
      ),
    );
  }

  testWidgets('AppScaffold - scrolled - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await tester.drag(find.byType(ListView), const Offset(0, -200));
    await tester.pump();
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_scaffold_scrolled_light.png'),
    );
  });

  testWidgets('AppScaffold - scrolled - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await tester.drag(find.byType(ListView), const Offset(0, -200));
    await tester.pump();
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_scaffold_scrolled_dark.png'),
    );
  });
}
