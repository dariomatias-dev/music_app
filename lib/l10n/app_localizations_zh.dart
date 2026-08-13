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
}
