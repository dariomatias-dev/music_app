import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/errors/app_exception.dart';
import 'package:music_app/src/features/player/presentation/widgets/playback_error_listener.dart';

import '../../../../helpers/fake_audio_player_service.dart';

void main() {
  testWidgets('shows an error toast when playback fails', (tester) async {
    final service = FakeAudioPlayerService();
    addTearDown(service.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [audioPlayerServiceProvider.overrideWithValue(service)],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: PlaybackErrorListener(child: SizedBox()),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text("Couldn't play this track"), findsNothing);

    service.emitError(const PlaybackException('Playback failed.'));
    // Let the errorStream event propagate through the StreamProvider, then
    // the SnackBar animate onto screen.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text("Couldn't play this track"), findsOneWidget);
  });
}
