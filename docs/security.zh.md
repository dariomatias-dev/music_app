# 安全政策

<p align="center">
<a href="security.md">English</a> · <a href="security.es.md">Español</a> · <a href="security.pt-BR.md">Português (BR)</a> · <strong>中文</strong>
</p>

## 支持的版本

**Music App** 以源码形式维护。唯一受支持的版本是当前的 `main` 分支：安全修复仅在该分支上进行，不会回移植到较早的提交。

## 报告漏洞

请**不要**通过公开的 GitHub issue 报告安全漏洞。

请改为发送邮件至 [dariomatias.dev@gmail.com](mailto:dariomatias.dev@gmail.com)，并附上：

- 漏洞描述及其潜在影响。
- 复现步骤（提供最小可复现示例会很有帮助）。
- 你构建时所用的 commit，以及测试所用的 Android 版本。

本项目为个人独立维护的业余开源项目：没有专门的安全团队，也没有正式的 SLA，但每一份报告都会被认真对待并尽快回应。修复发布后，除非报告者希望保持匿名，否则将予以致谢。

## 范围

应用完全离线运行：仅播放设备上已有的音频文件，所有数据均存储在本地（通过 `drift` 使用 SQLite，以及 `shared_preferences`），不发起任何网络请求。因此，最相关的问题类别均属本地层面：应用如何处理不受信任的文件输入（音频元数据解析、导入的 JSON 与数据库备份），以及如何在设备上存储数据。与服务器或账户相关的问题不在此列，因为本应用既无服务器也无账户体系。
