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
}
