import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_player_service.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/player/presentation/widgets/playback_controls.dart';
import 'package:music_app/src/features/settings/presentation/view_models/playback_preferences_view_model.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fake_key_value_storage.dart';

Future<void> _pumpControls(
  WidgetTester tester,
  FakeAudioPlayerService service,
  MusicAudioHandler handler, {
  FakeKeyValueStorage? storage,
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        audioPlayerServiceProvider.overrideWithValue(service),
        audioHandlerProvider.overrideWithValue(handler),
        keyValueStorageProvider.overrideWithValue(
          storage ?? FakeKeyValueStorage(),
        ),
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

  testWidgets('triggers haptic feedback on tap by default', (tester) async {
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        calls.add(call);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    final service = FakeAudioPlayerService();
    final handler = MusicAudioHandler(service);
    addTearDown(handler.dispose);

    await _pumpControls(tester, service, handler);
    await tester.tap(find.bySemanticsLabel('Shuffle'));
    await tester.pump();

    expect(calls.any((c) => c.method == 'HapticFeedback.vibrate'), isTrue);
  });

  testWidgets('does not trigger haptic feedback when disabled', (
    tester,
  ) async {
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        calls.add(call);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    // Pressable.hapticsEnabled is process-global static state (the design
    // system has no Riverpod access of its own), so it must be restored
    // after this test to avoid leaking into others.
    addTearDown(() => Pressable.hapticsEnabled = true);

    final storage = FakeKeyValueStorage();
    await storage.setBool('hapticsEnabled', value: false);
    final service = FakeAudioPlayerService();
    final handler = MusicAudioHandler(service);
    addTearDown(handler.dispose);

    await _pumpControls(tester, service, handler, storage: storage);
    // Forces the preferences to finish loading before tapping, since
    // PlaybackControls only reads them (not watches), so nothing else
    // would otherwise trigger that load.
    final container = ProviderScope.containerOf(
      tester.element(find.byType(PlaybackControls)),
    );
    await container.read(playbackPreferencesViewModelProvider.future);
    await tester.tap(find.bySemanticsLabel('Shuffle'));
    await tester.pump();

    expect(calls.any((c) => c.method == 'HapticFeedback.vibrate'), isFalse);
  });
}
