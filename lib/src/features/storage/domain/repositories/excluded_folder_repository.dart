/// Access to the folders the user has excluded from the library scan.
abstract interface class ExcludedFolderRepository {
  /// Watches every excluded folder's path.
  Stream<List<String>> watchExcludedFolders();

  /// Excludes [path] from the library scan.
  Future<void> exclude(String path);

  /// Re-includes [path] in the library scan.
  Future<void> include(String path);
}
