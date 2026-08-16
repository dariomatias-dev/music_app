import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/open.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Font loading needs the services binding, which plain `test()` files
  // (as opposed to `testWidgets()`) never otherwise initialize.
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(_overrideSqlite3ForLinux);
  setUpAll(_loadFontsForGoldens);
  setUpAll(_resetDebugPaintFlags);
  return testMain();
}

/// A DevTools session attached to this run (e.g. from the IDE) can leave
/// debug paint overlays (baselines, size, repaint rainbow) toggled on;
/// those bleed into golden images as stray colored lines otherwise.
void _resetDebugPaintFlags() {
  debugPaintSizeEnabled = false;
  debugPaintBaselinesEnabled = false;
  debugPaintPointersEnabled = false;
  debugPaintLayerBordersEnabled = false;
  debugRepaintRainbowEnabled = false;
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

/// Loads the real fonts golden tests render with, instead of the tofu
/// blocks tests fall back to by default.
///
/// Roboto ships as an asset of the `app_ui` package, so it's addressed
/// under its `packages/` prefix here rather than a bare asset path.
Future<void> _loadFontsForGoldens() async {
  await _loadAssetFont('Roboto', const [
    'packages/app_ui/assets/fonts/Roboto-Regular.ttf',
    'packages/app_ui/assets/fonts/Roboto-Medium.ttf',
    'packages/app_ui/assets/fonts/Roboto-Bold.ttf',
  ]);
  await _loadSdkFont('MaterialIcons', const [
    'bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  ]);
}

Future<void> _loadAssetFont(String family, List<String> assets) async {
  final fontLoader = FontLoader(family);
  for (final asset in assets) {
    fontLoader.addFont(rootBundle.load(asset));
  }
  await fontLoader.load();
}

/// Loads a font shipped with the Flutter SDK directly from disk, since the
/// `packages/flutter/fonts/...` asset bundle path does not resolve in this
/// environment.
Future<void> _loadSdkFont(String family, List<String> sdkRelativePaths) async {
  final sdkRoot = _findFlutterSdkRoot(Directory.current);
  final fontLoader = FontLoader(family);
  for (final relativePath in sdkRelativePaths) {
    final file = File('${sdkRoot.path}/$relativePath');
    fontLoader.addFont(
      file.readAsBytes().then((bytes) => ByteData.view(bytes.buffer)),
    );
  }
  await fontLoader.load();
}

Directory _findFlutterSdkRoot(Directory from) {
  var dir = from;
  while (true) {
    final candidate = Directory('${dir.path}/.fvm/flutter_sdk');
    if (candidate.existsSync()) {
      return Directory(candidate.resolveSymbolicLinksSync());
    }
    final parent = dir.parent;
    if (parent.path == dir.path) {
      throw StateError('Could not locate .fvm/flutter_sdk above ${from.path}');
    }
    dir = parent;
  }
}
