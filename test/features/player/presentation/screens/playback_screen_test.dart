import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/features/player/presentation/screens/playback_screen.dart';

import '../../../../helpers/fake_audio_player_service.dart';

void main() {
  testWidgets('shows the empty state when nothing is playing', (
    tester,
  ) async {
    final service = FakeAudioPlayerService();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [audioPlayerServiceProvider.overrideWithValue(service)],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PlaybackScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Nothing playing'), findsOneWidget);
  });
}
