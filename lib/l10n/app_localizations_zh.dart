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
  String get playlistsComingSoonMessage => '播放列表即将推出';

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
}
