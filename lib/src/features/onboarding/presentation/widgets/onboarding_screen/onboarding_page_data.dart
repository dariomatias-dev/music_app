import 'package:music_app/l10n/app_localizations.dart';

/// One onboarding page's content: artwork seed plus localized title/body.
class OnboardingPageData {
  /// Creates an [OnboardingPageData].
  const OnboardingPageData(this.artworkSeed, this.title, this.body);

  /// Seed used to render this page's placeholder artwork.
  final String artworkSeed;

  /// Resolves this page's title in the given localization.
  final String Function(AppLocalizations) title;

  /// Resolves this page's body text in the given localization.
  final String Function(AppLocalizations) body;
}
