# 依赖说明

<p align="center">
<a href="dependencies.md">English</a> · <a href="dependencies.es.md">Español</a> · <a href="dependencies.pt-BR.md">Português (BR)</a> · <strong>中文</strong>
</p>

`pubspec.yaml` 中的大多数依赖都使用宽松的版本约束（`^x.y.z`），可以自由升级。但有几个（包括这里以及 Android 构建文件中的依赖）被固定在某个具体版本、被限制在低于最新版本，或通过 `dependency_overrides` 强制指定，原因单看约束本身并不明显。本文档记录这些原因，避免有人重新从头排查（或更糟，在不明白原因的情况下"修复"这个 pin）。

## `intl: 0.20.2`（精确固定）

由 `flutter_localizations` 强制要求，而 `flutter_localizations` 本身来自 Flutter SDK，不是 pub.dev 上的独立版本。已安装的 Flutter SDK 版本决定了 `flutter_localizations` 需要哪个版本的 `intl`；如果不先升级 Flutter SDK 就单独升级 `intl`，依赖解析会失败。

## `drift: 2.31.0`、`drift_dev: 2.31.0`（精确固定，低于最新版本）

`drift`/`drift_dev` 2.32.0 及以上版本需要 `analyzer` 处于 `^10.0.0–^13.0.0` 区间。而 `riverpod_generator`（当前为 `^3.0.0`）间接依赖 `riverpod_analyzer_utils`，后者把 `analyzer` 限制在远低于此的区间（在与 `riverpod_generator ^3.0.0` 兼容的版本中为 `^7`–`^9`）。两个区间没有交集，因此 `drift`/`drift_dev` 被固定在 `riverpod_generator ^3.0.0` 所允许的 analyzer 区间内的最后一个兼容版本。

**这不是一次小升级。** 解除 `drift` 的限制需要 `drift_dev 2.34+`，而它需要 `analyzer ^13`。唯一同时接受 `analyzer ^13` 的 `riverpod_analyzer_utils` 版本是 `1.0.0-dev.11`，而它只作为 `riverpod_generator ^4.0.8` 的间接依赖分发。而这又要求 `riverpod_annotation ^4.0.6`，这是**Riverpod 本身的一次主版本升级**，会连带把 `flutter_riverpod` 升到 4.x，并很可能影响整个应用中的生成代码和 provider 写法。请持续关注上游进展，不要把它当作一次孤立的依赖升级来尝试。

## `sqlite3_flutter_libs: 0.5.42`（精确固定，低于最新版本）

该包的最新版本（`0.6.0+eol`）是一次有意为之的"墓碑"发布，即一个空包，其描述写着 *"Not used anymore, update to version 3.x of package:sqlite3 instead"*（不再使用，请改用 package:sqlite3 的 3.x 版本）。一旦 `sqlite3`（Dart 绑定层）迁移到其 3.x 系列（该系列自行承担原生库的职责），就不再需要这个包的原生二进制文件。

这次迁移**和上面 `drift` 的固定是同一个阻塞点**，不是另一个独立问题：`sqlite3` 3.x 需要 `drift ^2.34`，而被固定的 `drift` 2.31.0 只接受 `sqlite3 ^2.6`。解决了 `drift`/Riverpod 那条依赖链，这个问题也就一并解决了，因此不要试图单独升级 `sqlite3_flutter_libs` 或 `sqlite3`。

## `flutter_rust_bridge: 2.11.1`（dependency override）

`metadata_god` 1.1.0 发布时所带的代码是针对 `flutter_rust_bridge` 2.11.1 生成的，而它自身对该包的依赖没有任何约束。若不干预，pub 会解析到更新的版本，生成的绑定会在应用启动时未通过自身的运行时版本校验。这个 override 把版本固定在绑定所对应的那一版。

它是一条 `dependency_overrides` 条目，而不是普通约束，这意味着它作用于整个依赖解析过程，并会无声地覆盖任何包提出的要求。等到 `metadata_god` 发布针对当前 `flutter_rust_bridge` 生成的绑定时，这条 override 即可移除。

## `gradle-wrapper: 8.14`、`com.android.application: 8.11.1`（限制在低于最新版本）

`metadata_god` 内置了 CargoKit，其 Gradle 脚本调用了 `exec()`，这个方法已被 Gradle 9 移除。任何升级到 Gradle 9.x 的尝试都会让 APK 构建失败并报 `Could not find method exec() ... on project ':metadata_god'`，因此 wrapper 保持在 8.x 线上，直到 `metadata_god` 发布能在 Gradle 9 下构建的 CargoKit。

Android Gradle Plugin 是**同一个阻塞的另一面**，而不是另一个独立问题：AGP 9.x 拒绝在低于 Gradle 9.5.0 的环境下运行，会以 `Minimum supported Gradle version is 9.5.0` 失败。解决了 CargoKit 的阻塞，这个问题也就一并解决了，因此不要单独把两者升过各自的 9.x 边界。

受限的是这条边界，而不是这两个具体版本。在 8.x 之内两者都可以自由移动，目前它们停在 Flutter 预告即将要求的下限（Gradle 8.14、AGP 8.11.1、Kotlin 2.2.20），并且构建时没有任何警告。

## 如何检查可用更新

```sh
fvm flutter pub outdated
```

偶尔运行一下，看看哪些依赖真正可以解析升级、哪些仍被上面提到的依赖链阻塞。

Renovate 读取的是版本约束，而不是本文档，因此上述每条依赖链也都写进了 [`renovate.json`](../renovate.json)：`drift`、`sqlite3`、`intl` 和 `flutter_rust_bridge` 被禁用，Gradle 与 Android Gradle Plugin 被限制在 9.x 之下。解除某个锁定时，需要在更新本文件的同一次改动中删除那里的对应规则，以免两者互相矛盾。Renovate 的 Dependency Dashboard issue 会列出当前所有被拦下的升级。
