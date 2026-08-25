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
  String get scanErrorTitle => 'Error al escanear';

  @override
  String get scanErrorMessage =>
      'Algo salió mal al escanear tu biblioteca de música.';

  @override
  String get retryLabel => 'Intentar de nuevo';

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
  String get playButtonSemanticLabel => 'Reproducir';

  @override
  String get pauseButtonSemanticLabel => 'Pausar';

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
  String get storageEmptyTitle => 'Aún no hay carpetas';

  @override
  String get storageEmptyMessage =>
      'Una vez que se escanee tu biblioteca, sus carpetas aparecerán aquí para incluir o excluir.';

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
  String get editTagsLabel => 'Editar etiquetas';

  @override
  String get editTagsSheetTitle => 'Editar etiquetas';

  @override
  String get trackTitleHint => 'Título';

  @override
  String get trackArtistHint => 'Artista';

  @override
  String get trackAlbumHint => 'Álbum';

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
  String get playlistDescriptionHint => 'Descripción';

  @override
  String get reorderTracksLabel => 'Reordenar canciones';

  @override
  String get removeFromPlaylistLabel => 'Quitar de la playlist';

  @override
  String get searchTracksSemanticLabel => 'Buscar canciones';

  @override
  String get sortByPlaylistOrderLabel => 'Orden de la playlist';

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

  @override
  String get clearSearchSemanticLabel => 'Borrar búsqueda';

  @override
  String get searchResultsEmptyTitle => 'No se encontraron resultados';

  @override
  String get searchResultsEmptyMessage =>
      'Prueba con otro término de búsqueda.';

  @override
  String get recentSearchesLabel => 'Búsquedas recientes';

  @override
  String get clearSearchHistoryLabel => 'Borrar';

  @override
  String get clearSearchHistoryConfirmTitle => '¿Borrar historial de búsqueda?';

  @override
  String get clearSearchHistoryConfirmMessage =>
      'Esto elimina todas tus búsquedas recientes.';

  @override
  String get clearSearchHistoryConfirmAction => 'Borrar';

  @override
  String get removeSearchTermSemanticLabel => 'Eliminar del historial';

  @override
  String get statisticsLabel => 'Estadísticas';

  @override
  String get periodWeekLabel => 'Semana';

  @override
  String get periodMonthLabel => 'Mes';

  @override
  String get periodYearLabel => 'Año';

  @override
  String get periodAllTimeLabel => 'Siempre';

  @override
  String get totalListenedLabel => 'Tiempo escuchado';

  @override
  String get currentStreakLabel => 'Racha actual';

  @override
  String get longestStreakLabel => 'Racha más larga';

  @override
  String dayCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '$count día',
    );
    return '$_temp0';
  }

  @override
  String playCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reproducciones',
      one: '$count reproducción',
    );
    return '$_temp0';
  }

  @override
  String get dailyActivityLabel => 'Actividad diaria';

  @override
  String get hourlyActivityLabel => 'Actividad por hora';

  @override
  String get mostPlayedTracksLabel => 'Pistas más reproducidas';

  @override
  String get mostPlayedArtistsLabel => 'Artistas más reproducidos';

  @override
  String get statisticsEmptyTitle => 'Nada que mostrar todavía';

  @override
  String get statisticsEmptyMessage =>
      'Escucha música y tus estadísticas aparecerán aquí.';

  @override
  String get clearHistoryLabel => 'Borrar historial';

  @override
  String get clearHistoryConfirmTitle => '¿Borrar el historial de escucha?';

  @override
  String get clearHistoryConfirmMessage =>
      'Esto reinicia lo reproducido recientemente y todas las estadísticas derivadas de ello. Tu biblioteca no se ve afectada.';

  @override
  String get clearHistoryConfirmAction => 'Borrar';

  @override
  String get storageTotalUsedLabel => 'Espacio usado';

  @override
  String get storageFoldersLabel => 'Carpetas';

  @override
  String get includeInScanSemanticLabel => 'Incluir en el escaneo';

  @override
  String get clearArtworkCacheLabel => 'Borrar caché de carátulas';

  @override
  String get clearArtworkCacheConfirmTitle => '¿Borrar la caché de carátulas?';

  @override
  String get clearArtworkCacheConfirmMessage =>
      'Esto elimina las carátulas guardadas en caché. Se volverán a extraer la próxima vez que escanees tu biblioteca.';

  @override
  String get clearArtworkCacheConfirmAction => 'Borrar';

  @override
  String get artworkCacheClearedMessage => 'Caché de carátulas borrada';

  @override
  String get backupSectionLabel => 'Copia de seguridad';

  @override
  String get exportBackupLabel => 'Exportar copia de seguridad';

  @override
  String get importBackupLabel => 'Restaurar copia de seguridad';

  @override
  String get backupExportedMessage => 'Copia de seguridad guardada';

  @override
  String get backupExportFailedMessage =>
      'No se pudo crear la copia de seguridad';

  @override
  String get backupImportedMessage => 'Copia de seguridad restaurada';

  @override
  String backupImportedWithSkippedTracksMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Copia de seguridad restaurada. No se encontraron $count canciones — vuelve a escanear tu biblioteca e inténtalo de nuevo.',
      one:
          'Copia de seguridad restaurada. No se encontró $count canción — vuelve a escanear tu biblioteca e inténtalo de nuevo.',
    );
    return '$_temp0';
  }

  @override
  String get backupImportFailedMessage =>
      'No se pudo restaurar esta copia de seguridad. Asegúrate de que el archivo sea una copia de seguridad válida.';

  @override
  String get backupUnsupportedFormatMessage =>
      'Esta copia de seguridad se creó con otra versión de la app y no se puede restaurar.';

  @override
  String get databaseBackupSectionLabel => 'Copia completa de la base de datos';

  @override
  String get exportDatabaseBackupLabel => 'Exportar base de datos';

  @override
  String get importDatabaseBackupLabel => 'Restaurar base de datos';

  @override
  String get restoreDatabaseConfirmTitle => '¿Restaurar base de datos?';

  @override
  String get restoreDatabaseConfirmMessage =>
      'Esto reemplaza toda tu biblioteca, listas, favoritos e historial con el contenido de la copia y reinicia la app. No se puede deshacer.';

  @override
  String get restoreLabel => 'Restaurar';

  @override
  String get databaseBackupExportedMessage =>
      'Copia de la base de datos guardada';

  @override
  String get databaseBackupExportFailedMessage =>
      'No se pudo crear la copia de la base de datos';

  @override
  String get invalidDatabaseBackupMessage =>
      'Este archivo no es una copia de la base de datos.';

  @override
  String get databaseBackupImportFailedMessage =>
      'No se pudo restaurar esta copia de la base de datos.';

  @override
  String get deleteFileSemanticLabel => 'Eliminar archivo';

  @override
  String get deleteFileConfirmTitle => '¿Eliminar este archivo?';

  @override
  String get deleteFileConfirmMessage =>
      'Esto lo elimina permanentemente de tu dispositivo, junto con cualquier entrada en listas de reproducción y favoritos. No se puede deshacer.';

  @override
  String get deleteFileConfirmAction => 'Eliminar';

  @override
  String get fileDeletedMessage => 'Archivo eliminado';

  @override
  String get fileDeleteFailedMessage => 'No se pudo eliminar este archivo';

  @override
  String get playbackErrorMessage => 'No se pudo reproducir esta pista';

  @override
  String get settingsSectionProfileLabel => 'Perfil';

  @override
  String get settingsSectionAppearanceLabel => 'Apariencia';

  @override
  String get settingsSectionPlaybackLabel => 'Reproducción';

  @override
  String get settingsSectionLibraryLabel => 'Biblioteca';

  @override
  String get settingsSectionAboutLabel => 'Acerca de';

  @override
  String get settingsNameLabel => 'Nombre';

  @override
  String get settingsNameNotSetValue => 'Sin definir';

  @override
  String get settingsLanguageLabel => 'Idioma';

  @override
  String get settingsLanguageSystemValue => 'Predeterminado del sistema';

  @override
  String get settingsPlaybackRowLabel => 'Sin intervalo, crossfade y velocidad';

  @override
  String get settingsAboutLabel => 'Acerca de';

  @override
  String get settingsAboutRowLabel => 'Información y versión de la app';

  @override
  String get settingsEditNameSheetTitle => 'Tu nombre';

  @override
  String get settingsNameHint => 'Escribe tu nombre';

  @override
  String get settingsThemeLabel => 'Tema';

  @override
  String get themeSystemLabel => 'Sistema';

  @override
  String get themeLightLabel => 'Claro';

  @override
  String get themeDarkLabel => 'Oscuro';

  @override
  String get settingsGaplessLabel => 'Reproducción sin intervalo';

  @override
  String get settingsCrossfadeLabel => 'Crossfade';

  @override
  String get crossfadeOffValue => 'Desactivado';

  @override
  String get settingsDefaultSpeedLabel => 'Velocidad predeterminada';

  @override
  String get settingsHapticsLabel => 'Retroalimentación háptica';

  @override
  String get settingsRescanLabel => 'Volver a escanear biblioteca';

  @override
  String get rescanCompleteMessage => 'Biblioteca actualizada';

  @override
  String get settingsReplayOnboardingLabel => 'Mostrar introducción de nuevo';

  @override
  String settingsVersionValue(String version, String buildNumber) {
    return 'Versión $version ($buildNumber)';
  }

  @override
  String get settingsLicenseLabel => 'Licencia (MIT)';
}
