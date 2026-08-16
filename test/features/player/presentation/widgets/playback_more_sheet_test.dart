import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/features/player/presentation/widgets/playback_more_sheet.dart';

const _item = QueueMediaItem(
  id: 'track-1',
  filePath: '/music/night-drive.flac',
  title: 'Night Drive',
  artist: 'Charcoal',
);

Widget _app() {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: Center(
            child: Consumer(
              builder: (context, ref, _) => TextButton(
                onPressed: () => showPlaybackMoreSheet(context, ref, _item),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: RoutePaths.queue,
        builder: (context, state) => const Scaffold(body: Text('Queue screen')),
      ),
      GoRoute(
        path: RoutePaths.lyrics,
        builder: (context, state) =>
            const Scaffold(body: Text('Lyrics screen')),
      ),
    ],
  );
  return ProviderScope(
    child: MaterialApp.router(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

void main() {
  testWidgets('shows the track and every action', (tester) async {
    await tester.pumpWidget(_app());

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Night Drive'), findsOneWidget);
    expect(find.text('Charcoal'), findsOneWidget);
    expect(find.text('Queue'), findsOneWidget);
    expect(find.text('Add to playlist'), findsOneWidget);
    expect(find.text('Lyrics'), findsOneWidget);
    expect(find.text('Sleep timer'), findsOneWidget);
    expect(find.text('File information'), findsOneWidget);
  });

  testWidgets('view queue closes the sheet and navigates to the queue', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Queue'));
    await tester.pumpAndSettle();

    expect(find.text('Queue screen'), findsOneWidget);
    expect(find.text('Add to playlist'), findsNothing);
  });

  testWidgets('open lyrics closes the sheet and navigates to lyrics', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lyrics'));
    await tester.pumpAndSettle();

    expect(find.text('Lyrics screen'), findsOneWidget);
  });
}
