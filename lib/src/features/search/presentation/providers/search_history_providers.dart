import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/src/features/search/data/providers/search_data_providers.dart';

/// Up to 10 recent search terms, most recently searched first.
final recentSearchTermsProvider = StreamProvider<List<String>>(
  (ref) => ref
      .watch(searchHistoryRepositoryProvider)
      .watchRecentTerms(
        limit: 10,
      ),
);
