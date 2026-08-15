// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Music App';

  @override
  String get homeTabLabel => '主页';

  @override
  String get searchTabLabel => '搜索';

  @override
  String get libraryTabLabel => '音乐库';

  @override
  String get settingsTabLabel => '设置';

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingNext => '下一步';

  @override
  String get onboardingStartListening => '开始收听';

  @override
  String get onboarding1Title => '音乐就在你的设备上';

  @override
  String get onboarding1Body => '直接从设备读取你的文件。无需信号，无需账户，无需等待，在飞机上和在家里一样好用。';

  @override
  String get onboarding2Title => '为单手操作而设计';

  @override
  String get onboarding2Body => '播放器始终停留在屏幕底部，触手可及。左右滑动可跳过，向上滑动可全屏打开。';

  @override
  String get onboarding3Title => '它会记住你听的内容';

  @override
  String get onboarding3Body => '最近播放和收听统计都来自你实际收听的内容，不会发送到任何地方。';

  @override
  String get permissionTitle => '访问你的音乐';

  @override
  String get permissionMessage =>
      'Music App 需要访问设备上的音频文件，才能找到并播放你的音乐库。数据不会离开你的设备。';

  @override
  String get permissionGrant => '允许访问';

  @override
  String get permissionOpenSettings => '打开设置';

  @override
  String get permissionScanning => '正在扫描你的音乐库…';

  @override
  String get backButtonSemanticLabel => '返回';

  @override
  String get playbackEmptyTitle => '当前没有播放';

  @override
  String get playbackEmptyMessage => '播放音乐库中的一首曲目即可在此查看。';

  @override
  String get favoriteButtonSemanticLabel => '添加到收藏';

  @override
  String get unfavoriteButtonSemanticLabel => '取消收藏';

  @override
  String get shuffleButtonSemanticLabel => '随机播放';

  @override
  String get previousTrackButtonSemanticLabel => '上一首';

  @override
  String get nextTrackButtonSemanticLabel => '下一首';

  @override
  String get repeatButtonSemanticLabel => '循环播放';

  @override
  String get moreOptionsButtonSemanticLabel => '更多选项';

  @override
  String get viewQueueLabel => '队列';

  @override
  String get addToPlaylistLabel => '添加到播放列表';

  @override
  String get openLyricsLabel => '歌词';

  @override
  String get sleepTimerLabel => '睡眠定时器';

  @override
  String get fileInfoLabel => '文件信息';

  @override
  String get fileInfoDialogTitle => '文件信息';

  @override
  String get fileInfoFormatLabel => '格式';

  @override
  String get fileInfoSizeLabel => '大小';

  @override
  String get fileInfoBitrateLabel => '比特率';

  @override
  String get fileInfoSampleRateLabel => '采样率';

  @override
  String get fileInfoPathLabel => '路径';

  @override
  String get dialogDismissLabel => '好的';

  @override
  String get sleepTimerSheetTitle => '睡眠定时器';

  @override
  String get sleepTimerSheetBody => '在设定的时间后自动暂停播放。';

  @override
  String get sleepTimerEndOfTrackLabel => '本曲结束后';

  @override
  String get sleepTimerTurnOffLabel => '关闭定时器';

  @override
  String get sleepTimerSetMessage => '定时器已设置';

  @override
  String get sleepTimerOffMessage => '定时器已关闭';

  @override
  String get queueEmptyTitle => '队列为空';

  @override
  String get queueEmptyMessage => '播放音乐库中的一首曲目即可填充队列。';

  @override
  String get nowPlayingSemanticLabel => '正在播放';

  @override
  String get queueEditLabel => '编辑';

  @override
  String get queueDoneLabel => '完成';

  @override
  String get removeFromQueueSemanticLabel => '从队列中移除';

  @override
  String get dragToReorderSemanticLabel => '拖动以重新排序';

  @override
  String get clearQueueLabel => '清空队列';

  @override
  String get clearQueueConfirmTitle => '清空队列？';

  @override
  String get clearQueueConfirmMessage => '这将从队列中移除所有曲目并停止播放。';

  @override
  String get clearQueueConfirmAction => '清空';

  @override
  String get cancelLabel => '取消';

  @override
  String get lyricsEmptyTitle => '未找到歌词';

  @override
  String get lyricsEmptyMessage => '这首曲目没有内嵌歌词，也没有匹配的 .lrc 文件。';

  @override
  String get libraryTracksTab => '曲目';

  @override
  String get libraryAlbumsTab => '专辑';

  @override
  String get libraryArtistsTab => '艺人';

  @override
  String get libraryPlaylistsTab => '播放列表';

  @override
  String get libraryFavoritesTab => '收藏';

  @override
  String get sortByTitleLabel => '标题';

  @override
  String get sortByArtistLabel => '艺人';

  @override
  String get sortByDateAddedLabel => '添加日期';

  @override
  String get sortByDurationLabel => '时长';

  @override
  String get sortSheetTitle => '排序方式';

  @override
  String get tracksEmptyTitle => '暂无曲目';

  @override
  String get tracksEmptyMessage => '在你设备上找到的曲目会显示在这里。';

  @override
  String get playLabel => '播放';

  @override
  String trackCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首曲目',
    );
    return '$_temp0';
  }

  @override
  String get albumsEmptyTitle => '暂无专辑';

  @override
  String get albumsEmptyMessage => '在你设备上找到的专辑会显示在这里。';

  @override
  String get albumNotFoundTitle => '未找到专辑';

  @override
  String get albumNotFoundMessage => '这张专辑可能已从你的音乐库中移除。';

  @override
  String get artistsEmptyTitle => '暂无艺人';

  @override
  String get artistsEmptyMessage => '在你设备上找到的艺人会显示在这里。';

  @override
  String get artistNotFoundTitle => '未找到艺人';

  @override
  String get artistNotFoundMessage => '这位艺人可能已从你的音乐库中移除。';

  @override
  String albumCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 张专辑',
    );
    return '$_temp0';
  }

  @override
  String get favoritesEmptyTitle => '暂无收藏';

  @override
  String get favoritesEmptyMessage => '你收藏的曲目会显示在这里。';

  @override
  String get newPlaylistLabel => '新建播放列表';

  @override
  String get playlistNameHint => '播放列表名称';

  @override
  String get createLabel => '创建';

  @override
  String get saveLabel => '保存';

  @override
  String get renamePlaylistSheetTitle => '重命名播放列表';

  @override
  String get renamePlaylistLabel => '重命名';

  @override
  String get duplicatePlaylistLabel => '复制';

  @override
  String get deletePlaylistLabel => '删除';

  @override
  String get deletePlaylistConfirmTitle => '删除播放列表？';

  @override
  String get deletePlaylistConfirmMessage => '这会移除该播放列表。其中的曲目仍保留在你的音乐库中。';

  @override
  String get playlistOptionsSemanticLabel => '播放列表选项';

  @override
  String get playlistsEmptyTitle => '暂无播放列表';

  @override
  String get playlistsEmptyMessage => '点击“新建播放列表”创建第一个。';

  @override
  String playlistCopyName(String name) {
    return '$name 副本';
  }

  @override
  String get addedToPlaylistMessage => '已添加到播放列表';

  @override
  String get trackAlreadyInPlaylistMessage => '已在该播放列表中';

  @override
  String get removeFromPlaylistSemanticLabel => '从播放列表中移除';

  @override
  String get removeTrackConfirmTitle => '移除曲目？';

  @override
  String get removeTrackConfirmMessage => '这会将曲目从播放列表中移除。它仍会保留在你的音乐库中。';

  @override
  String get playlistEmptyTitle => '此播放列表为空';

  @override
  String get playlistEmptyMessage => '从曲目的更多菜单中添加曲目。';

  @override
  String get homeEmptyTitle => '音乐库为空';

  @override
  String get homeEmptyMessage => '在你设备上找到的曲目会显示在这里。';

  @override
  String get goodMorningLabel => '早上好';

  @override
  String get goodAfternoonLabel => '下午好';

  @override
  String get goodEveningLabel => '晚上好';

  @override
  String get homeWelcomeLabel => '欢迎回来';

  @override
  String get searchTriggerHintLabel => '搜索你的音乐库';

  @override
  String get recentlyPlayedLabel => '最近播放';

  @override
  String get libraryTotalDurationLabel => '总时长';

  @override
  String get storageLabel => '存储空间';

  @override
  String get clearSearchSemanticLabel => '清除搜索';

  @override
  String get searchResultsEmptyTitle => '未找到结果';

  @override
  String get searchResultsEmptyMessage => '换个搜索词试试。';

  @override
  String get recentSearchesLabel => '最近搜索';

  @override
  String get clearSearchHistoryLabel => '清除';

  @override
  String get clearSearchHistoryConfirmTitle => '清除搜索历史？';

  @override
  String get clearSearchHistoryConfirmMessage => '这会移除你所有的最近搜索。';

  @override
  String get clearSearchHistoryConfirmAction => '清除';

  @override
  String get removeSearchTermSemanticLabel => '从历史记录中移除';

  @override
  String get statisticsLabel => '统计';

  @override
  String get periodWeekLabel => '周';

  @override
  String get periodMonthLabel => '月';

  @override
  String get periodYearLabel => '年';

  @override
  String get periodAllTimeLabel => '全部';

  @override
  String get totalListenedLabel => '收听时长';

  @override
  String get currentStreakLabel => '当前连续天数';

  @override
  String get longestStreakLabel => '最长连续天数';

  @override
  String dayCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天',
    );
    return '$_temp0';
  }

  @override
  String playCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '播放 $count 次',
    );
    return '$_temp0';
  }

  @override
  String get dailyActivityLabel => '每日活动';

  @override
  String get hourlyActivityLabel => '按小时活动';

  @override
  String get mostPlayedTracksLabel => '最常播放的曲目';

  @override
  String get mostPlayedArtistsLabel => '最常播放的艺人';

  @override
  String get statisticsEmptyTitle => '暂无内容';

  @override
  String get statisticsEmptyMessage => '听一些音乐，你的统计数据就会显示在这里。';

  @override
  String get clearHistoryLabel => '清除历史记录';

  @override
  String get clearHistoryConfirmTitle => '清除收听历史记录？';

  @override
  String get clearHistoryConfirmMessage => '这会重置最近播放记录以及由此得出的所有统计数据。你的音乐库不受影响。';

  @override
  String get clearHistoryConfirmAction => '清除';

  @override
  String get storageTotalUsedLabel => '已用空间';

  @override
  String get storageFoldersLabel => '文件夹';

  @override
  String get includeInScanSemanticLabel => '包含在扫描中';

  @override
  String get clearArtworkCacheLabel => '清除封面缓存';

  @override
  String get clearArtworkCacheConfirmTitle => '清除封面缓存？';

  @override
  String get clearArtworkCacheConfirmMessage => '这会删除已缓存的专辑封面。下次扫描音乐库时会重新提取。';

  @override
  String get clearArtworkCacheConfirmAction => '清除';

  @override
  String get artworkCacheClearedMessage => '封面缓存已清除';

  @override
  String get deleteFileSemanticLabel => '删除文件';

  @override
  String get deleteFileConfirmTitle => '删除此文件？';

  @override
  String get deleteFileConfirmMessage =>
      '这会将其从设备中永久删除，同时移除播放列表和收藏中的相关条目。此操作无法撤销。';

  @override
  String get deleteFileConfirmAction => '删除';

  @override
  String get fileDeletedMessage => '文件已删除';

  @override
  String get fileDeleteFailedMessage => '无法删除此文件';

  @override
  String get settingsSectionProfileLabel => '个人资料';

  @override
  String get settingsSectionAppearanceLabel => '外观';

  @override
  String get settingsSectionPlaybackLabel => '播放';

  @override
  String get settingsSectionLibraryLabel => '音乐库';

  @override
  String get settingsSectionAboutLabel => '关于';

  @override
  String get settingsNameLabel => '姓名';

  @override
  String get settingsNameNotSetValue => '未设置';

  @override
  String get settingsLanguageLabel => '语言';

  @override
  String get settingsLanguageSystemValue => '跟随系统';

  @override
  String get settingsPlaybackRowLabel => '无间隔播放、淡入淡出与速度';

  @override
  String get settingsAboutLabel => '关于';

  @override
  String get settingsAboutRowLabel => '应用信息与版本';

  @override
  String get settingsEditNameSheetTitle => '你的姓名';

  @override
  String get settingsNameHint => '输入你的姓名';
}
