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

  @override
  String get unfavoriteButtonSemanticLabel => 'Remove from favorites';

  @override
  String get shuffleButtonSemanticLabel => 'Shuffle';

  @override
  String get previousTrackButtonSemanticLabel => 'Previous track';

  @override
  String get nextTrackButtonSemanticLabel => 'Next track';

  @override
  String get repeatButtonSemanticLabel => 'Repeat';

  @override
  String get moreOptionsButtonSemanticLabel => 'More options';

  @override
  String get viewQueueLabel => 'Queue';

  @override
  String get addToPlaylistLabel => 'Add to playlist';

  @override
  String get openLyricsLabel => 'Lyrics';

  @override
  String get sleepTimerLabel => 'Sleep timer';

  @override
  String get fileInfoLabel => 'File information';

  @override
  String get fileInfoDialogTitle => 'File information';

  @override
  String get fileInfoFormatLabel => 'Format';

  @override
  String get fileInfoSizeLabel => 'Size';

  @override
  String get fileInfoBitrateLabel => 'Bitrate';

  @override
  String get fileInfoSampleRateLabel => 'Sample rate';

  @override
  String get fileInfoPathLabel => 'Path';

  @override
  String get dialogDismissLabel => 'OK';

  @override
  String get sleepTimerSheetTitle => 'Sleep timer';

  @override
  String get sleepTimerSheetBody =>
      'Pause playback automatically after a set time.';

  @override
  String get sleepTimerEndOfTrackLabel => 'End of track';

  @override
  String get sleepTimerTurnOffLabel => 'Turn off timer';

  @override
  String get sleepTimerSetMessage => 'Sleep timer set';

  @override
  String get sleepTimerOffMessage => 'Sleep timer turned off';

  @override
  String get queueEmptyTitle => 'Queue is empty';

  @override
  String get queueEmptyMessage =>
      'Play a track from your library to fill the queue.';

  @override
  String get nowPlayingSemanticLabel => 'Now playing';

  @override
  String get queueEditLabel => 'Edit';

  @override
  String get queueDoneLabel => 'Done';

  @override
  String get removeFromQueueSemanticLabel => 'Remove from queue';

  @override
  String get dragToReorderSemanticLabel => 'Drag to reorder';

  @override
  String get clearQueueLabel => 'Clear queue';

  @override
  String get clearQueueConfirmTitle => 'Clear queue?';

  @override
  String get clearQueueConfirmMessage =>
      'This removes every track from the queue and stops playback.';

  @override
  String get clearQueueConfirmAction => 'Clear';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get lyricsEmptyTitle => 'No lyrics found';

  @override
  String get lyricsEmptyMessage =>
      'This track has no embedded lyrics or matching .lrc file.';

  @override
  String get libraryTracksTab => 'Tracks';

  @override
  String get libraryAlbumsTab => 'Albums';

  @override
  String get libraryArtistsTab => 'Artists';

  @override
  String get libraryPlaylistsTab => 'Playlists';

  @override
  String get libraryFavoritesTab => 'Favorites';

  @override
  String get sortByTitleLabel => 'Title';

  @override
  String get sortByArtistLabel => 'Artist';

  @override
  String get sortByDateAddedLabel => 'Date added';

  @override
  String get sortByDurationLabel => 'Duration';

  @override
  String get sortSheetTitle => 'Sort by';

  @override
  String get tracksEmptyTitle => 'No tracks yet';

  @override
  String get tracksEmptyMessage =>
      'Tracks found on your device will show up here.';

  @override
  String get playLabel => 'Play';

  @override
  String trackCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tracks',
      one: '$count track',
    );
    return '$_temp0';
  }

  @override
  String get albumsEmptyTitle => 'No albums yet';

  @override
  String get albumsEmptyMessage =>
      'Albums found on your device will show up here.';

  @override
  String get albumNotFoundTitle => 'Album not found';

  @override
  String get albumNotFoundMessage =>
      'This album may have been removed from your library.';

  @override
  String get artistsEmptyTitle => 'No artists yet';

  @override
  String get artistsEmptyMessage =>
      'Artists found on your device will show up here.';

  @override
  String get artistNotFoundTitle => 'Artist not found';

  @override
  String get artistNotFoundMessage =>
      'This artist may have been removed from your library.';

  @override
  String albumCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count albums',
      one: '$count album',
    );
    return '$_temp0';
  }

  @override
  String get favoritesEmptyTitle => 'No favorites yet';

  @override
  String get favoritesEmptyMessage => 'Tracks you favorite will show up here.';

  @override
  String get newPlaylistLabel => 'New playlist';

  @override
  String get playlistNameHint => 'Playlist name';

  @override
  String get createLabel => 'Create';

  @override
  String get saveLabel => 'Save';

  @override
  String get renamePlaylistSheetTitle => 'Rename playlist';

  @override
  String get renamePlaylistLabel => 'Rename';

  @override
  String get duplicatePlaylistLabel => 'Duplicate';

  @override
  String get deletePlaylistLabel => 'Delete';

  @override
  String get deletePlaylistConfirmTitle => 'Delete playlist?';

  @override
  String get deletePlaylistConfirmMessage =>
      'This removes the playlist. Its tracks stay in your library.';

  @override
  String get playlistOptionsSemanticLabel => 'Playlist options';

  @override
  String get playlistsEmptyTitle => 'No playlists yet';

  @override
  String get playlistsEmptyMessage =>
      'Tap New playlist to create your first one.';

  @override
  String playlistCopyName(String name) {
    return '$name copy';
  }

  @override
  String get addedToPlaylistMessage => 'Added to playlist';

  @override
  String get trackAlreadyInPlaylistMessage => 'Already in this playlist';

  @override
  String get removeFromPlaylistSemanticLabel => 'Remove from playlist';

  @override
  String get removeTrackConfirmTitle => 'Remove track?';

  @override
  String get removeTrackConfirmMessage =>
      'This removes it from the playlist. It stays in your library.';

  @override
  String get playlistEmptyTitle => 'This playlist is empty';

  @override
  String get playlistEmptyMessage => 'Add tracks from a track\'s more menu.';

  @override
  String get homeEmptyTitle => 'Your library is empty';

  @override
  String get homeEmptyMessage =>
      'Tracks found on your device will show up here.';

  @override
  String get goodMorningLabel => 'Good morning';

  @override
  String get goodAfternoonLabel => 'Good afternoon';

  @override
  String get goodEveningLabel => 'Good evening';

  @override
  String get homeWelcomeLabel => 'Welcome back';

  @override
  String get searchTriggerHintLabel => 'Search your library';

  @override
  String get recentlyPlayedLabel => 'Recently played';

  @override
  String get libraryTotalDurationLabel => 'Total time';

  @override
  String get storageLabel => 'Storage';

  @override
  String get clearSearchSemanticLabel => 'Clear search';

  @override
  String get searchResultsEmptyTitle => 'No results found';

  @override
  String get searchResultsEmptyMessage => 'Try a different search term.';

  @override
  String get recentSearchesLabel => 'Recent searches';

  @override
  String get clearSearchHistoryLabel => 'Clear';

  @override
  String get clearSearchHistoryConfirmTitle => 'Clear search history?';

  @override
  String get clearSearchHistoryConfirmMessage =>
      'This removes all of your recent searches.';

  @override
  String get clearSearchHistoryConfirmAction => 'Clear';

  @override
  String get removeSearchTermSemanticLabel => 'Remove from history';

  @override
  String get statisticsLabel => 'Statistics';

  @override
  String get periodWeekLabel => 'Week';

  @override
  String get periodMonthLabel => 'Month';

  @override
  String get periodYearLabel => 'Year';

  @override
  String get periodAllTimeLabel => 'All time';

  @override
  String get totalListenedLabel => 'Time listened';

  @override
  String get currentStreakLabel => 'Current streak';

  @override
  String get longestStreakLabel => 'Longest streak';

  @override
  String dayCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
    );
    return '$_temp0';
  }

  @override
  String playCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plays',
      one: '$count play',
    );
    return '$_temp0';
  }

  @override
  String get dailyActivityLabel => 'Daily activity';

  @override
  String get hourlyActivityLabel => 'Activity by hour';

  @override
  String get mostPlayedTracksLabel => 'Most played tracks';

  @override
  String get mostPlayedArtistsLabel => 'Most played artists';

  @override
  String get statisticsEmptyTitle => 'Nothing to show yet';

  @override
  String get statisticsEmptyMessage =>
      'Play some music and your stats will show up here.';

  @override
  String get clearHistoryLabel => 'Clear history';

  @override
  String get clearHistoryConfirmTitle => 'Clear listening history?';

  @override
  String get clearHistoryConfirmMessage =>
      'This resets recently played and every statistic derived from it. Your library isn\'t affected.';

  @override
  String get clearHistoryConfirmAction => 'Clear';

  @override
  String get storageTotalUsedLabel => 'Space used';

  @override
  String get storageFoldersLabel => 'Folders';

  @override
  String get includeInScanSemanticLabel => 'Include in scan';

  @override
  String get clearArtworkCacheLabel => 'Clear artwork cache';

  @override
  String get clearArtworkCacheConfirmTitle => 'Clear artwork cache?';

  @override
  String get clearArtworkCacheConfirmMessage =>
      'This deletes cached album art. It\'s re-extracted the next time you scan your library.';

  @override
  String get clearArtworkCacheConfirmAction => 'Clear';

  @override
  String get artworkCacheClearedMessage => 'Artwork cache cleared';

  @override
  String get deleteFileSemanticLabel => 'Delete file';

  @override
  String get deleteFileConfirmTitle => 'Delete this file?';

  @override
  String get deleteFileConfirmMessage =>
      'This permanently removes it from your device, along with any playlist entries and favorite. It can\'t be undone.';

  @override
  String get deleteFileConfirmAction => 'Delete';

  @override
  String get fileDeletedMessage => 'File deleted';

  @override
  String get fileDeleteFailedMessage => 'Couldn\'t delete this file';

  @override
  String get settingsSectionProfileLabel => 'Profile';

  @override
  String get settingsSectionAppearanceLabel => 'Appearance';

  @override
  String get settingsSectionPlaybackLabel => 'Playback';

  @override
  String get settingsSectionLibraryLabel => 'Library';

  @override
  String get settingsSectionAboutLabel => 'About';

  @override
  String get settingsNameLabel => 'Name';

  @override
  String get settingsNameNotSetValue => 'Not set';

  @override
  String get settingsLanguageLabel => 'Language';

  @override
  String get settingsLanguageSystemValue => 'System default';

  @override
  String get settingsPlaybackRowLabel => 'Gapless, crossfade & speed';

  @override
  String get settingsAboutLabel => 'About';

  @override
  String get settingsAboutRowLabel => 'App info & version';

  @override
  String get settingsEditNameSheetTitle => 'Your name';

  @override
  String get settingsNameHint => 'Enter your name';

  @override
  String get settingsThemeLabel => 'Theme';

  @override
  String get themeSystemLabel => 'System';

  @override
  String get themeLightLabel => 'Light';

  @override
  String get themeDarkLabel => 'Dark';

  @override
  String get settingsGaplessLabel => 'Gapless playback';

  @override
  String get settingsCrossfadeLabel => 'Crossfade';

  @override
  String get crossfadeOffValue => 'Off';

  @override
  String get settingsDefaultSpeedLabel => 'Default speed';

  @override
  String get settingsHapticsLabel => 'Haptic feedback';

  @override
  String get settingsRescanLabel => 'Rescan library';

  @override
  String get rescanCompleteMessage => 'Library rescanned';

  @override
  String get settingsReplayOnboardingLabel => 'Show onboarding again';

  @override
  String settingsVersionValue(String version, String buildNumber) {
    return 'Version $version ($buildNumber)';
  }

  @override
  String get settingsLicenseLabel => 'License (MIT)';
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

  @override
  String get permissionTitle => 'Acesse sua música';

  @override
  String get permissionMessage =>
      'O Music App precisa acessar os arquivos de áudio do seu aparelho para encontrar e tocar sua biblioteca. Nada sai do seu aparelho.';

  @override
  String get permissionGrant => 'Permitir acesso';

  @override
  String get permissionOpenSettings => 'Abrir configurações';

  @override
  String get permissionScanning => 'Escaneando sua biblioteca…';

  @override
  String get backButtonSemanticLabel => 'Voltar';

  @override
  String get playbackEmptyTitle => 'Nada tocando';

  @override
  String get playbackEmptyMessage =>
      'Toque uma faixa da sua biblioteca para vê-la aqui.';

  @override
  String get favoriteButtonSemanticLabel => 'Adicionar aos favoritos';

  @override
  String get unfavoriteButtonSemanticLabel => 'Remover dos favoritos';

  @override
  String get shuffleButtonSemanticLabel => 'Aleatório';

  @override
  String get previousTrackButtonSemanticLabel => 'Faixa anterior';

  @override
  String get nextTrackButtonSemanticLabel => 'Próxima faixa';

  @override
  String get repeatButtonSemanticLabel => 'Repetir';

  @override
  String get moreOptionsButtonSemanticLabel => 'Mais opções';

  @override
  String get viewQueueLabel => 'Fila';

  @override
  String get addToPlaylistLabel => 'Adicionar à playlist';

  @override
  String get openLyricsLabel => 'Letra';

  @override
  String get sleepTimerLabel => 'Temporizador';

  @override
  String get fileInfoLabel => 'Informações do arquivo';

  @override
  String get fileInfoDialogTitle => 'Informações do arquivo';

  @override
  String get fileInfoFormatLabel => 'Formato';

  @override
  String get fileInfoSizeLabel => 'Tamanho';

  @override
  String get fileInfoBitrateLabel => 'Taxa de bits';

  @override
  String get fileInfoSampleRateLabel => 'Taxa de amostragem';

  @override
  String get fileInfoPathLabel => 'Caminho';

  @override
  String get dialogDismissLabel => 'OK';

  @override
  String get sleepTimerSheetTitle => 'Temporizador de desligamento';

  @override
  String get sleepTimerSheetBody =>
      'Pausa a reprodução automaticamente após um tempo definido.';

  @override
  String get sleepTimerEndOfTrackLabel => 'Fim da faixa';

  @override
  String get sleepTimerTurnOffLabel => 'Desligar temporizador';

  @override
  String get sleepTimerSetMessage => 'Temporizador definido';

  @override
  String get sleepTimerOffMessage => 'Temporizador desligado';

  @override
  String get queueEmptyTitle => 'Fila vazia';

  @override
  String get queueEmptyMessage =>
      'Toque uma faixa da sua biblioteca para preencher a fila.';

  @override
  String get nowPlayingSemanticLabel => 'Tocando agora';

  @override
  String get queueEditLabel => 'Editar';

  @override
  String get queueDoneLabel => 'Concluir';

  @override
  String get removeFromQueueSemanticLabel => 'Remover da fila';

  @override
  String get dragToReorderSemanticLabel => 'Arraste para reordenar';

  @override
  String get clearQueueLabel => 'Limpar fila';

  @override
  String get clearQueueConfirmTitle => 'Limpar fila?';

  @override
  String get clearQueueConfirmMessage =>
      'Isso remove todas as faixas da fila e interrompe a reprodução.';

  @override
  String get clearQueueConfirmAction => 'Limpar';

  @override
  String get cancelLabel => 'Cancelar';

  @override
  String get lyricsEmptyTitle => 'Nenhuma letra encontrada';

  @override
  String get lyricsEmptyMessage =>
      'Esta faixa não tem letra embutida nem arquivo .lrc correspondente.';

  @override
  String get libraryTracksTab => 'Faixas';

  @override
  String get libraryAlbumsTab => 'Álbuns';

  @override
  String get libraryArtistsTab => 'Artistas';

  @override
  String get libraryPlaylistsTab => 'Playlists';

  @override
  String get libraryFavoritesTab => 'Favoritos';

  @override
  String get sortByTitleLabel => 'Título';

  @override
  String get sortByArtistLabel => 'Artista';

  @override
  String get sortByDateAddedLabel => 'Data de adição';

  @override
  String get sortByDurationLabel => 'Duração';

  @override
  String get sortSheetTitle => 'Ordenar por';

  @override
  String get tracksEmptyTitle => 'Nenhuma faixa ainda';

  @override
  String get tracksEmptyMessage =>
      'As faixas encontradas no seu dispositivo vão aparecer aqui.';

  @override
  String get playLabel => 'Reproduzir';

  @override
  String trackCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count faixas',
      one: '$count faixa',
    );
    return '$_temp0';
  }

  @override
  String get albumsEmptyTitle => 'Nenhum álbum ainda';

  @override
  String get albumsEmptyMessage =>
      'Os álbuns encontrados no seu dispositivo vão aparecer aqui.';

  @override
  String get albumNotFoundTitle => 'Álbum não encontrado';

  @override
  String get albumNotFoundMessage =>
      'Este álbum pode ter sido removido da sua biblioteca.';

  @override
  String get artistsEmptyTitle => 'Nenhum artista ainda';

  @override
  String get artistsEmptyMessage =>
      'Os artistas encontrados no seu dispositivo vão aparecer aqui.';

  @override
  String get artistNotFoundTitle => 'Artista não encontrado';

  @override
  String get artistNotFoundMessage =>
      'Este artista pode ter sido removido da sua biblioteca.';

  @override
  String albumCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count álbuns',
      one: '$count álbum',
    );
    return '$_temp0';
  }

  @override
  String get favoritesEmptyTitle => 'Nenhum favorito ainda';

  @override
  String get favoritesEmptyMessage =>
      'As faixas que você favoritar vão aparecer aqui.';

  @override
  String get newPlaylistLabel => 'Nova playlist';

  @override
  String get playlistNameHint => 'Nome da playlist';

  @override
  String get createLabel => 'Criar';

  @override
  String get saveLabel => 'Salvar';

  @override
  String get renamePlaylistSheetTitle => 'Renomear playlist';

  @override
  String get renamePlaylistLabel => 'Renomear';

  @override
  String get duplicatePlaylistLabel => 'Duplicar';

  @override
  String get deletePlaylistLabel => 'Excluir';

  @override
  String get deletePlaylistConfirmTitle => 'Excluir playlist?';

  @override
  String get deletePlaylistConfirmMessage =>
      'Isso remove a playlist. As faixas continuam na sua biblioteca.';

  @override
  String get playlistOptionsSemanticLabel => 'Opções da playlist';

  @override
  String get playlistsEmptyTitle => 'Nenhuma playlist ainda';

  @override
  String get playlistsEmptyMessage =>
      'Toque em Nova playlist para criar a primeira.';

  @override
  String playlistCopyName(String name) {
    return '$name cópia';
  }

  @override
  String get addedToPlaylistMessage => 'Adicionada à playlist';

  @override
  String get trackAlreadyInPlaylistMessage => 'Já está nessa playlist';

  @override
  String get removeFromPlaylistSemanticLabel => 'Remover da playlist';

  @override
  String get removeTrackConfirmTitle => 'Remover faixa?';

  @override
  String get removeTrackConfirmMessage =>
      'Isso remove a faixa da playlist. Ela continua na sua biblioteca.';

  @override
  String get playlistEmptyTitle => 'Esta playlist está vazia';

  @override
  String get playlistEmptyMessage =>
      'Adicione faixas pelo menu \"mais\" de uma faixa.';

  @override
  String get homeEmptyTitle => 'Sua biblioteca está vazia';

  @override
  String get homeEmptyMessage =>
      'As faixas encontradas no seu dispositivo vão aparecer aqui.';

  @override
  String get goodMorningLabel => 'Bom dia';

  @override
  String get goodAfternoonLabel => 'Boa tarde';

  @override
  String get goodEveningLabel => 'Boa noite';

  @override
  String get homeWelcomeLabel => 'Bem-vindo de volta';

  @override
  String get searchTriggerHintLabel => 'Buscar na sua biblioteca';

  @override
  String get recentlyPlayedLabel => 'Tocadas recentemente';

  @override
  String get libraryTotalDurationLabel => 'Tempo total';

  @override
  String get storageLabel => 'Armazenamento';

  @override
  String get clearSearchSemanticLabel => 'Limpar busca';

  @override
  String get searchResultsEmptyTitle => 'Nenhum resultado encontrado';

  @override
  String get searchResultsEmptyMessage => 'Tente outro termo de busca.';

  @override
  String get recentSearchesLabel => 'Buscas recentes';

  @override
  String get clearSearchHistoryLabel => 'Limpar';

  @override
  String get clearSearchHistoryConfirmTitle => 'Limpar histórico de busca?';

  @override
  String get clearSearchHistoryConfirmMessage =>
      'Isso remove todas as suas buscas recentes.';

  @override
  String get clearSearchHistoryConfirmAction => 'Limpar';

  @override
  String get removeSearchTermSemanticLabel => 'Remover do histórico';

  @override
  String get statisticsLabel => 'Estatísticas';

  @override
  String get periodWeekLabel => 'Semana';

  @override
  String get periodMonthLabel => 'Mês';

  @override
  String get periodYearLabel => 'Ano';

  @override
  String get periodAllTimeLabel => 'Sempre';

  @override
  String get totalListenedLabel => 'Tempo ouvido';

  @override
  String get currentStreakLabel => 'Sequência atual';

  @override
  String get longestStreakLabel => 'Maior sequência';

  @override
  String dayCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '$count dia',
    );
    return '$_temp0';
  }

  @override
  String playCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reproduções',
      one: '$count reprodução',
    );
    return '$_temp0';
  }

  @override
  String get dailyActivityLabel => 'Atividade diária';

  @override
  String get hourlyActivityLabel => 'Atividade por hora';

  @override
  String get mostPlayedTracksLabel => 'Faixas mais tocadas';

  @override
  String get mostPlayedArtistsLabel => 'Artistas mais tocados';

  @override
  String get statisticsEmptyTitle => 'Nada para mostrar ainda';

  @override
  String get statisticsEmptyMessage =>
      'Ouça música e suas estatísticas vão aparecer aqui.';

  @override
  String get clearHistoryLabel => 'Limpar histórico';

  @override
  String get clearHistoryConfirmTitle => 'Limpar histórico de reprodução?';

  @override
  String get clearHistoryConfirmMessage =>
      'Isso reinicia as tocadas recentemente e todas as estatísticas derivadas dele. Sua biblioteca não é afetada.';

  @override
  String get clearHistoryConfirmAction => 'Limpar';

  @override
  String get storageTotalUsedLabel => 'Espaço usado';

  @override
  String get storageFoldersLabel => 'Pastas';

  @override
  String get includeInScanSemanticLabel => 'Incluir na varredura';

  @override
  String get clearArtworkCacheLabel => 'Limpar cache de capas';

  @override
  String get clearArtworkCacheConfirmTitle => 'Limpar cache de capas?';

  @override
  String get clearArtworkCacheConfirmMessage =>
      'Isso apaga as capas em cache. Elas serão extraídas novamente na próxima varredura da sua biblioteca.';

  @override
  String get clearArtworkCacheConfirmAction => 'Limpar';

  @override
  String get artworkCacheClearedMessage => 'Cache de capas limpo';

  @override
  String get deleteFileSemanticLabel => 'Excluir arquivo';

  @override
  String get deleteFileConfirmTitle => 'Excluir este arquivo?';

  @override
  String get deleteFileConfirmMessage =>
      'Isso o remove permanentemente do seu dispositivo, junto com entradas em playlists e favoritos. Não pode ser desfeito.';

  @override
  String get deleteFileConfirmAction => 'Excluir';

  @override
  String get fileDeletedMessage => 'Arquivo excluído';

  @override
  String get fileDeleteFailedMessage => 'Não foi possível excluir este arquivo';

  @override
  String get settingsSectionProfileLabel => 'Perfil';

  @override
  String get settingsSectionAppearanceLabel => 'Aparência';

  @override
  String get settingsSectionPlaybackLabel => 'Reprodução';

  @override
  String get settingsSectionLibraryLabel => 'Biblioteca';

  @override
  String get settingsSectionAboutLabel => 'Sobre';

  @override
  String get settingsNameLabel => 'Nome';

  @override
  String get settingsNameNotSetValue => 'Não definido';

  @override
  String get settingsLanguageLabel => 'Idioma';

  @override
  String get settingsLanguageSystemValue => 'Padrão do sistema';

  @override
  String get settingsPlaybackRowLabel =>
      'Sem intervalo, crossfade e velocidade';

  @override
  String get settingsAboutLabel => 'Sobre';

  @override
  String get settingsAboutRowLabel => 'Informações e versão do app';

  @override
  String get settingsEditNameSheetTitle => 'Seu nome';

  @override
  String get settingsNameHint => 'Digite seu nome';

  @override
  String get settingsThemeLabel => 'Tema';

  @override
  String get themeSystemLabel => 'Sistema';

  @override
  String get themeLightLabel => 'Claro';

  @override
  String get themeDarkLabel => 'Escuro';

  @override
  String get settingsGaplessLabel => 'Reprodução sem intervalo';

  @override
  String get settingsCrossfadeLabel => 'Crossfade';

  @override
  String get crossfadeOffValue => 'Desativado';

  @override
  String get settingsDefaultSpeedLabel => 'Velocidade padrão';

  @override
  String get settingsHapticsLabel => 'Feedback háptico';

  @override
  String get settingsRescanLabel => 'Refazer varredura da biblioteca';

  @override
  String get rescanCompleteMessage => 'Biblioteca atualizada';

  @override
  String get settingsReplayOnboardingLabel => 'Mostrar introdução novamente';

  @override
  String settingsVersionValue(String version, String buildNumber) {
    return 'Versão $version ($buildNumber)';
  }

  @override
  String get settingsLicenseLabel => 'Licença (MIT)';
}
