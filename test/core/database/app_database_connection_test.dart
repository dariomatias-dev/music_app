import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/database/app_database_connection.dart';

void main() {
  test('hands back an executor without opening the file yet', () {
    expect(openAppDatabaseConnection(), isA<QueryExecutor>());
  });
}
