// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Music App';

  @override
  String get homeTabLabel => 'Inicio';

  @override
  String get searchTabLabel => 'Buscar';

  @override
  String get libraryTabLabel => 'Biblioteca';

  @override
  String get settingsTabLabel => 'Configuración';

  @override
  String get onboardingSkip => 'Saltar';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingStartListening => 'Empezar a escuchar';

  @override
  String get onboarding1Title => 'Tu música, en tu dispositivo';

  @override
  String get onboarding1Body =>
      'Tus archivos, leídos del dispositivo. Sin señal, sin cuenta, sin esperas, y funciona igual en un avión que en casa.';

  @override
  String get onboarding2Title => 'Hecho para una mano';

  @override
  String get onboarding2Body =>
      'El reproductor queda al alcance abajo en cada pantalla. Deslízalo a los lados para saltar, o hacia arriba para abrirlo completo.';

  @override
  String get onboarding3Title => 'Aprende lo que reproduces';

  @override
  String get onboarding3Body =>
      'Las reproducidas hace poco y tus datos vienen de lo que realmente escuchas, y nada se envía a ninguna parte.';

  @override
  String get permissionTitle => 'Accede a tu música';

  @override
  String get permissionMessage =>
      'Music App necesita acceder a los archivos de audio de tu dispositivo para encontrar y reproducir tu biblioteca. Nada sale de tu dispositivo.';

  @override
  String get permissionGrant => 'Permitir acceso';

  @override
  String get permissionOpenSettings => 'Abrir configuración';

  @override
  String get permissionScanning => 'Escaneando tu biblioteca…';

  @override
  String get backButtonSemanticLabel => 'Atrás';

  @override
  String get playbackEmptyTitle => 'Nada sonando';

  @override
  String get playbackEmptyMessage =>
      'Reproduce una pista de tu biblioteca para verla aquí.';

  @override
  String get favoriteButtonSemanticLabel => 'Añadir a favoritos';
}
