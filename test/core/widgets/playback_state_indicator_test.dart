import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/widgets/playback_state_indicator.dart';

import '../../helpers/fake_audio_player_service.dart';

void main() {
  late FakeAudioPlayerService service;

  setUp(() => service = FakeAudioPlayerService());

  Future<void> pumpIndicator(WidgetTester tester, {Color? color}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [audioPlayerServiceProvider.overrideWithValue(service)],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: Scaffold(body: PlaybackStateIndicator(color: color)),
        ),
      ),
    );
    await tester.pump();
  }

  AppPlaybackIndicator indicator(WidgetTester tester) =>
      tester.widget<AppPlaybackIndicator>(find.byType(AppPlaybackIndicator));

  testWidgets('is still while nothing is playing', (tester) async {
    await pumpIndicator(tester);

    expect(indicator(tester).playing, isFalse);
  });

  testWidgets('animates once playback starts', (tester) async {
    await pumpIndicator(tester);

    await service.play();
    await tester.pump();
    await tester.pump();

    expect(indicator(tester).playing, isTrue);
  });

  testWidgets('stops again when playback pauses', (tester) async {
    await pumpIndicator(tester);
    await service.play();
    await tester.pump();
    await tester.pump();

    await service.pause();
    await tester.pump();
    await tester.pump();

    expect(indicator(tester).playing, isFalse);
  });

  testWidgets('passes its color through', (tester) async {
    await pumpIndicator(tester, color: const Color(0xFF00FF00));

    expect(indicator(tester).color, const Color(0xFF00FF00));
  });
}
