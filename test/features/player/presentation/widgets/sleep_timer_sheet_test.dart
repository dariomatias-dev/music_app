import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/features/player/presentation/widgets/sleep_timer_sheet.dart';

import '../../../../helpers/fake_audio_player_service.dart';

Widget _app(FakeAudioPlayerService service) {
  return ProviderScope(
    overrides: [audioPlayerServiceProvider.overrideWithValue(service)],
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: Consumer(
            builder: (context, ref, _) => TextButton(
              onPressed: () => showSleepTimerSheet(context),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows every preset but no turn-off action when inactive', (
    tester,
  ) async {
    await tester.pumpWidget(_app(FakeAudioPlayerService()));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    for (final minutes in [5, 10, 15, 30, 45, 60]) {
      expect(find.text('$minutes min'), findsOneWidget);
    }
    expect(find.text('Turn off timer'), findsNothing);
  });

  testWidgets('tapping a preset starts the timer and shows a toast', (
    tester,
  ) async {
    await tester.pumpWidget(_app(FakeAudioPlayerService()));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('15 min'));
    await tester.pumpAndSettle();

    expect(find.text('Sleep timer set'), findsOneWidget);
  });

  testWidgets('shows turn off once a timer is active, and it cancels it', (
    tester,
  ) async {
    await tester.pumpWidget(_app(FakeAudioPlayerService()));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('15 min'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Turn off timer'), findsOneWidget);

    await tester.tap(find.text('Turn off timer'));
    await tester.pumpAndSettle();

    expect(find.text('Sleep timer turned off'), findsOneWidget);
  });

  testWidgets('end of track starts a timer for the remaining duration', (
    tester,
  ) async {
    final service = FakeAudioPlayerService();
    await service.setQueue(['a.mp3']);
    service.setDurationForTesting(const Duration(minutes: 4));
    await service.seek(const Duration(minutes: 1));

    await tester.pumpWidget(_app(service));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('End of track'));
    await tester.pumpAndSettle();

    expect(find.text('Sleep timer set'), findsOneWidget);
  });

  testWidgets('end of track with nothing playing starts an immediate timer', (
    tester,
  ) async {
    final service = FakeAudioPlayerService();

    await tester.pumpWidget(_app(service));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('End of track'));
    await tester.pumpAndSettle();

    expect(find.text('Sleep timer set'), findsOneWidget);
  });
}
