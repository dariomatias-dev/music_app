import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/features/player/presentation/widgets/playback_speed_control.dart';

import '../../../../helpers/fake_audio_player_service.dart';

void main() {
  testWidgets('cycles through the speed presets on tap', (tester) async {
    final service = FakeAudioPlayerService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [audioPlayerServiceProvider.overrideWithValue(service)],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: PlaybackSpeedControl()),
        ),
      ),
    );

    expect(find.text('1.00x'), findsOneWidget);

    await tester.tap(find.text('1.00x'));
    await tester.pump();
    expect(service.snapshot.speed, 1.25);
    expect(find.text('1.25x'), findsOneWidget);

    await tester.tap(find.text('1.25x'));
    await tester.pump();
    expect(service.snapshot.speed, 1.5);
  });
}
