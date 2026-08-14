import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_player_service.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/features/player/presentation/widgets/playback_controls.dart';

import '../../../../helpers/fake_audio_player_service.dart';

Future<void> _pumpControls(
  WidgetTester tester,
  FakeAudioPlayerService service,
  MusicAudioHandler handler,
) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        audioPlayerServiceProvider.overrideWithValue(service),
        audioHandlerProvider.overrideWithValue(handler),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: PlaybackControls()),
      ),
    ),
  );
}

void main() {
  testWidgets('play/pause toggles the player', (tester) async {
    final service = FakeAudioPlayerService();
    final handler = MusicAudioHandler(service);
    addTearDown(handler.dispose);
    await service.setQueue(['a.mp3']);

    await _pumpControls(tester, service, handler);

    await tester.tap(find.bySemanticsLabel('Play'));
    await tester.pump();
    expect(service.snapshot.playing, isTrue);
  });

  testWidgets('previous and next seek the player', (tester) async {
    final service = FakeAudioPlayerService();
    final handler = MusicAudioHandler(service);
    addTearDown(handler.dispose);
    await service.setQueue(['a.mp3', 'b.mp3', 'c.mp3'], initialIndex: 1);

    await _pumpControls(tester, service, handler);

    await tester.tap(find.bySemanticsLabel('Next track'));
    await tester.pump();
    expect(service.snapshot.currentIndex, 2);

    await tester.tap(find.bySemanticsLabel('Previous track'));
    await tester.pump();
    expect(service.snapshot.currentIndex, 1);
  });

  testWidgets('shuffle toggles enabled state', (tester) async {
    final service = FakeAudioPlayerService();
    final handler = MusicAudioHandler(service);
    addTearDown(handler.dispose);

    await _pumpControls(tester, service, handler);

    await tester.tap(find.bySemanticsLabel('Shuffle'));
    await tester.pump();
    expect(service.snapshot.shuffleModeEnabled, isTrue);
  });

  testWidgets('repeat cycles off -> queue -> track -> off', (tester) async {
    final service = FakeAudioPlayerService();
    final handler = MusicAudioHandler(service);
    addTearDown(handler.dispose);

    await _pumpControls(tester, service, handler);

    final repeat = find.bySemanticsLabel('Repeat');

    await tester.tap(repeat);
    await tester.pump();
    expect(service.snapshot.loopMode, AudioLoopMode.queue);

    await tester.tap(repeat);
    await tester.pump();
    expect(service.snapshot.loopMode, AudioLoopMode.track);

    await tester.tap(repeat);
    await tester.pump();
    expect(service.snapshot.loopMode, AudioLoopMode.off);
  });
}
