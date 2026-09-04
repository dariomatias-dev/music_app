/// One aggregate's worth of development data.
///
/// Every seed writes through the same DAOs and repositories the app uses,
/// so a schema change breaks it in the same way it breaks the app, instead
/// of leaving it to drift with its own SQL.
///
/// Running a seed twice must leave the database as it was after the first
/// run: seeded rows carry fixed identifiers and are written as upserts, so
/// a rerun replaces them rather than piling duplicates up.
abstract interface class Seed {
  /// Writes this seed's data.
  Future<void> run();
}
