import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/settings/presentation/screens/about_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../helpers/fake_key_value_storage.dart';

Widget _app({FakeKeyValueStorage? storage}) {
  final router = GoRouter(
    initialLocation: '/about',
    routes: [
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) =>
            const Scaffold(body: Text('Onboarding screen reached')),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const Scaffold(body: AboutScreen()),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      keyValueStorageProvider.overrideWithValue(
        storage ?? FakeKeyValueStorage(),
      ),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

void main() {
  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'Music App',
      packageName: 'com.example.music_app',
      version: '1.2.3',
      buildNumber: '7',
      buildSignature: '',
    );
  });

  testWidgets('shows the app name, version and license text', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('Music App'), findsOneWidget);
    expect(find.text('Version 1.2.3 (7)'), findsOneWidget);
    expect(find.textContaining('MIT License'), findsOneWidget);
  });

  testWidgets('replaying onboarding resets it and navigates there', (
    tester,
  ) async {
    final storage = FakeKeyValueStorage();
    await storage.setBool('onboardingCompleted', value: true);
    await tester.pumpWidget(_app(storage: storage));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Show onboarding again'));
    await tester.pumpAndSettle();

    expect(find.text('Onboarding screen reached'), findsOneWidget);
    expect(await storage.getBool('onboardingCompleted'), isFalse);
  });
}
