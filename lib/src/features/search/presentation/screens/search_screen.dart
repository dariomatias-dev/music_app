import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/search/presentation/view_models/search_view_model.dart';
import 'package:music_app/src/features/search/presentation/widgets/search_results_list.dart';

/// The Search tab.
///
/// Its search history (Etapa 83) comes later; this wires up the field and
/// its results.
class SearchScreen extends ConsumerStatefulWidget {
  /// Creates a [SearchScreen].
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      topBar: AppTopBar(title: l10n.searchTabLabel, showBack: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: AppSearchField(
              controller: _controller,
              hintText: l10n.searchTriggerHintLabel,
              clearButtonSemanticLabel: l10n.clearSearchSemanticLabel,
              onChanged: (value) =>
                  ref.read(searchViewModelProvider.notifier).updateTerm(value),
              onClear: () {
                _controller.clear();
                ref.read(searchViewModelProvider.notifier).clear();
              },
            ),
          ),
          const Expanded(child: SearchResultsList()),
        ],
      ),
    );
  }
}
