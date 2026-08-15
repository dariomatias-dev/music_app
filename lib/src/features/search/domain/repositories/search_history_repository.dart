/// Access to the user's recent search terms.
abstract interface class SearchHistoryRepository {
  /// Watches up to [limit] recent search terms, most recently searched
  /// first.
  Stream<List<String>> watchRecentTerms({int limit});

  /// Records [term] as searched, moving it to the front if already present.
  Future<void> record(String term);

  /// Removes [term] from the history.
  Future<void> remove(String term);

  /// Clears the entire search history.
  Future<void> clear();
}
