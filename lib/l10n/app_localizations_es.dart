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

  @override
  String get unfavoriteButtonSemanticLabel => 'Quitar de favoritos';

  @override
  String get shuffleButtonSemanticLabel => 'Aleatorio';

  @override
  String get previousTrackButtonSemanticLabel => 'Pista anterior';

  @override
  String get nextTrackButtonSemanticLabel => 'Siguiente pista';

  @override
  String get repeatButtonSemanticLabel => 'Repetir';

  @override
  String get moreOptionsButtonSemanticLabel => 'Más opciones';

  @override
  String get viewQueueLabel => 'Cola';

  @override
  String get addToPlaylistLabel => 'Añadir a lista de reproducción';

  @override
  String get openLyricsLabel => 'Letra';

  @override
  String get sleepTimerLabel => 'Temporizador';

  @override
  String get fileInfoLabel => 'Información del archivo';

  @override
  String get fileInfoDialogTitle => 'Información del archivo';

  @override
  String get fileInfoFormatLabel => 'Formato';

  @override
  String get fileInfoSizeLabel => 'Tamaño';

  @override
  String get fileInfoBitrateLabel => 'Tasa de bits';

  @override
  String get fileInfoSampleRateLabel => 'Tasa de muestreo';

  @override
  String get fileInfoPathLabel => 'Ruta';

  @override
  String get dialogDismissLabel => 'OK';

  @override
  String get sleepTimerSheetTitle => 'Temporizador de apagado';

  @override
  String get sleepTimerSheetBody =>
      'Pausa la reproducción automáticamente tras un tiempo definido.';

  @override
  String get sleepTimerEndOfTrackLabel => 'Fin de la pista';

  @override
  String get sleepTimerTurnOffLabel => 'Apagar temporizador';

  @override
  String get sleepTimerSetMessage => 'Temporizador definido';

  @override
  String get sleepTimerOffMessage => 'Temporizador apagado';

  @override
  String get queueEmptyTitle => 'La cola está vacía';

  @override
  String get queueEmptyMessage =>
      'Reproduce una pista de tu biblioteca para llenar la cola.';

  @override
  String get nowPlayingSemanticLabel => 'Sonando ahora';

  @override
  String get queueEditLabel => 'Editar';

  @override
  String get queueDoneLabel => 'Listo';

  @override
  String get removeFromQueueSemanticLabel => 'Quitar de la cola';

  @override
  String get dragToReorderSemanticLabel => 'Arrastra para reordenar';

  @override
  String get clearQueueLabel => 'Vaciar cola';

  @override
  String get clearQueueConfirmTitle => '¿Vaciar la cola?';

  @override
  String get clearQueueConfirmMessage =>
      'Esto elimina todas las pistas de la cola y detiene la reproducción.';

  @override
  String get clearQueueConfirmAction => 'Vaciar';

  @override
  String get cancelLabel => 'Cancelar';

  @override
  String get lyricsEmptyTitle => 'No se encontró letra';

  @override
  String get lyricsEmptyMessage =>
      'Esta pista no tiene letra incrustada ni un archivo .lrc correspondiente.';

  @override
  String get libraryTracksTab => 'Pistas';

  @override
  String get libraryAlbumsTab => 'Álbumes';

  @override
  String get libraryArtistsTab => 'Artistas';

  @override
  String get libraryPlaylistsTab => 'Listas';

  @override
  String get libraryFavoritesTab => 'Favoritos';

  @override
  String get sortByTitleLabel => 'Título';

  @override
  String get sortByArtistLabel => 'Artista';

  @override
  String get sortByDateAddedLabel => 'Fecha de adición';

  @override
  String get sortByDurationLabel => 'Duración';

  @override
  String get sortSheetTitle => 'Ordenar por';

  @override
  String get tracksEmptyTitle => 'Aún no hay pistas';

  @override
  String get tracksEmptyMessage =>
      'Las pistas encontradas en tu dispositivo aparecerán aquí.';

  @override
  String get playLabel => 'Reproducir';

  @override
  String trackCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistas',
      one: '$count pista',
    );
    return '$_temp0';
  }

  @override
  String get albumsEmptyTitle => 'Aún no hay álbumes';

  @override
  String get albumsEmptyMessage =>
      'Los álbumes encontrados en tu dispositivo aparecerán aquí.';

  @override
  String get albumNotFoundTitle => 'Álbum no encontrado';

  @override
  String get albumNotFoundMessage =>
      'Este álbum puede haber sido eliminado de tu biblioteca.';

  @override
  String get artistsEmptyTitle => 'Aún no hay artistas';

  @override
  String get artistsEmptyMessage =>
      'Los artistas encontrados en tu dispositivo aparecerán aquí.';

  @override
  String get artistNotFoundTitle => 'Artista no encontrado';

  @override
  String get artistNotFoundMessage =>
      'Este artista puede haber sido eliminado de tu biblioteca.';

  @override
  String albumCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count álbumes',
      one: '$count álbum',
    );
    return '$_temp0';
  }

  @override
  String get favoritesEmptyTitle => 'Aún no hay favoritos';

  @override
  String get favoritesEmptyMessage =>
      'Las pistas que marques como favoritas aparecerán aquí.';

  @override
  String get newPlaylistLabel => 'Nueva lista';

  @override
  String get playlistNameHint => 'Nombre de la lista';

  @override
  String get createLabel => 'Crear';

  @override
  String get saveLabel => 'Guardar';

  @override
  String get renamePlaylistSheetTitle => 'Renombrar lista';

  @override
  String get renamePlaylistLabel => 'Renombrar';

  @override
  String get duplicatePlaylistLabel => 'Duplicar';

  @override
  String get deletePlaylistLabel => 'Eliminar';

  @override
  String get deletePlaylistConfirmTitle => '¿Eliminar lista?';

  @override
  String get deletePlaylistConfirmMessage =>
      'Esto elimina la lista. Sus pistas permanecen en tu biblioteca.';

  @override
  String get playlistOptionsSemanticLabel => 'Opciones de la lista';

  @override
  String get playlistsEmptyTitle => 'Aún no hay listas';

  @override
  String get playlistsEmptyMessage => 'Toca Nueva lista para crear la primera.';

  @override
  String playlistCopyName(String name) {
    return '$name copia';
  }

  @override
  String get addedToPlaylistMessage => 'Añadida a la lista';

  @override
  String get trackAlreadyInPlaylistMessage => 'Ya está en esta lista';

  @override
  String get removeFromPlaylistSemanticLabel => 'Quitar de la lista';

  @override
  String get removeTrackConfirmTitle => '¿Quitar pista?';

  @override
  String get removeTrackConfirmMessage =>
      'Esto la quita de la lista. Sigue en tu biblioteca.';

  @override
  String get playlistEmptyTitle => 'Esta lista está vacía';

  @override
  String get playlistEmptyMessage =>
      'Agrega pistas desde el menú \"más\" de una pista.';

  @override
  String get homeEmptyTitle => 'Tu biblioteca está vacía';

  @override
  String get homeEmptyMessage =>
      'Las pistas encontradas en tu dispositivo aparecerán aquí.';

  @override
  String get goodMorningLabel => 'Buenos días';

  @override
  String get goodAfternoonLabel => 'Buenas tardes';

  @override
  String get goodEveningLabel => 'Buenas noches';

  @override
  String get homeWelcomeLabel => 'Hola de nuevo';

  @override
  String get searchTriggerHintLabel => 'Buscar en tu biblioteca';

  @override
  String get recentlyPlayedLabel => 'Reproducidas recientemente';

  @override
  String get libraryTotalDurationLabel => 'Tiempo total';

  @override
  String get storageLabel => 'Almacenamiento';
}
