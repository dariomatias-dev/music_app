import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_view_model.g.dart';

/// How long typing pauses before the search term updates.
const _debounceDuration = Duration(milliseconds: 350);

/// The search screen's current term, debounced so results (built in
/// Etapa 82) aren't recomputed on every keystroke.
@riverpod
class SearchViewModel extends _$SearchViewModel {
  Timer? _debounce;

  @override
  String build() {
    ref.onDispose(() => _debounce?.cancel());
    return '';
  }

  /// Called on every keystroke; updates [state] after typing pauses.
  void updateTerm(String term) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () => state = term.trim());
  }

  /// Clears the term immediately, without waiting on the debounce.
  void clear() {
    _debounce?.cancel();
    state = '';
  }
}
