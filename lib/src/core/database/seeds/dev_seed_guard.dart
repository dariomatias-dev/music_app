import 'package:flutter/foundation.dart';
import 'package:music_app/src/core/database/app_database.dart';
import 'package:music_app/src/core/database/seeds/dev_seeds.dart';

/// Whether this build was compiled with the development seeds enabled.
///
/// A compile-time constant, not a setting: with it false the seeds and
/// their data are tree-shaken out of the binary, which a runtime toggle
/// would ship to users along with the code that overwrites their library.
///
/// Enable it per run, and never as a default:
///
/// ```sh
/// fvm flutter run --dart-define=SEED_ENABLED=true
/// ```
const devSeedsEnabled = bool.fromEnvironment('SEED_ENABLED');

/// Seeds [database] when this build asked for it, and does nothing
/// otherwise.
///
/// Two independent guards, because one of them will eventually be
/// misconfigured: the build has to define the constant above, and the app
/// has to be running in debug mode. A release build never seeds, whatever
/// it was compiled with.
Future<void> runDevSeedsIfEnabled(AppDatabase database) async {
  if (!devSeedsEnabled || !kDebugMode) return;
  await runDevSeeds(database);
}
