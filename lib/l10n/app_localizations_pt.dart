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
  String get playlistsComingSoonMessage => 'Playlists are coming soon';

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
  String get playlistsComingSoonMessage => 'Playlists em breve';

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
}
