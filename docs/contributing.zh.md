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
  ./scripts/verify.sh
  ```

  它运行的就是 CI 运行的内容，范围限定为你改动过的包：格式化、静态分析、测试和覆盖率门槛（应用 97%，`packages/app_ui` 98%）。如果改动涉及 `build_runner` 或 `gen-l10n` 读取的文件，加上 `--gen`；`--all` 会不管改了什么都检查两个包；`--skip-tests` 用于开发过程中只做格式化和分析的快速检查。

  手动执行同样的检查时，在被改动的包目录下运行：

  ```sh
  fvm flutter analyze
  fvm dart format --output=none --set-exit-if-changed lib test
  fvm flutter test --coverage
  ./scripts/check_coverage.sh coverage/lcov.info 97
  ```

- **提交信息**遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范：`feat:`、`fix:`、`docs:`、`refactor:`、`test:`、`ci:` 等，配一句简短的祈使句主题。可以看 `git log` 里已有的例子。

## CI 检查什么

每次 push 和 pull request 都会运行 [`.github/workflows/ci.yaml`](../.github/workflows/ci.yaml)，共四个 job：

| Job | 具体做什么 |
| --- | --- |
| `music_app` | 安装依赖，重新生成代码和本地化文件，**如果这一步产生了 diff 就直接失败**——生成的文件必须已提交且是最新的。随后是格式检查、静态分析、测试，以及 97% 的覆盖率门槛，并以 `app` flag 将报告上传到 Codecov。 |
| `Build APK` | 在 `music_app` 通过后运行，构建 release APK，作为 workflow 产物上传并保留 14 天。 |
| `packages/app_ui` | 独立于应用本体，对设计系统包执行格式检查、静态分析、测试，以及 98% 的覆盖率门槛，并以 `app_ui` flag 上传到 Codecov。 |
| `Integration tests` | 在 `music_app` 通过后运行，启动一个 Android 模拟器，并在同一个会话中运行 `integration_test/` 下的所有测试套件——启动模拟器是其中最慢的一步。这些测试必须有设备：相关流程会读取 drift 的 stream query，而它们在普通 `flutter test` 的 fake async 下永远不会发出事件。该 job 会先启用 KVM，否则模拟器会退回软件渲染并超时；也正因如此它的超时预算是 45 分钟。 |

推送 `v*.*.*` 形式的 tag 则会运行 [`.github/workflows/release.yml`](../.github/workflows/release.yml)：执行同样的检查，然后把 release APK 发布到 GitHub release，并自动生成发布说明。注意 release 构建是**有意**使用 debug keystore 签名的——本应用没有生产环境的签名配置。

### 覆盖率报告

让构建失败的是 [`scripts/check_coverage.sh`](../scripts/check_coverage.sh)；让这个数字变得可读的是 [Codecov](https://codecov.io/gh/dariomatias-dev/music_app)。每个包用各自的 flag 上传自己的 `lcov.info`，因此两个门槛是分开跟踪的；每个 pull request 都会收到一条按 flag 列出覆盖率变化的评论，并在未覆盖的新增行上给出行内标注。[`codecov.yml`](../codecov.yml) 保存这些目标，并重复了脚本中的排除项：生成的源文件、`lib/l10n/` 以及 drift 的表声明。

上传使用仓库 secret `CODECOV_TOKEN` 认证。来自 fork 的 pull request 读不到它，会退回 Codecov 的免 token 上传，因此这一步特意设为 `fail_ci_if_error: false`——上传失败只意味着少了一份报告，绝不该让构建失败。

若想在本地得到同样的东西（无需账号），把 `lcov` 文件渲染成 HTML：

```sh
fvm flutter test --coverage
genhtml coverage/lcov.info -o coverage/html   # apt install lcov
xdg-open coverage/html/index.html
```

### 在本地运行工作流

[`act`](https://github.com/nektos/act) 可以在 Docker 中运行这些工作流；在推送任何对 `.github/workflows/` 的改动之前，值得先跑一遍。仓库的 `.actrc` 已经固定了 runner 镜像，因此不需要额外参数：

```sh
act -l                                # 列出所有 job 及其 id 和 stage
act pull_request                      # 运行 CI 在 PR 上会执行的全部内容
act pull_request -j app               # 只运行某一个 job，按 id 指定
act pull_request -j app --dryrun      # 只打印步骤，不实际执行
```

`-j` 接收的是 job 的 **id**（`app`、`build_apk`、`integration`、`app_ui`、`release`），而不是上表中的显示名称；`act -l` 会同时列出两者。首次真正运行会拉取数 GB 的 runner 镜像，而且 `act` 只是近似模拟 GitHub 的 runner，并非完全一致——`act` 跑通是一个好信号，但不能作为保证。

## 与 AI agent 协作

仓库自带 agent 配置，让助手遵循与贡献者相同的流程，而不是每次提示都临时发挥：

- [`CLAUDE.md`](../CLAUDE.md) 是工作约定，每一轮都会读取：代码放在哪里、每类改动必须测试什么、一次改动会让哪些文档失效。
- [`.claude/skills/ship-change/SKILL.md`](../.claude/skills/ship-change/SKILL.md) 收录按改动类型划分的操作步骤：`core` 服务、功能切片、`app_ui` 组件、带迁移的数据库结构改动、本地化文案、依赖升级。
- [`.claude/settings.json`](../.claude/settings.json) 配置了两个 hook。每次写入的 Dart 文件会立即格式化；`Stop` hook 在代码改动尚未通过 `./scripts/verify.sh` 时拒绝结束当前回合。
- [`.github/pull_request_template.md`](../.github/pull_request_template.md) 把同一份检查清单摆在评审者面前。

这些都不能替代 CI，CI 仍然是最终标准。它们的作用是让本地检查的结果与 CI 一致。修改这份约定、操作步骤或 hook 属于普通改动：请同时更新本节。

## 依赖更新

Dependabot 的配置在 [`.github/dependabot.yml`](../.github/dependabot.yml)，每周为四个生态开启更新 pull request：pub（应用本体）、pub（`packages/app_ui`）、Gradle（`android/`）和 GitHub Actions。

这些 pull request 与其他 PR 一样要通过同样的 CI。在批准之前，请先查看 [`dependencies.md`](dependencies.zh.md)：有几个包是被刻意限制在最新版本之下的，如果 Dependabot 的 PR 想升级这些依赖链中的某一个，应当关闭而不是合并。

## 行为准则

参与本项目须遵守[行为准则](code_of_conduct.zh.md)。
