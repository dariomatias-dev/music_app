// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Music App';

  @override
  String get homeTabLabel => 'Home';

  @override
  String get searchTabLabel => 'Search';

  @override
  String get libraryTabLabel => 'Library';

  @override
  String get settingsTabLabel => 'Settings';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStartListening => 'Start listening';

  @override
  String get onboarding1Title => 'Your music, on your device';

  @override
  String get onboarding1Body =>
      'Your files, read straight from the device. No signal, no account, no waiting, and it works the same on a plane as it does at home.';

  @override
  String get onboarding2Title => 'Built for one hand';

  @override
  String get onboarding2Body =>
      'The player stays within reach at the bottom of every screen. Swipe it sideways to skip, or up to open it full screen.';

  @override
  String get onboarding3Title => 'It learns what you play';

  @override
  String get onboarding3Body =>
      'Recently played and your listening stats come from what you actually listen to, and nothing is sent anywhere.';

  @override
  String get permissionTitle => 'Access your music';

  @override
  String get permissionMessage =>
      'Music App needs access to your device\'s audio files to find and play your library. Nothing ever leaves your device.';

  @override
  String get permissionGrant => 'Allow access';

  @override
  String get permissionOpenSettings => 'Open settings';

  @override
  String get permissionScanning => 'Scanning your library…';

  @override
  String get backButtonSemanticLabel => 'Back';

  @override
  String get playbackEmptyTitle => 'Nothing playing';

  @override
  String get playbackEmptyMessage =>
      'Play a track from your library to see it here.';

  @override
  String get favoriteButtonSemanticLabel => 'Add to favorites';
}
