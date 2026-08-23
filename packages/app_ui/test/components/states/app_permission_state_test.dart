import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<({List<String> taps})> _pumpState(
  WidgetTester tester, {
  required bool isPermanentlyDenied,
  bool withSettingsAction = true,
}) async {
  final taps = <String>[];

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: AppPermissionState(
          icon: Icons.perm_media_outlined,
          title: 'Media access',
          message: 'The app needs access to your audio files.',
          grantLabel: 'Allow access',
          onGrant: () => taps.add('grant'),
          isPermanentlyDenied: isPermanentlyDenied,
          openSettingsLabel: withSettingsAction ? 'Open settings' : null,
          onOpenSettings: withSettingsAction
              ? () => taps.add('settings')
              : null,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return (taps: taps);
}

void main() {
  group('while the permission can still be granted', () {
    testWidgets('granting is the primary action', (tester) async {
      final result = await _pumpState(tester, isPermanentlyDenied: false);

      expect(
        find.descendant(
          of: find.byType(AppPrimaryButton),
          matching: find.text('Allow access'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Allow access'));
      await tester.pumpAndSettle();

      expect(result.taps, ['grant']);
    });

    testWidgets('settings is offered as a secondary action', (tester) async {
      final result = await _pumpState(tester, isPermanentlyDenied: false);

      await tester.tap(find.text('Open settings'));
      await tester.pumpAndSettle();

      expect(result.taps, ['settings']);
    });

    testWidgets('the secondary action is dropped when there is none', (
      tester,
    ) async {
      await _pumpState(
        tester,
        isPermanentlyDenied: false,
        withSettingsAction: false,
      );

      expect(find.text('Open settings'), findsNothing);
    });
  });

  group('once the permission is permanently denied', () {
    testWidgets('settings takes over as the primary action', (tester) async {
      final result = await _pumpState(tester, isPermanentlyDenied: true);

      expect(
        find.descendant(
          of: find.byType(AppPrimaryButton),
          matching: find.text('Open settings'),
        ),
        findsOneWidget,
      );
      expect(find.text('Allow access'), findsNothing);

      await tester.tap(find.text('Open settings'));
      await tester.pumpAndSettle();

      expect(result.taps, ['settings']);
    });

    testWidgets('falls back to the grant label without a settings one', (
      tester,
    ) async {
      await _pumpState(
        tester,
        isPermanentlyDenied: true,
        withSettingsAction: false,
      );

      expect(
        find.descendant(
          of: find.byType(AppPrimaryButton),
          matching: find.text('Allow access'),
        ),
        findsOneWidget,
      );
    });
  });
}
