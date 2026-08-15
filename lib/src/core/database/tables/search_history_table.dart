import 'package:drift/drift.dart';

/// Recently searched terms.
@DataClassName('SearchHistoryRow')
class SearchHistoryTable extends Table {
  /// Primary key (UUID v7).
  TextColumn get id => text()();

  /// The searched term, trimmed.
  TextColumn get term => text()();

  /// When this term was last searched.
  DateTimeColumn get searchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
