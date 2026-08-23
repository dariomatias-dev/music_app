import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/features/player/presentation/view_models/playback_view_model.dart';
import 'package:music_app/src/features/player/presentation/widgets/sleep_timer_sheet.dart';

import '../../../../helpers/fake_audio_player_service.dart';

/// Pumps the sheet's trigger, priming `playbackViewModelProvider` first.
///
/// The provider is lazy (nothing in the sheet's widget tree watches it),
/// so an `End of track` tap right after pumping would read it before its
/// stream has emitted, always seeing `null`. A settling pump first lets it
/// resolve onto the service's current snapshot.
Future<void> _pumpApp(
  WidgetTester tester,
  FakeAudioPlayerService service,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [audioPlayerServiceProvider.overrideWithValue(service)],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: Consumer(
              builder: (context, ref, _) {
                ref.watch(playbackViewModelProvider);
                return TextButton(
                  onPressed: () => showSleepTimerSheet(context),
                  child: const Text('open'),
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('shows every preset but no turn-off action when inactive', (
    tester,
  ) async {
    await _pumpApp(tester, FakeAudioPlayerService());

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
    await _pumpApp(tester, FakeAudioPlayerService());

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('15 min'));
    await tester.pumpAndSettle();

    expect(find.text('Sleep timer set'), findsOneWidget);
  });

  testWidgets('shows turn off once a timer is active, and it cancels it', (
    tester,
  ) async {
    await _pumpApp(tester, FakeAudioPlayerService());

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

    await _pumpApp(tester, service);

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

    await _pumpApp(tester, service);

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('End of track'));
    await tester.pumpAndSettle();

    expect(find.text('Sleep timer set'), findsOneWidget);
  });

  testWidgets(
    'end of track already reached (position at or past duration) pauses '
    'immediately instead of scheduling a negative timer',
    (tester) async {
      final service = FakeAudioPlayerService();
      await service.setQueue(['a.mp3']);
      await service.play();
      service.setDurationForTesting(const Duration(minutes: 4));
      await service.seek(const Duration(minutes: 4));

      await _pumpApp(tester, service);

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('End of track'));
      await tester.pumpAndSettle();

      expect(find.text('Sleep timer set'), findsOneWidget);
      expect(service.snapshot.playing, isFalse);
    },
  );
}
