import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/open.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUpAll(_overrideSqlite3ForLinux);
  return testMain();
}

/// On Linux dev machines without `libsqlite3-dev` installed, only the
/// versioned `libsqlite3.so.0` exists (from the `libsqlite3-0` runtime
/// package), not the unversioned `libsqlite3.so` that `package:sqlite3`
/// looks for by default.
void _overrideSqlite3ForLinux() {
  if (!Platform.isLinux) return;
  open.overrideFor(
    OperatingSystem.linux,
    () => DynamicLibrary.open('libsqlite3.so.0'),
  );
}
