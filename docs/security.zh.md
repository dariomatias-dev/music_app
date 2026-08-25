# 安全政策

<p align="center">
<a href="security.md">English</a> · <a href="security.es.md">Español</a> · <a href="security.pt-BR.md">Português (BR)</a> · <strong>中文</strong>
</p>

## 支持的版本

**Music App** 并未上架 Play 商店，而是通过 [GitHub Releases](https://github.com/dariomatias-dev/music_app/releases) 以签名 APK 的形式分发。只有最新发布的版本会收到安全修复——没有维护中的旧分支。

## 报告漏洞

请**不要**为安全漏洞在 GitHub 上开公开 issue。

请改为发邮件至 [dariomatias.dev@gmail.com](mailto:dariomatias.dev@gmail.com)，并附上：

- 漏洞描述及其潜在影响。
- 复现步骤（一个最小可复现示例会很有帮助）。
- 测试所用的应用版本和 Android 版本。

这是一个由个人独立维护、业余性质的开源项目——没有专门的安全团队，也没有正式的 SLA，但每一份报告都会被认真对待并尽快回应。修复发布后，除非报告者希望保持匿名，否则会在发布说明中致谢。

## 范围

应用完全离线运行：它播放设备上已有的音频文件，所有数据都存储在本地（通过 `drift` 使用 SQLite、通过 `shared_preferences`），不发起任何网络请求。因此最相关的问题类别是本地层面的：应用如何处理不受信任的文件输入（音频元数据解析、导入的 JSON/数据库备份），以及如何在设备上存储数据——而不是服务器或账户相关的问题，因为本应用既没有服务器也没有账户体系。
