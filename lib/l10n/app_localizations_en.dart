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
}
