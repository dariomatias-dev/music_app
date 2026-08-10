import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
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
