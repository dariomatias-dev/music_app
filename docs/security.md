# Security Policy

<p align="center">
<strong>English</strong> · <a href="security.es.md">Español</a> · <a href="security.pt-BR.md">Português (BR)</a> · <a href="security.zh.md">中文</a>
</p>

## Supported Versions

**Music App** is maintained as source. The only supported version is the current `main` branch: security fixes are applied there and are not backported to older commits.

## Reporting a Vulnerability

Please do **not** open a public GitHub issue to report a security vulnerability.

Instead, send an email to [dariomatias.dev@gmail.com](mailto:dariomatias.dev@gmail.com) containing:

- A description of the vulnerability and its potential impact.
- Steps to reproduce it (a minimal example is especially helpful).
- The commit you built from and the Android version you tested on.

This is a solo-maintained, hobby-scale open-source project: there is no dedicated security team and no formal SLA, but every report is taken seriously and acknowledged as soon as possible. Once a fix is published, the reporter will be credited unless they prefer to remain anonymous.

## Scope

The app runs fully offline: it plays audio files already present on the device, stores all data locally (SQLite via `drift`, `shared_preferences`), and makes no network requests. The most relevant classes of issue are therefore local: how the app handles untrusted file input (audio metadata parsing, imported JSON and database backups) and how it stores data on the device. Server- and account-related issues do not apply, since there is neither a server nor an account.
