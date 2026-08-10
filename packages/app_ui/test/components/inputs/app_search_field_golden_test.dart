import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_golden.dart';

void main() {
  Widget buildGallery() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        AppSearchField(
          controller: TextEditingController(),
          hintText: 'Search anything',
          clearButtonSemanticLabel: 'Clear',
        ),
        AppSearchField(
          controller: TextEditingController(text: 'chill'),
          hintText: 'Search anything',
          clearButtonSemanticLabel: 'Clear',
        ),
      ],
    );
  }

  testWidgets('AppSearchField - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byType(Column),
      matchesGoldenFile('goldens/app_search_field_light.png'),
    );
  });

  testWidgets('AppSearchField - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byType(Column),
      matchesGoldenFile('goldens/app_search_field_dark.png'),
    );
  });
}
