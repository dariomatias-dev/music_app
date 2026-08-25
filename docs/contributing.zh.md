# 贡献指南

<p align="center">
<a href="contributing.md">English</a> · <a href="contributing.es.md">Español</a> · <a href="contributing.pt-BR.md">Português (BR)</a> · <strong>中文</strong>
</p>

感谢你考虑为本项目做贡献。本文档介绍环境搭建、约定，以及一个 pull request 在被评审之前需要满足的条件。想了解代码组织方式，请参阅 [`architecture.md`](architecture.zh.md)。

## 环境搭建

本项目通过 [FVM](https://fvm.app/) 固定 Flutter SDK 版本，因此下面所有命令都使用 `fvm flutter`，而不是直接安装的 `flutter`。

```sh
git clone https://github.com/dariomatias-dev/music_app.git
cd music_app
fvm install
fvm flutter pub get
```

生成的代码（freezed、json_serializable、drift、riverpod_generator、go_router_builder）和本地化文件不会在每次改动时预先编译并提交——拉取代码或修改它们所依赖的内容后，需要重新生成：

```sh
fvm dart run build_runner build --delete-conflicting-outputs
fvm flutter gen-l10n
```

在已连接的设备或模拟器上用 `fvm flutter run` 运行应用。

## 提交 pull request 之前

- **先开一个 issue** 讨论这个改动，除非它是一个很小且明显的修复。
- **遵循现有结构**：功能优先（feature-first）、`data`/`domain`/`presentation` 分层、状态用 Riverpod，不要在未讨论的情况下引入新模式。参见 [`architecture.md`](architecture.zh.md)。
- **符合设计系统**：不要内联写颜色、间距或动画时长——使用 `packages/app_ui` 中的 token 和组件。
- **为带逻辑的内容编写测试**：仓库方法、用例、`ViewModel`、组件行为等。`packages/app_ui` 是独立的包，有自己的测试套件；对它的改动也需要相应的测试。
- **每一份文档、字符串和本地化资源都要覆盖所有支持的语言**（英语、西班牙语、葡萄牙语、中文）——包括 `lib/l10n/*.arb` 文件，以及 `docs/` 下的任何文档。
- **提交前在本地跑完整检查**：

  ```sh
  fvm flutter analyze
  fvm dart format --output=none --set-exit-if-changed lib test
  fvm flutter test --coverage
  ./scripts/check_coverage.sh coverage/lcov.info 97
  ```

  （对 `packages/app_ui/` 的改动，在该目录下运行同样的四个命令；那里的覆盖率门槛是 98。）

- **提交信息**遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范：`feat:`、`fix:`、`docs:`、`refactor:`、`test:`、`ci:` 等，配一句简短的祈使句主题。可以看 `git log` 里已有的例子。

## CI 检查什么

每次 push 和 pull request 都会运行上面描述的相同检查，另外还会验证生成的文件（build_runner 输出、本地化文件）是否已提交且是最新的，并构建一个 release APK。具体步骤见 `.github/workflows/ci.yml`。

## 行为准则

参与本项目须遵守[行为准则](code_of_conduct.zh.md)。
