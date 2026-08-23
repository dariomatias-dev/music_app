import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads the fonts every test in this package renders with.
///
/// The binding is initialized first because font loading reaches it, and a
/// file with only plain `test()` calls never initializes it otherwise.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await _loadAssetFont('Roboto', const [
      'assets/fonts/Roboto-Regular.ttf',
      'assets/fonts/Roboto-Medium.ttf',
      'assets/fonts/Roboto-Bold.ttf',
    ]);
    await _loadSdkFont('MaterialIcons', const [
      'bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    ]);
  });
  return testMain();
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
  final sdkRoot = _flutterSdkRoot();
  final fontLoader = FontLoader(family);
  for (final relativePath in sdkRelativePaths) {
    final file = File('${sdkRoot.path}/$relativePath');
    fontLoader.addFont(
      file.readAsBytes().then((bytes) => ByteData.view(bytes.buffer)),
    );
  }
  await fontLoader.load();
}

/// The Flutter SDK the tests are running under.
///
/// `flutter test` exports `FLUTTER_ROOT`, which works the same under fvm and
/// on CI runners. The executable is only walked as a fallback, for runners
/// that launch the test binary without that variable.
Directory _flutterSdkRoot() {
  final fromEnvironment = Platform.environment['FLUTTER_ROOT'];
  if (fromEnvironment != null && fromEnvironment.isNotEmpty) {
    return Directory(fromEnvironment);
  }

  var dir = File(Platform.resolvedExecutable).parent;
  while (dir.parent.path != dir.path) {
    final fonts = Directory('${dir.path}/bin/cache/artifacts/material_fonts');
    if (fonts.existsSync()) return dir;
    dir = dir.parent;
  }
  throw StateError(
    'Could not locate the Flutter SDK root: FLUTTER_ROOT is unset and no '
    'SDK was found above ${Platform.resolvedExecutable}.',
  );
}
