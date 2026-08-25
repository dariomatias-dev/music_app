import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Music App'**
  String get appName;

  /// No description provided for @homeTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTabLabel;

  /// No description provided for @searchTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTabLabel;

  /// No description provided for @libraryTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryTabLabel;

  /// No description provided for @settingsTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTabLabel;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingStartListening.
  ///
  /// In en, this message translates to:
  /// **'Start listening'**
  String get onboardingStartListening;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Your music, on your device'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Body.
  ///
  /// In en, this message translates to:
  /// **'Your files, read straight from the device. No signal, no account, no waiting, and it works the same on a plane as it does at home.'**
  String get onboarding1Body;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Built for one hand'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Body.
  ///
  /// In en, this message translates to:
  /// **'The player stays within reach at the bottom of every screen. Swipe it sideways to skip, or up to open it full screen.'**
  String get onboarding2Body;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'It learns what you play'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Body.
  ///
  /// In en, this message translates to:
  /// **'Recently played and your listening stats come from what you actually listen to, and nothing is sent anywhere.'**
  String get onboarding3Body;

  /// No description provided for @permissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Access your music'**
  String get permissionTitle;

  /// No description provided for @permissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Music App needs access to your device\'s audio files to find and play your library. Nothing ever leaves your device.'**
  String get permissionMessage;

  /// No description provided for @permissionGrant.
  ///
  /// In en, this message translates to:
  /// **'Allow access'**
  String get permissionGrant;

  /// No description provided for @permissionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get permissionOpenSettings;

  /// No description provided for @permissionScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning your library…'**
  String get permissionScanning;

  /// No description provided for @permissionScanningFolderTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: you can exclude folders from your library anytime in Settings > Storage.'**
  String get permissionScanningFolderTip;

  /// No description provided for @scanErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan failed'**
  String get scanErrorTitle;

  /// No description provided for @scanErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while scanning your music library.'**
  String get scanErrorMessage;

  /// No description provided for @retryLabel.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retryLabel;

  /// No description provided for @backButtonSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButtonSemanticLabel;

  /// No description provided for @playbackEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing playing'**
  String get playbackEmptyTitle;

  /// No description provided for @playbackEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Play a track from your library to see it here.'**
  String get playbackEmptyMessage;

  /// No description provided for @favoriteButtonSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get favoriteButtonSemanticLabel;

  /// No description provided for @unfavoriteButtonSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get unfavoriteButtonSemanticLabel;

  /// No description provided for @shuffleButtonSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get shuffleButtonSemanticLabel;

  /// No description provided for @previousTrackButtonSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Previous track'**
  String get previousTrackButtonSemanticLabel;

  /// No description provided for @nextTrackButtonSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Next track'**
  String get nextTrackButtonSemanticLabel;

  /// No description provided for @playButtonSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playButtonSemanticLabel;

  /// No description provided for @pauseButtonSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseButtonSemanticLabel;

  /// No description provided for @repeatButtonSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeatButtonSemanticLabel;

  /// No description provided for @moreOptionsButtonSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptionsButtonSemanticLabel;

  /// No description provided for @viewQueueLabel.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get viewQueueLabel;

  /// No description provided for @addToPlaylistLabel.
  ///
  /// In en, this message translates to:
  /// **'Add to playlist'**
  String get addToPlaylistLabel;

  /// No description provided for @openLyricsLabel.
  ///
  /// In en, this message translates to:
  /// **'Lyrics'**
  String get openLyricsLabel;

  /// No description provided for @sleepTimerLabel.
  ///
  /// In en, this message translates to:
  /// **'Sleep timer'**
  String get sleepTimerLabel;

  /// No description provided for @fileInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'File information'**
  String get fileInfoLabel;

  /// No description provided for @fileInfoDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'File information'**
  String get fileInfoDialogTitle;

  /// No description provided for @fileInfoFormatLabel.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get fileInfoFormatLabel;

  /// No description provided for @fileInfoSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get fileInfoSizeLabel;

  /// No description provided for @fileInfoBitrateLabel.
  ///
  /// In en, this message translates to:
  /// **'Bitrate'**
  String get fileInfoBitrateLabel;

  /// No description provided for @fileInfoSampleRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Sample rate'**
  String get fileInfoSampleRateLabel;

  /// No description provided for @fileInfoPathLabel.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get fileInfoPathLabel;

  /// No description provided for @dialogDismissLabel.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get dialogDismissLabel;

  /// No description provided for @sleepTimerSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep timer'**
  String get sleepTimerSheetTitle;

  /// No description provided for @sleepTimerSheetBody.
  ///
  /// In en, this message translates to:
  /// **'Pause playback automatically after a set time.'**
  String get sleepTimerSheetBody;

  /// No description provided for @sleepTimerEndOfTrackLabel.
  ///
  /// In en, this message translates to:
  /// **'End of track'**
  String get sleepTimerEndOfTrackLabel;

  /// No description provided for @sleepTimerTurnOffLabel.
  ///
  /// In en, this message translates to:
  /// **'Turn off timer'**
  String get sleepTimerTurnOffLabel;

  /// No description provided for @sleepTimerSetMessage.
  ///
  /// In en, this message translates to:
  /// **'Sleep timer set'**
  String get sleepTimerSetMessage;

  /// No description provided for @sleepTimerOffMessage.
  ///
  /// In en, this message translates to:
  /// **'Sleep timer turned off'**
  String get sleepTimerOffMessage;

  /// No description provided for @queueEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Queue is empty'**
  String get queueEmptyTitle;

  /// No description provided for @queueEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Play a track from your library to fill the queue.'**
  String get queueEmptyMessage;

  /// No description provided for @nowPlayingSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Now playing'**
  String get nowPlayingSemanticLabel;

  /// No description provided for @queueEditLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get queueEditLabel;

  /// No description provided for @queueDoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get queueDoneLabel;

  /// No description provided for @removeFromQueueSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove from queue'**
  String get removeFromQueueSemanticLabel;

  /// No description provided for @dragToReorderSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get dragToReorderSemanticLabel;

  /// No description provided for @clearQueueLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear queue'**
  String get clearQueueLabel;

  /// No description provided for @clearQueueConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear queue?'**
  String get clearQueueConfirmTitle;

  /// No description provided for @clearQueueConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This removes every track from the queue and stops playback.'**
  String get clearQueueConfirmMessage;

  /// No description provided for @clearQueueConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearQueueConfirmAction;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @lyricsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No lyrics found'**
  String get lyricsEmptyTitle;

  /// No description provided for @lyricsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'This track has no embedded lyrics or matching .lrc file.'**
  String get lyricsEmptyMessage;

  /// No description provided for @libraryTracksTab.
  ///
  /// In en, this message translates to:
  /// **'Tracks'**
  String get libraryTracksTab;

  /// No description provided for @libraryAlbumsTab.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get libraryAlbumsTab;

  /// No description provided for @libraryArtistsTab.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get libraryArtistsTab;

  /// No description provided for @libraryPlaylistsTab.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get libraryPlaylistsTab;

  /// No description provided for @libraryFavoritesTab.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get libraryFavoritesTab;

  /// No description provided for @sortByTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get sortByTitleLabel;

  /// No description provided for @sortByArtistLabel.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get sortByArtistLabel;

  /// No description provided for @sortByDateAddedLabel.
  ///
  /// In en, this message translates to:
  /// **'Date added'**
  String get sortByDateAddedLabel;

  /// No description provided for @sortByDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get sortByDurationLabel;

  /// No description provided for @sortSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortSheetTitle;

  /// No description provided for @tracksEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No tracks yet'**
  String get tracksEmptyTitle;

  /// No description provided for @tracksEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Tracks found on your device will show up here.'**
  String get tracksEmptyMessage;

  /// No description provided for @storageEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No folders yet'**
  String get storageEmptyTitle;

  /// No description provided for @storageEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Once your library is scanned, its folders will show up here to include or exclude.'**
  String get storageEmptyMessage;

  /// No description provided for @playLabel.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playLabel;

  /// No description provided for @trackCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} track} other{{count} tracks}}'**
  String trackCountLabel(int count);

  /// No description provided for @albumsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No albums yet'**
  String get albumsEmptyTitle;

  /// No description provided for @albumsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Albums found on your device will show up here.'**
  String get albumsEmptyMessage;

  /// No description provided for @albumNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Album not found'**
  String get albumNotFoundTitle;

  /// No description provided for @albumNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'This album may have been removed from your library.'**
  String get albumNotFoundMessage;

  /// No description provided for @artistsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No artists yet'**
  String get artistsEmptyTitle;

  /// No description provided for @artistsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Artists found on your device will show up here.'**
  String get artistsEmptyMessage;

  /// No description provided for @artistNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Artist not found'**
  String get artistNotFoundTitle;

  /// No description provided for @artistNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'This artist may have been removed from your library.'**
  String get artistNotFoundMessage;

  /// No description provided for @albumCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} album} other{{count} albums}}'**
  String albumCountLabel(int count);

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Tracks you favorite will show up here.'**
  String get favoritesEmptyMessage;

  /// No description provided for @newPlaylistLabel.
  ///
  /// In en, this message translates to:
  /// **'New playlist'**
  String get newPlaylistLabel;

  /// No description provided for @playlistNameHint.
  ///
  /// In en, this message translates to:
  /// **'Playlist name'**
  String get playlistNameHint;

  /// No description provided for @createLabel.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createLabel;

  /// No description provided for @saveLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveLabel;

  /// No description provided for @renamePlaylistSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename playlist'**
  String get renamePlaylistSheetTitle;

  /// No description provided for @renamePlaylistLabel.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renamePlaylistLabel;

  /// No description provided for @editTagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit tags'**
  String get editTagsLabel;

  /// No description provided for @editTagsSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit tags'**
  String get editTagsSheetTitle;

  /// No description provided for @trackTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get trackTitleHint;

  /// No description provided for @trackArtistHint.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get trackArtistHint;

  /// No description provided for @trackAlbumHint.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get trackAlbumHint;

  /// No description provided for @duplicatePlaylistLabel.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicatePlaylistLabel;

  /// No description provided for @deletePlaylistLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deletePlaylistLabel;

  /// No description provided for @deletePlaylistConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete playlist?'**
  String get deletePlaylistConfirmTitle;

  /// No description provided for @deletePlaylistConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This removes the playlist. Its tracks stay in your library.'**
  String get deletePlaylistConfirmMessage;

  /// No description provided for @playlistOptionsSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Playlist options'**
  String get playlistOptionsSemanticLabel;

  /// No description provided for @playlistsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No playlists yet'**
  String get playlistsEmptyTitle;

  /// No description provided for @playlistsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap New playlist to create your first one.'**
  String get playlistsEmptyMessage;

  /// No description provided for @playlistCopyName.
  ///
  /// In en, this message translates to:
  /// **'{name} copy'**
  String playlistCopyName(String name);

  /// No description provided for @addedToPlaylistMessage.
  ///
  /// In en, this message translates to:
  /// **'Added to playlist'**
  String get addedToPlaylistMessage;

  /// No description provided for @trackAlreadyInPlaylistMessage.
  ///
  /// In en, this message translates to:
  /// **'Already in this playlist'**
  String get trackAlreadyInPlaylistMessage;

  /// No description provided for @removeFromPlaylistSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove from playlist'**
  String get removeFromPlaylistSemanticLabel;

  /// No description provided for @removeTrackConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove track?'**
  String get removeTrackConfirmTitle;

  /// No description provided for @removeTrackConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This removes it from the playlist. It stays in your library.'**
  String get removeTrackConfirmMessage;

  /// No description provided for @playlistEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'This playlist is empty'**
  String get playlistEmptyTitle;

  /// No description provided for @playlistEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add tracks from a track\'s more menu.'**
  String get playlistEmptyMessage;

  /// No description provided for @playlistDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get playlistDescriptionHint;

  /// No description provided for @reorderTracksLabel.
  ///
  /// In en, this message translates to:
  /// **'Reorder tracks'**
  String get reorderTracksLabel;

  /// No description provided for @removeFromPlaylistLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove from playlist'**
  String get removeFromPlaylistLabel;

  /// No description provided for @searchTracksSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Search tracks'**
  String get searchTracksSemanticLabel;

  /// No description provided for @sortByPlaylistOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Playlist order'**
  String get sortByPlaylistOrderLabel;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your library is empty'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Tracks found on your device will show up here.'**
  String get homeEmptyMessage;

  /// No description provided for @goodMorningLabel.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorningLabel;

  /// No description provided for @goodAfternoonLabel.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoonLabel;

  /// No description provided for @goodEveningLabel.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEveningLabel;

  /// No description provided for @homeWelcomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get homeWelcomeLabel;

  /// No description provided for @searchTriggerHintLabel.
  ///
  /// In en, this message translates to:
  /// **'Search your library'**
  String get searchTriggerHintLabel;

  /// No description provided for @recentlyPlayedLabel.
  ///
  /// In en, this message translates to:
  /// **'Recently played'**
  String get recentlyPlayedLabel;

  /// No description provided for @libraryTotalDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Total time'**
  String get libraryTotalDurationLabel;

  /// No description provided for @storageLabel.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storageLabel;

  /// No description provided for @clearSearchSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearchSemanticLabel;

  /// No description provided for @searchResultsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get searchResultsEmptyTitle;

  /// No description provided for @searchResultsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term.'**
  String get searchResultsEmptyMessage;

  /// No description provided for @recentSearchesLabel.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recentSearchesLabel;

  /// No description provided for @clearSearchHistoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearSearchHistoryLabel;

  /// No description provided for @clearSearchHistoryConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear search history?'**
  String get clearSearchHistoryConfirmTitle;

  /// No description provided for @clearSearchHistoryConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This removes all of your recent searches.'**
  String get clearSearchHistoryConfirmMessage;

  /// No description provided for @clearSearchHistoryConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearSearchHistoryConfirmAction;

  /// No description provided for @removeSearchTermSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove from history'**
  String get removeSearchTermSemanticLabel;

  /// No description provided for @statisticsLabel.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsLabel;

  /// No description provided for @periodWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get periodWeekLabel;

  /// No description provided for @periodMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get periodMonthLabel;

  /// No description provided for @periodYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get periodYearLabel;

  /// No description provided for @periodAllTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get periodAllTimeLabel;

  /// No description provided for @totalListenedLabel.
  ///
  /// In en, this message translates to:
  /// **'Time listened'**
  String get totalListenedLabel;

  /// No description provided for @currentStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get currentStreakLabel;

  /// No description provided for @longestStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Longest streak'**
  String get longestStreakLabel;

  /// No description provided for @dayCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} day} other{{count} days}}'**
  String dayCountLabel(int count);

  /// No description provided for @playCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} play} other{{count} plays}}'**
  String playCountLabel(int count);

  /// No description provided for @dailyActivityLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily activity'**
  String get dailyActivityLabel;

  /// No description provided for @hourlyActivityLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity by hour'**
  String get hourlyActivityLabel;

  /// No description provided for @mostPlayedTracksLabel.
  ///
  /// In en, this message translates to:
  /// **'Most played tracks'**
  String get mostPlayedTracksLabel;

  /// No description provided for @mostPlayedArtistsLabel.
  ///
  /// In en, this message translates to:
  /// **'Most played artists'**
  String get mostPlayedArtistsLabel;

  /// No description provided for @statisticsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show yet'**
  String get statisticsEmptyTitle;

  /// No description provided for @statisticsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Play some music and your stats will show up here.'**
  String get statisticsEmptyMessage;

  /// No description provided for @clearHistoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get clearHistoryLabel;

  /// No description provided for @clearHistoryConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear listening history?'**
  String get clearHistoryConfirmTitle;

  /// No description provided for @clearHistoryConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This resets recently played and every statistic derived from it. Your library isn\'t affected.'**
  String get clearHistoryConfirmMessage;

  /// No description provided for @clearHistoryConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearHistoryConfirmAction;

  /// No description provided for @storageTotalUsedLabel.
  ///
  /// In en, this message translates to:
  /// **'Space used'**
  String get storageTotalUsedLabel;

  /// No description provided for @storageFoldersLabel.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get storageFoldersLabel;

  /// No description provided for @includeInScanSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Include in scan'**
  String get includeInScanSemanticLabel;

  /// No description provided for @clearArtworkCacheLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear artwork cache'**
  String get clearArtworkCacheLabel;

  /// No description provided for @clearArtworkCacheConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear artwork cache?'**
  String get clearArtworkCacheConfirmTitle;

  /// No description provided for @clearArtworkCacheConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This deletes cached album art. It\'s re-extracted the next time you scan your library.'**
  String get clearArtworkCacheConfirmMessage;

  /// No description provided for @clearArtworkCacheConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearArtworkCacheConfirmAction;

  /// No description provided for @artworkCacheClearedMessage.
  ///
  /// In en, this message translates to:
  /// **'Artwork cache cleared'**
  String get artworkCacheClearedMessage;

  /// No description provided for @backupSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backupSectionLabel;

  /// No description provided for @exportBackupLabel.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get exportBackupLabel;

  /// No description provided for @importBackupLabel.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get importBackupLabel;

  /// No description provided for @backupExportedMessage.
  ///
  /// In en, this message translates to:
  /// **'Backup saved'**
  String get backupExportedMessage;

  /// No description provided for @backupExportFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the backup'**
  String get backupExportFailedMessage;

  /// No description provided for @backupImportedMessage.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get backupImportedMessage;

  /// No description provided for @backupImportedWithSkippedTracksMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Backup restored. {count} track wasn\'t found — rescan your library and try again.} other{Backup restored. {count} tracks weren\'t found — rescan your library and try again.}}'**
  String backupImportedWithSkippedTracksMessage(int count);

  /// No description provided for @backupImportFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t restore this backup. Make sure the file is a valid backup.'**
  String get backupImportFailedMessage;

  /// No description provided for @backupUnsupportedFormatMessage.
  ///
  /// In en, this message translates to:
  /// **'This backup was made with a different app version and can\'t be restored.'**
  String get backupUnsupportedFormatMessage;

  /// No description provided for @databaseBackupSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Full database backup'**
  String get databaseBackupSectionLabel;

  /// No description provided for @exportDatabaseBackupLabel.
  ///
  /// In en, this message translates to:
  /// **'Export database'**
  String get exportDatabaseBackupLabel;

  /// No description provided for @importDatabaseBackupLabel.
  ///
  /// In en, this message translates to:
  /// **'Restore database'**
  String get importDatabaseBackupLabel;

  /// No description provided for @restoreDatabaseConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore database?'**
  String get restoreDatabaseConfirmTitle;

  /// No description provided for @restoreDatabaseConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This replaces your entire library, playlists, favorites and history with the backup\'s contents, then restarts the app. This can\'t be undone.'**
  String get restoreDatabaseConfirmMessage;

  /// No description provided for @restoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreLabel;

  /// No description provided for @databaseBackupExportedMessage.
  ///
  /// In en, this message translates to:
  /// **'Database backup saved'**
  String get databaseBackupExportedMessage;

  /// No description provided for @databaseBackupExportFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the database backup'**
  String get databaseBackupExportFailedMessage;

  /// No description provided for @invalidDatabaseBackupMessage.
  ///
  /// In en, this message translates to:
  /// **'This file isn\'t a database backup.'**
  String get invalidDatabaseBackupMessage;

  /// No description provided for @databaseBackupImportFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t restore this database backup.'**
  String get databaseBackupImportFailedMessage;

  /// No description provided for @deleteFileSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete file'**
  String get deleteFileSemanticLabel;

  /// No description provided for @deleteFileConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this file?'**
  String get deleteFileConfirmTitle;

  /// No description provided for @deleteFileConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes it from your device, along with any playlist entries and favorite. It can\'t be undone.'**
  String get deleteFileConfirmMessage;

  /// No description provided for @deleteFileConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteFileConfirmAction;

  /// No description provided for @fileDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'File deleted'**
  String get fileDeletedMessage;

  /// No description provided for @fileDeleteFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete this file'**
  String get fileDeleteFailedMessage;

  /// No description provided for @playbackErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t play this track'**
  String get playbackErrorMessage;

  /// No description provided for @settingsSectionProfileLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settingsSectionProfileLabel;

  /// No description provided for @settingsSectionAppearanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearanceLabel;

  /// No description provided for @settingsSectionPlaybackLabel.
  ///
  /// In en, this message translates to:
  /// **'Playback'**
  String get settingsSectionPlaybackLabel;

  /// No description provided for @settingsSectionLibraryLabel.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get settingsSectionLibraryLabel;

  /// No description provided for @settingsSectionAboutLabel.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAboutLabel;

  /// No description provided for @settingsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get settingsNameLabel;

  /// No description provided for @settingsNameNotSetValue.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get settingsNameNotSetValue;

  /// No description provided for @settingsLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageLabel;

  /// No description provided for @settingsLanguageSystemValue.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystemValue;

  /// No description provided for @settingsPlaybackRowLabel.
  ///
  /// In en, this message translates to:
  /// **'Gapless, crossfade & speed'**
  String get settingsPlaybackRowLabel;

  /// No description provided for @settingsAboutLabel.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutLabel;

  /// No description provided for @settingsAboutRowLabel.
  ///
  /// In en, this message translates to:
  /// **'App info & version'**
  String get settingsAboutRowLabel;

  /// No description provided for @settingsEditNameSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get settingsEditNameSheetTitle;

  /// No description provided for @settingsNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get settingsNameHint;

  /// No description provided for @settingsThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeLabel;

  /// No description provided for @themeSystemLabel.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystemLabel;

  /// No description provided for @themeLightLabel.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLightLabel;

  /// No description provided for @themeDarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDarkLabel;

  /// No description provided for @settingsGaplessLabel.
  ///
  /// In en, this message translates to:
  /// **'Gapless playback'**
  String get settingsGaplessLabel;

  /// No description provided for @settingsCrossfadeLabel.
  ///
  /// In en, this message translates to:
  /// **'Crossfade'**
  String get settingsCrossfadeLabel;

  /// No description provided for @crossfadeOffValue.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get crossfadeOffValue;

  /// No description provided for @settingsDefaultSpeedLabel.
  ///
  /// In en, this message translates to:
  /// **'Default speed'**
  String get settingsDefaultSpeedLabel;

  /// No description provided for @settingsHapticsLabel.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get settingsHapticsLabel;

  /// No description provided for @settingsRescanLabel.
  ///
  /// In en, this message translates to:
  /// **'Rescan library'**
  String get settingsRescanLabel;

  /// No description provided for @rescanCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Library rescanned'**
  String get rescanCompleteMessage;

  /// No description provided for @settingsReplayOnboardingLabel.
  ///
  /// In en, this message translates to:
  /// **'Show onboarding again'**
  String get settingsReplayOnboardingLabel;

  /// No description provided for @settingsVersionValue.
  ///
  /// In en, this message translates to:
  /// **'Version {version} ({buildNumber})'**
  String settingsVersionValue(String version, String buildNumber);

  /// No description provided for @settingsLicenseLabel.
  ///
  /// In en, this message translates to:
  /// **'License (MIT)'**
  String get settingsLicenseLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
