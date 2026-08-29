# 架构

<p align="center">
<a href="architecture.md">English</a> · <a href="architecture.es.md">Español</a> · <a href="architecture.pt-BR.md">Português (BR)</a> · <strong>中文</strong>
</p>

本文档比 README 的概览更深入一层，面向任何要修改本仓库代码的人：一个文件该放在哪里、某一层为什么存在、各部分之间如何通信。

## 目录结构

```
lib/
  main.dart                 # 组合根：平台初始化、ProviderScope、RestartWidget
  src/
    core/                   # 横切关注点，被所有功能模块共享
      audio/                # just_audio + audio_service 集成
      database/             # drift 数据库结构、表、DAO、迁移
      navigation/            # go_router 配置、MainShell、自适应导航
      permissions/            # 媒体权限抽象层
      services/               # 元数据读写、id 生成、文件选择器等
      storage/                # 键值存储抽象层（shared_preferences）
      widgets/                 # 不属于任何具体功能模块的小型通用组件
    features/
      <feature>/
        data/                # 仓库实现、数据源、DTO/映射器
        domain/              # 实体、仓库接口、用例
        presentation/
          providers/         # 派生状态/表现层状态
          screens/           # 每个路由一个文件
          view_models/       # Notifier/AsyncNotifier 类
          widgets/           # 功能模块级组件，以及每个界面各自的目录
packages/
  app_ui/                    # 独立的设计系统包（见下文）
```

`lib/src/features/` 下的每个功能模块都是一个纵向切片：`library`（音乐库）、`player`（播放器）、`queue`（队列）、`playlist`（播放列表）、`favorites`（收藏，属于 `library`）、`history`（历史）、`statistics`（统计）、`storage`（存储空间）、`search`（搜索）、`home`（首页）、`settings`（设置）、`onboarding`（引导）、`splash`（启动页）。

## 分层（Clean Architecture + MVVM）

每个涉及持久化状态的功能模块都遵循相同的三层结构：

- **`domain`（领域层）**——纯 Dart 代码。实体（`freezed` 数据类）、抽象仓库接口，以及针对真正有分支逻辑的操作（如 `CreateBackup`、`RestoreBackup`、`DeleteTrackFile`）编写的用例类（只有一个 `call()` 方法）。这一层不导入 Flutter、Riverpod 或 drift。
- **`data`（数据层）**——针对具体数据源（drift 的 DAO、`shared_preferences`、平台插件）实现 `domain` 层定义的仓库接口。映射器负责在 drift 的行类型与领域实体之间转换。
- **`presentation`（表现层）**——界面和组件，以及 `ViewModel`：通过 `riverpod_generator` 生成的 provider 暴露的 Riverpod `Notifier`/`AsyncNotifier` 类。界面只监听 provider；除了由用户操作触发的一次性 `ref.read(...)` 调用外，界面从不直接与仓库通信。

一个功能模块只能依赖另一个功能模块的 `domain` 层（实体、仓库接口），绝不依赖其 `data` 或 `presentation` 层。具体实现通过各功能模块自己的 `*_data_providers.dart` 文件接入。

## 组件组织方式

界面文件保持精简。它只负责监听所需的 provider、处理用户操作触发的回调，并组合各个组件——界面渲染的内容一律不在界面文件内内联定义。这些组件放在该功能模块的 `presentation/widgets/` 下，分为两类：

- `widgets/<名称>.dart`——功能模块内共享：被多个界面使用，或被该模块暴露的 sheet、对话框使用（`media_row.dart`、`playlist_cover_art.dart`、`track_more_sheet.dart`）。
- `widgets/<界面名>/<组件名>.dart`——仅属于某一个界面，每个文件一个公开类，以其渲染的内容命名（`widgets/album_screen/album_header.dart`、`widgets/storage_screen/storage_folder_header.dart`）。

由此衍生出两条约定：

- **界面文件末尾不写私有组件类，也不写 `_buildX()` 辅助方法。** 这两种写法都会让组件无法独立重建，而且 `_buildX()` 方法永远无法成为 `const`。正确做法是把组件提取为独立文件中的真正的类。
- **界面级组件是公开的**（`AlbumHeader`，而非 `_AlbumHeader`），因为它们现在跨越了文件边界。按照约定，它们仍然只属于所在功能模块：模块之外不会导入它们。如果第二个功能模块确实需要某个组件，那么纯展示型的应放入 `app_ui`，依赖应用状态的应放入 `lib/src/core/widgets/`。

界面文件一旦超过大约 300–400 行，就说明还有内联的组件需要提取出去。

## 状态管理

全程使用 [Riverpod](https://riverpod.dev/)，并用 `riverpod_generator` 生成样板代码：

- `Provider` 用于无状态依赖（仓库、用例）。
- `NotifierProvider` / `AsyncNotifierProvider` 用于任何带行为的对象（即 `ViewModel`）。
- `StreamProvider` 用于仓库已经暴露 `Stream` 的场景（大多数仓库的 `watch*` 方法）。

Provider 按角色分组存放，而不是一个 provider 一个文件：例如 `library_providers.dart`（派生/表现层状态）、`library_data_providers.dart`（仓库/数据源），以此类推。

## 导航

使用 [go_router](https://pub.dev/packages/go_router) 的 `StatefulShellRoute.indexedStack` 实现四个主标签页（首页、搜索、音乐库、设置），切换标签页时各自保留自己的导航栈。`MainShell`（`lib/src/core/navigation/main_shell.dart`）负责渲染该外壳，并通过 `LayoutBuilder` 自适应：

- 宽度低于 `AppBreakpoints.medium`（840px）时：手机风格的底部导航栏。
- 达到或超过该宽度时（平板、展开的可折叠设备）：侧边的 `NavigationRail`。

详情页路由（专辑、艺术家、播放列表、播放器等）会压入当前标签页的导航栈之上，每个都包裹在自己的 `MiniPlayerDock` 中，以保持悬浮的迷你播放器始终可见。

## 数据持久化

[drift](https://pub.dev/packages/drift)（一个类型安全的 SQLite 层）承载所有需要持久化的数据：已索引的音乐库（曲目/专辑/艺术家）、播放列表、收藏、播放历史、歌词缓存、搜索历史，以及被排除的文件夹。`AppDatabase`（`lib/src/core/database/app_database.dart`）定义了数据库结构和迁移策略；每张表都有自己的 `*Table`/`*Dao` 组合。不需要查询的用户偏好（主题、语言、交叉淡入淡出时长等）则通过一个轻量的 `KeyValueStorage` 抽象层，借助 `shared_preferences` 存储。

应用提供两套独立的备份机制，都可以在 设置 → 存储空间 中找到：

- 可移植的 **JSON 导出**（`CreateBackup`/`RestoreBackup`），只包含用户创建的数据——播放列表、收藏、历史记录、被排除的文件夹、搜索历史和偏好设置——通过每首曲目稳定的 `sourceId`（而非仅在本次安装中有效的内部 id）进行关联，恢复时是合并而非覆盖。
- **原始数据库文件备份**（`CreateDatabaseBackup`/`RestoreDatabaseBackup`），通过 `VACUUM INTO` 对整个 SQLite 文件做逐字节快照，包含已索引的音乐库。恢复时会直接替换整个文件，并重启应用（通过 `RestartWidget`——一种通过更换 `Key` 来销毁并重建整个 `ProviderScope` 的方式）以重新打开一个干净的数据库连接。

## 音频

[just_audio](https://pub.dev/packages/just_audio) 负责实际播放；[audio_service](https://pub.dev/packages/audio_service) 通过 `MusicAudioHandler` 将其暴露给操作系统（锁屏界面、通知栏、蓝牙控制）。系统侧的元数据更新和应用自身的交叉淡入淡出效果都基于同一个上游信号——`just_audio` 在曲目切换边界触发的原生 `currentIndex` 变化——因此两者永远不会失去同步。

目前实现的交叉淡入淡出，本质上是单一播放器的音量渐变：原生引擎自身完成从曲目 A 到 B 的瞬时无缝切换，`PlaybackTransitionEffects` 只是随后让 B 从静音状态淡入——并不是两路音频真正地相互叠加。这是已知的简化实现，不是缺陷。

## 设计系统（`packages/app_ui`）

一个自成一体的 Flutter 包，拥有独立于主应用的版本号和测试（自己的 CI 任务、自己的覆盖率门槛）。它导出：

- **设计令牌**：`AppSpacing`、`AppSizes`、`AppRadius`、`AppDurations`、`AppCurves`、`AppBreakpoints`，以及字体和色彩规范。
- **主题**：浅色/深色 `AppTheme`，通过 `BuildContext` 扩展（`context.colors`）暴露给组件。
- **组件**：按钮、卡片、对话框、底部弹窗、导航、反馈提示（toast）、状态展示（空状态/错误/权限/索引中），以及所有可点击组件都基于的交互基础组件 `Pressable`。

应用中从不直接内联定义颜色、间距或动画曲线——一切都来自 `app_ui`。

## 测试

当前的文件数量和覆盖率门槛请参见 README 的测试章节。简而言之：仓库/用例/view model 有单元测试，界面/组件有组件测试（包括设计系统和关键界面的 golden test），另外 `integration_test/` 中还有少量端到端流程测试（引导 → 扫描 → 首页、从音乐库播放、以及模拟重启后的数据持久化）。
