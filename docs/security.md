# Security Policy

<p align="center">
<strong>English</strong> · <a href="security.es.md">Español</a> · <a href="security.pt-BR.md">Português (BR)</a> · <a href="security.zh.md">中文</a>
</p>

## Supported Versions

**Music App** is not on the Play Store; it's distributed as a signed APK from [GitHub Releases](https://github.com/dariomatias-dev/music_app/releases). Only the latest release receives security fixes — there are no older maintained branches.

## Reporting a Vulnerability

Please **do not** open a public GitHub issue for a security vulnerability.

Instead, email [dariomatias.dev@gmail.com](mailto:dariomatias.dev@gmail.com) with:

- A description of the vulnerability and its potential impact.
- Steps to reproduce it (a minimal example helps a lot).
- The app version and Android version you tested on.

This is a solo-maintained, hobby-scale open-source project — there's no dedicated security team or SLA, but reports are taken seriously and acknowledged as soon as possible. Once a fix ships, the reporter will be credited in the release notes unless they'd rather stay anonymous.

## Scope

The app runs fully offline: it plays audio files already on the device, stores everything locally (SQLite via `drift`, `shared_preferences`), and makes no network requests. The most relevant classes of issue are therefore local: how it handles untrusted file input (audio metadata parsing, imported JSON/database backups) and how it stores data on device — not anything server- or account-related, since there is no server or account.
