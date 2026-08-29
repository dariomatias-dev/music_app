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
- **保持界面文件精简**：界面只负责组合组件、连接 provider。组件要放进 `presentation/widgets/<界面名>/` 下各自的文件，而不是写成界面文件末尾的私有类，也不是写成 `_buildX()` 辅助方法。参见[组件组织方式](architecture.zh.md#组件组织方式)。
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

每次 push 和 pull request 都会运行 [`.github/workflows/ci.yaml`](../.github/workflows/ci.yaml)，共三个 job：

| Job | 具体做什么 |
| --- | --- |
| `music_app` | 安装依赖，重新生成代码和本地化文件，**如果这一步产生了 diff 就直接失败**——生成的文件必须已提交且是最新的。随后是格式检查、静态分析、测试，以及 97% 的覆盖率门槛。 |
| `Build APK` | 在 `music_app` 通过后运行，构建 release APK，作为 workflow 产物上传并保留 14 天。 |
| `packages/app_ui` | 独立于应用本体，对设计系统包执行格式检查、静态分析、测试，以及 98% 的覆盖率门槛。 |

推送 `v*.*.*` 形式的 tag 则会运行 [`.github/workflows/release.yml`](../.github/workflows/release.yml)：执行同样的检查，然后把 release APK 发布到 GitHub release，并自动生成发布说明。注意 release 构建是**有意**使用 debug keystore 签名的——本应用没有生产环境的签名配置。

### 在本地运行工作流

[`act`](https://github.com/nektos/act) 可以在 Docker 中运行这些工作流；在推送任何对 `.github/workflows/` 的改动之前，值得先跑一遍。仓库的 `.actrc` 已经固定了 runner 镜像，因此不需要额外参数：

```sh
act -l                                # 列出所有 job 及其 id 和 stage
act pull_request                      # 运行 CI 在 PR 上会执行的全部内容
act pull_request -j app               # 只运行某一个 job，按 id 指定
act pull_request -j app --dryrun      # 只打印步骤，不实际执行
```

`-j` 接收的是 job 的 **id**（`app`、`build_apk`、`app_ui`、`release`），而不是上表中的显示名称；`act -l` 会同时列出两者。首次真正运行会拉取数 GB 的 runner 镜像，而且 `act` 只是近似模拟 GitHub 的 runner，并非完全一致——`act` 跑通是一个好信号，但不能作为保证。

## 依赖更新

Dependabot 的配置在 [`.github/dependabot.yml`](../.github/dependabot.yml)，每周为四个生态开启更新 pull request：pub（应用本体）、pub（`packages/app_ui`）、Gradle（`android/`）和 GitHub Actions。

这些 pull request 与其他 PR 一样要通过同样的 CI。在批准之前，请先查看 [`dependencies.md`](dependencies.zh.md)：有几个包是被刻意限制在最新版本之下的，如果 Dependabot 的 PR 想升级这些依赖链中的某一个，应当关闭而不是合并。

## 行为准则

参与本项目须遵守[行为准则](code_of_conduct.zh.md)。
