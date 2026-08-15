import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/home/presentation/view_models/home_view_model.dart';
import 'package:music_app/src/features/home/presentation/widgets/home_header.dart';

/// The Home tab.
///
/// Its remaining sections (recently played, playlists and albums, library
/// summary) are built in Etapas 78-80; this wires up the screen's states.
class HomeScreen extends ConsumerWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(homeViewModelProvider);

    return AppScaffold(
      topBar: AppTopBar(title: l10n.homeTabLabel, showBack: false),
      body: ListView(
        children: [
          const HomeHeader(),
          switch (state) {
            HomeState.loading => const AppLoadingIndicator(),
            HomeState.empty => AppEmptyState(
              icon: Icons.library_music_outlined,
              title: l10n.homeEmptyTitle,
              message: l10n.homeEmptyMessage,
            ),
            HomeState.ready => const SizedBox.shrink(),
          },
        ],
      ),
    );
  }
}
