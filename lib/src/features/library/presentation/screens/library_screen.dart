import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/library/presentation/view_models/library_view_model.dart';
import 'package:music_app/src/features/library/presentation/widgets/tracks_tab.dart';

/// The Library tab: tracks, albums, artists, playlists and favorites,
/// switched between with a segmented control.
///
/// Each section's content is built in a later stage; this only wires up
/// the screen's structure and section switching.
class LibraryScreen extends ConsumerWidget {
  /// Creates a [LibraryScreen].
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final section = ref.watch(libraryViewModelProvider);

    return AppScaffold(
      topBar: AppTopBar(title: l10n.libraryTabLabel, showBack: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: AppSegmentedBar(
              labels: [
                l10n.libraryTracksTab,
                l10n.libraryAlbumsTab,
                l10n.libraryArtistsTab,
                l10n.libraryPlaylistsTab,
                l10n.libraryFavoritesTab,
              ],
              index: LibrarySection.values.indexOf(section),
              onChanged: (index) =>
                  ref.read(libraryViewModelProvider.notifier).section =
                      LibrarySection.values[index],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: AppDurations.base,
              switchInCurve: AppCurves.emphasized,
              child: switch (section) {
                LibrarySection.tracks => const TracksTab(
                  key: ValueKey(LibrarySection.tracks),
                ),
                LibrarySection.albums => const SizedBox.shrink(
                  key: ValueKey(LibrarySection.albums),
                ),
                LibrarySection.artists => const SizedBox.shrink(
                  key: ValueKey(LibrarySection.artists),
                ),
                LibrarySection.playlists => const SizedBox.shrink(
                  key: ValueKey(LibrarySection.playlists),
                ),
                LibrarySection.favorites => const SizedBox.shrink(
                  key: ValueKey(LibrarySection.favorites),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
