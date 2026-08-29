<br>
<div align="center">
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
<img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android">
</div>
<br>
<div align="center">
<a href="https://github.com/dariomatias-dev/music_app/actions/workflows/ci.yaml"><img src="https://github.com/dariomatias-dev/music_app/actions/workflows/ci.yaml/badge.svg" alt="CI"></a>
<img src="https://img.shields.io/badge/lints-very__good__analysis-blueviolet?style=flat" alt="very_good_analysis">
<a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-green.svg" alt="MIT 许可证"></a>
</div>
<br>

<p align="center">
<a href="README.md">English</a> · <a href="README.es.md">Español</a> · <a href="README.pt-BR.md">Português (BR)</a> · <strong>中文</strong>
</p>

<h1 align="center">Music App</h1>

<p align="center">
一个 Android 应用，播放你设备上已有的音乐，完全离线，无需账号，不依赖流媒体服务。
<br>
<a href="#关于项目"><strong>浏览文档 »</strong></a>
<br>
<br>
<a href="https://github.com/dariomatias-dev/music_app/issues">报告 Bug</a>
·
<a href="https://github.com/dariomatias-dev/music_app/issues">提出新功能</a>
</p>

## 目录

- [关于项目](#关于项目)
- [功能](#功能)
- [技术栈](#技术栈)
- [架构](#架构)
- [测试](#测试)
- [截图](#截图)
- [快速开始](#快速开始)
- [脚本](#脚本)
- [文档](#文档)
- [贡献](#贡献)
- [许可证](#许可证)
- [作者](#作者)

## 关于项目

**Music App** 是一款离线本地音乐播放器，专为 Android 打造。它扫描设备上已有的音频文件，据此建立可搜索的音乐库，全程无需联网、无需账号，也不涉及任何流媒体服务。

播放器支持无缝播放（gapless）与交叉淡入淡出、持久化播放队列、睡眠定时器，以及可调节的播放速度。除了播放本身，它还让你真正掌控自己的音乐库：播放列表、收藏、按文件夹管理存储（包括哪些文件夹会被扫描），以及简单的收听统计。

## 功能

- **本地音乐库**：扫描设备中的音频文件，为曲目、专辑和艺术家建立索引，包含封面和元数据。
- **播放**：无缝播放（gapless）、交叉淡入淡出、随机播放、循环播放、可调节速度，以及睡眠定时器。
- **播放列表**：创建、重命名、复制和删除播放列表，支持可选描述、收藏、拖拽排序、列表内搜索，以及多种排序方式。
- **收藏**：收藏任意曲目，在专属标签页中快速访问。
- **搜索**：按标题或艺术家实时筛选你的音乐库。
- **歌词**：在播放时查看曲目歌词，来源可以是本地文件或内嵌元数据。
- **存储管理**：查看每个文件夹占用的空间，将文件夹纳入或排除扫描范围，删除文件，清理封面缓存。
- **统计**：按曲目和艺术家细分的收听历史与时长统计。
- **浅色与深色主题**：全局主题，可跟随系统或手动设置，并会记住你的选择。
- **多语言支持**：完整的应用界面支持英语、西班牙语、葡萄牙语和中文。
- **无障碍支持**：交互元素带有语义化标签，方便屏幕阅读器使用。

## 技术栈

- **[Flutter](https://flutter.dev/)**：Google 推出的 UI 工具包，用同一套代码构建原生编译的应用。
- **[Dart](https://dart.dev/)**：Flutter 背后的编程语言。
- **[Riverpod](https://riverpod.dev/)**：状态管理与依赖注入。
- **[go_router](https://pub.dev/packages/go_router)**：声明式路由，包含一个持久化的底部标签页外壳。
- **[just_audio](https://pub.dev/packages/just_audio)** 与 **[audio_service](https://pub.dev/packages/audio_service)**：无缝/交叉淡入淡出播放，以及与操作系统媒体会话的集成（锁屏、通知栏、蓝牙控制）。
- **[drift](https://pub.dev/packages/drift)**：本地 SQLite 数据库，承载音乐库索引、播放列表、收藏和收听历史。
- **[metadata_god](https://pub.dev/packages/metadata_god)** 与 **[on_audio_query](https://pub.dev/packages/on_audio_query)**：读取音频文件元数据，并查询设备的媒体存储。
- **[freezed](https://pub.dev/packages/freezed_annotation)**：不可变的领域模型。
- **[intl](https://pub.dev/packages/intl)** 与 Flutter 内置的 `l10n` 工具链：英语、西班牙语、葡萄牙语和中文的本地化支持。
- **[mocktail](https://pub.dev/packages/mocktail)**：测试套件中使用的 mock 工具。

## 架构

应用按功能模块组织（`lib/src/features/`），每个模块都有自己的 `data`、`domain` 和 `presentation` 层，遵循 Clean Architecture 和 MVVM：

- **library**：已索引的曲目、专辑和艺术家，以及对应的标签页。
- **player** / **queue**：播放控制、当前播放界面和播放队列。
- **playlist**：用户创建的播放列表及其曲目。
- **history** / **statistics**：记录的播放事件，以及由此得出的收听统计。
- **storage**：按文件夹统计的空间占用，以及扫描的纳入/排除设置。
- **search**、**home**、**settings**、**onboarding**、**splash**：其余的顶层界面。

状态通过 Riverpod 管理（通过 provider 暴露的 `ViewModel`/`Notifier` 类），路由使用 `go_router`，持久化通过 `drift`（SQLite）和 `shared_preferences` 实现。共享的设计系统——从按钮到全应用通用的底部弹窗等所有带主题的组件——都放在独立的本地包 `packages/app_ui` 中；横切关注点（导航、数据库、音频、权限）则位于 `lib/src/core`。界面文件保持精简：每个界面只负责组合放在 `presentation/widgets/<界面名>/` 下的组件，而不是在界面文件内内联定义。

## 测试

项目共有 181 个测试文件（应用本体 124 个，`packages/app_ui` 中 57 个），覆盖仓库、view model 和组件——其中 40 个是 golden 测试，为设计系统和关键界面渲染 86 张参考图——此外还有 `integration_test/` 中覆盖引导、播放和数据持久化流程的集成测试。CI 强制要求应用本体的行覆盖率不低于 97%，`packages/app_ui` 不低于 98%，并配合严格的 `very_good_analysis` lint 规则集和 `dart format` 检查。

```sh
fvm flutter analyze
fvm flutter test
```

## 截图

<div align="center">
<img src="screenshots/en/01_home.png" width="200" alt="首页"/>
<img src="screenshots/en/02_library_playlists.png" width="200" alt="播放列表"/>
<img src="screenshots/en/03_playlist_detail.png" width="200" alt="播放列表详情"/>
<img src="screenshots/en/04_library_tracks.png" width="200" alt="曲目"/>
<img src="screenshots/en/05_now_playing.png" width="200" alt="正在播放"/>
<img src="screenshots/en/06_search.png" width="200" alt="搜索"/>
<img src="screenshots/en/07_settings.png" width="200" alt="设置"/>
<img src="screenshots/en/08_storage.png" width="200" alt="存储空间"/>
<img src="screenshots/en/09_statistics.png" width="200" alt="统计"/>
</div>

## 快速开始

本项目通过 [FVM](https://fvm.app/) 固定 Flutter SDK 版本，因此以下所有命令都使用 `fvm flutter`，而不是直接安装的 `flutter`。

```sh
git clone https://github.com/dariomatias-dev/music_app.git
cd music_app
fvm install
fvm flutter pub get
```

然后在已连接的设备或模拟器上运行应用：

```sh
fvm flutter run
```

## 脚本

实用脚本位于 `scripts/` 目录下。

| 脚本 | 命令 | 说明 |
| ---------------- | ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `screenshot`     | `scripts/screenshot.sh [device-id]`              | 在已连接的设备或模拟器上依次打开应用的主要界面，并将每个界面的截图保存到 `screenshots/` 中，用于 README。运行 `fvm flutter devices` 可以列出可用的设备 id。 |
| `check_coverage` | `scripts/check_coverage.sh <lcov-file> <minimum>` | 如果 `lcov.info` 报告（由 `flutter test --coverage` 生成）中的行覆盖率低于 `<minimum>`，则该脚本会失败。CI 用它来强制执行上面的覆盖率门槛；生成覆盖率报告后，也可以在本地运行它，在推送前先自查。 |

## 文档

更深入的技术文档存放在 [`docs/`](docs/architecture.zh.md) 中，并覆盖应用支持的每一种语言：

- **[架构](docs/architecture.zh.md)**：分层、状态管理、导航、数据持久化和设计系统，比上面的概览更深入。
- **[依赖说明](docs/dependencies.zh.md)**：为什么有些依赖包被固定在低于最新版本的位置。
- **[贡献指南](docs/contributing.zh.md)**：环境搭建、约定，以及 pull request 检查清单。
- **[行为准则](docs/code_of_conduct.zh.md)**。
- **[安全政策](docs/security.zh.md)**：如何报告漏洞。

## 贡献

贡献让开源社区成为一个学习和创造的绝佳场所。非常感谢你所做的任何贡献。

在开始动手之前，请先开一个 issue 讨论这个改动，遵循现有的代码风格，并确保在提交 pull request 前 `fvm flutter analyze` 和 `fvm flutter test` 都能通过。完整的检查清单见[贡献指南](docs/contributing.zh.md)。

## 许可证

基于 **MIT 许可证** 分发。更多信息见 [LICENSE](LICENSE) 文件。

## 作者

由 **Dário Matias Sales** 开发：

- **作品集**：[dariomatias-dev](https://dariomatias-dev.com)
- **GitHub**：[dariomatias-dev](https://github.com/dariomatias-dev)
- **邮箱**：[dariomatias.dev@gmail.com](mailto:dariomatias.dev@gmail.com)
- **Instagram**：[@dariomatias_dev](https://instagram.com/dariomatias_dev)
- **LinkedIn**：[linkedin.com/in/dariomatias-dev](https://linkedin.com/in/dariomatias-dev)
