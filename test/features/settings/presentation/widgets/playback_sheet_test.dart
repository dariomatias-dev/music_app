import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/settings/presentation/widgets/playback_sheet.dart';

import '../../../../helpers/fake_key_value_storage.dart';

Widget _app({FakeKeyValueStorage? storage}) {
  return ProviderScope(
    overrides: [
      keyValueStorageProvider.overrideWithValue(
        storage ?? FakeKeyValueStorage(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: Consumer(
            builder: (context, ref, _) => TextButton(
              onPressed: () => showPlaybackSheet(context, ref),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  // Pressable.hapticsEnabled is process-global static state (the design
  // system has no Riverpod access of its own); reset it after every test
  // so a haptics toggle doesn't leak into other test files.
  tearDown(() => Pressable.hapticsEnabled = true);

  testWidgets('shows the default preference values', (tester) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Gapless playback'), findsOneWidget);
    expect(find.text('Crossfade'), findsOneWidget);
    expect(find.text('Default speed'), findsOneWidget);
    expect(find.text('1x'), findsOneWidget);
    expect(find.text('Haptic feedback'), findsOneWidget);
    expect(
      tester.widget<AppSwitch>(find.byType(AppSwitch).first).value,
      isTrue,
    );
    expect(find.byType(Slider), findsNothing);
  });

  testWidgets('toggling the gapless switch persists the change', (
    tester,
  ) async {
    final storage = FakeKeyValueStorage();
    await tester.pumpWidget(_app(storage: storage));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(AppSwitch).first);
    await tester.pump();

    expect(await storage.getBool('gaplessEnabled'), isFalse);
  });

  testWidgets('turning on crossfade shows the slider and sets 4s', (
    tester,
  ) async {
    final storage = FakeKeyValueStorage();
    await tester.pumpWidget(_app(storage: storage));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(AppSwitch).at(1));
    await tester.pumpAndSettle();

    expect(await storage.getInt('crossfadeDurationSeconds'), 4);
    expect(find.byType(Slider), findsOneWidget);
    expect(find.text('4s'), findsOneWidget);
  });

  testWidgets('picking a default speed persists it and updates the chip', (
    tester,
  ) async {
    final storage = FakeKeyValueStorage();
    await tester.pumpWidget(_app(storage: storage));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('1.5x'));
    await tester.pump();

    expect(await storage.getDouble('defaultPlaybackSpeed'), 1.5);
  });

  testWidgets('toggling haptics persists the change', (tester) async {
    final storage = FakeKeyValueStorage();
    await tester.pumpWidget(_app(storage: storage));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(AppSwitch).last);
    await tester.pump();

    expect(await storage.getBool('hapticsEnabled'), isFalse);
  });

  testWidgets('gapless switch is disabled while crossfade is active', (
    tester,
  ) async {
    final storage = FakeKeyValueStorage();
    await storage.setInt('crossfadeDurationSeconds', 4);
    await tester.pumpWidget(_app(storage: storage));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<AppSwitch>(find.byType(AppSwitch).first).onChanged,
      isNull,
    );
  });
}
