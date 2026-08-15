import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/search/data/providers/search_data_providers.dart';
import 'package:music_app/src/features/search/presentation/view_models/search_view_model.dart';
import 'package:music_app/src/features/search/presentation/widgets/recent_searches_list.dart';
import 'package:music_app/src/features/search/presentation/widgets/search_results_list.dart';

/// The Search tab: a field, its recent-search history when empty, and its
/// results once a term settles.
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
    final searchTerm = ref.watch(searchViewModelProvider);

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
              onSubmitted: _submit,
              onClear: () {
                _controller.clear();
                ref.read(searchViewModelProvider.notifier).clear();
              },
            ),
          ),
          Expanded(
            child: searchTerm.isEmpty
                ? RecentSearchesList(onSelect: _selectRecentTerm)
                : const SearchResultsList(),
          ),
        ],
      ),
    );
  }

  void _submit(String value) {
    ref.read(searchViewModelProvider.notifier).submit(value);
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      unawaited(ref.read(searchHistoryRepositoryProvider).record(trimmed));
    }
  }

  void _selectRecentTerm(String term) {
    _controller.text = term;
    ref.read(searchViewModelProvider.notifier).submit(term);
  }
}
