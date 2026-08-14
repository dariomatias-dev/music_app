import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/player/presentation/widgets/playback_track_info.dart';

import '../../../../helpers/fake_favorite_repository.dart';

const _item = QueueMediaItem(
  id: 'track-1',
  filePath: '/music/track-1.mp3',
  title: 'Night Drive',
  artist: 'Charcoal',
  artistId: 'artist-1',
  album: 'Chill Vibes',
  albumId: 'album-1',
);

Widget _routedApp(Widget child) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(body: child),
      ),
      GoRoute(
        path: '/albums/:albumId',
        builder: (context, state) => Scaffold(
          body: Text('Album ${state.pathParameters['albumId']}'),
        ),
      ),
      GoRoute(
        path: '/artists/:artistId',
        builder: (context, state) => Scaffold(
          body: Text('Artist ${state.pathParameters['artistId']}'),
        ),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      favoriteRepositoryProvider.overrideWithValue(FakeFavoriteRepository()),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

void main() {
  testWidgets('shows the title and artist', (tester) async {
    await tester.pumpWidget(_routedApp(const PlaybackTrackInfo(item: _item)));

    expect(find.text('Night Drive'), findsOneWidget);
    expect(find.text('Charcoal'), findsOneWidget);
  });

  testWidgets('tapping the title opens the album', (tester) async {
    await tester.pumpWidget(_routedApp(const PlaybackTrackInfo(item: _item)));

    await tester.tap(find.text('Night Drive'));
    await tester.pumpAndSettle();

    expect(find.text('Album album-1'), findsOneWidget);
  });

  testWidgets('tapping the artist opens the artist', (tester) async {
    await tester.pumpWidget(_routedApp(const PlaybackTrackInfo(item: _item)));

    await tester.tap(find.text('Charcoal'));
    await tester.pumpAndSettle();

    expect(find.text('Artist artist-1'), findsOneWidget);
  });

  testWidgets('tapping the favorite button toggles it', (tester) async {
    await tester.pumpWidget(_routedApp(const PlaybackTrackInfo(item: _item)));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
