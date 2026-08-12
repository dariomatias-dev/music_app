// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

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
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appName => 'Music App';

  @override
  String get homeTabLabel => 'Início';

  @override
  String get searchTabLabel => 'Buscar';

  @override
  String get libraryTabLabel => 'Biblioteca';

  @override
  String get settingsTabLabel => 'Configurações';

  @override
  String get onboardingSkip => 'Pular';

  @override
  String get onboardingNext => 'Avançar';

  @override
  String get onboardingStartListening => 'Começar a ouvir';

  @override
  String get onboarding1Title => 'Sua música, no seu aparelho';

  @override
  String get onboarding1Body =>
      'Seus arquivos, lidos direto do aparelho. Sem sinal, sem conta, sem espera, e funciona igual no avião e em casa.';

  @override
  String get onboarding2Title => 'Feito para uma mão só';

  @override
  String get onboarding2Body =>
      'O player fica ao alcance no rodapé de toda tela. Arraste para o lado para pular, ou para cima para abrir em tela cheia.';

  @override
  String get onboarding3Title => 'Ele aprende o que você toca';

  @override
  String get onboarding3Body =>
      'As tocadas recentemente e os seus dados de escuta vêm do que você realmente ouve, e nada é enviado a lugar nenhum.';
}
