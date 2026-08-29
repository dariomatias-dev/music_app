# 依赖说明

<p align="center">
<a href="dependencies.md">English</a> · <a href="dependencies.es.md">Español</a> · <a href="dependencies.pt-BR.md">Português (BR)</a> · <strong>中文</strong>
</p>

`pubspec.yaml` 中的大多数依赖都使用宽松的版本约束（`^x.y.z`），可以自由升级。但有几个被固定在某个具体版本，或者被限制在低于最新版本，原因单看约束本身并不明显。本文档记录这些原因，避免有人重新从头排查（或更糟——在不明白原因的情况下"修复"这个 pin）。

## `intl: 0.20.2`（精确固定）

由 `flutter_localizations` 强制要求，而 `flutter_localizations` 本身来自 Flutter SDK，不是 pub.dev 上的独立版本。已安装的 Flutter SDK 版本决定了 `flutter_localizations` 需要哪个版本的 `intl`；如果不先升级 Flutter SDK 就单独升级 `intl`，依赖解析会失败。

## `drift: 2.31.0`、`drift_dev: 2.31.0`（精确固定，低于最新版本）

`drift`/`drift_dev` 2.32.0 及以上版本需要 `analyzer` 处于 `^10.0.0–^13.0.0` 区间。而 `riverpod_generator`（当前为 `^3.0.0`）间接依赖 `riverpod_analyzer_utils`，后者把 `analyzer` 限制在远低于此的区间（在与 `riverpod_generator ^3.0.0` 兼容的版本中为 `^7`–`^9`）。两个区间没有交集，因此 `drift`/`drift_dev` 被固定在 `riverpod_generator ^3.0.0` 所允许的 analyzer 区间内的最后一个兼容版本。

**这不是一次小升级。** 解除 `drift` 的限制需要 `drift_dev 2.34+`，而它需要 `analyzer ^13`。唯一同时接受 `analyzer ^13` 的 `riverpod_analyzer_utils` 版本是 `1.0.0-dev.11`，而它只作为 `riverpod_generator ^4.0.8` 的间接依赖分发。而这又要求 `riverpod_annotation ^4.0.6`——这是**Riverpod 本身的一次主版本升级**，会连带把 `flutter_riverpod` 升到 4.x，并很可能影响整个应用中的生成代码和 provider 写法。请持续关注上游进展，不要把它当作一次孤立的依赖升级来尝试。

## `sqlite3_flutter_libs: 0.5.42`（精确固定，低于最新版本）

该包的最新版本（`0.6.0+eol`）是一次有意为之的"墓碑"发布——一个空包，其描述写着 *"Not used anymore, update to version 3.x of package:sqlite3 instead"*（不再使用，请改用 package:sqlite3 的 3.x 版本）。一旦 `sqlite3`（Dart 绑定层）迁移到其 3.x 系列（该系列自行承担原生库的职责），就不再需要这个包的原生二进制文件。

这次迁移**和上面 `drift` 的固定是同一个阻塞点**，不是另一个独立问题：`sqlite3` 3.x 需要 `drift ^2.34`，而被固定的 `drift` 2.31.0 只接受 `sqlite3 ^2.6`。解决了 `drift`/Riverpod 那条依赖链，这个问题也就一并解决了——不要试图单独升级 `sqlite3_flutter_libs` 或 `sqlite3`。

## 如何检查可用更新

```sh
fvm flutter pub outdated
```

偶尔运行一下，看看哪些依赖真正可以解析升级、哪些仍被上面提到的依赖链阻塞。

Dependabot 也会每周开启依赖更新 pull request（参见 [`contributing.md`](contributing.zh.md#依赖更新)）。它读取的是版本约束，而不是本文档，因此会时不时提出被上述依赖链阻塞的升级。遇到这类 PR 应当关闭而不是合并——这些版本锁定各有其必要性，只能连同其所属的整条依赖链一起解除。
