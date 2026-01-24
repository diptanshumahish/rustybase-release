# RustyBase

<div align="center">

```text
    ____             __       ____
   / __ \__  _______/ /_  __ / __ )____ _________
  / /_/ / / / / ___/ __/ / / / __  / __ `/ ___/ _ \
 / _, _/ /_/ (__  ) /_  / / / /_/ / /_/ (__  )  __/
/_/ |_|\__,_/____/\__/ /_/ /_____/\__,_/____/\___/
                      /___/
```

**High-performance, proprietary MongoDB-compatible database engine built for speed, reliability, and simplicity.**

[![License](https://img.shields.io/badge/license-Proprietary-blue.svg)](LICENSE)
[![OS](https://img.shields.io/badge/OS-macOS%20|%20Linux%20|%20Windows-brightgreen.svg)]()
[![Platform](https://img.shields.io/badge/architecture-x86__64%20|%20arm64-orange.svg)]()

[Features](#key-features) • [Installation](#quick-install) • [Quick Start](#quick-start) • [Ecosystem](#ecosystem)

</div>

---

## Key Features

- **Blazing Fast**: Optimized storage engine written in Rust for minimal latency.
- **MongoDB Compatible**: Full support for MongoDB's query language and BSON format.
- **Reliable & Robust**: ACID-compliant transactions with Write-Ahead Logging (WAL).
- **Zero Dependency**: Standalone binary with no external runtimes required.
- **Standard SDKs**: First-class support for TypeScript/JavaScript and more.

## Quick Install

Get up and running in seconds using our automated installation scripts.

### Unix (macOS & Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/diptanshumahish/rustybase-release/master/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/diptanshumahish/rustybase-release/main/install.ps1 | iex
```

> [!TIP]
> Manual binaries for all supported platforms are available in the [Releases](https://github.com/diptanshumahish/rustybase-release/releases) section.

## Quick Start

Once installed, setting up your database is as simple as two commands:

```bash
# 1. Initialize your local instance
rustybase init

# 2. Start the database engine
rustybase serve
```

The server will start on `localhost:8080` (default) and is ready to accept connections.

## Ecosystem

RustyBase is more than just a server. Explore our growing list of tools:

- **[RustyBase SDK](https://www.npmjs.com/package/rustybase-sdk)**: Modern TypeScript/JavaScript SDK for seamless integration.
- **[RustyBase SDK](https://pypi.org/project/rustybase/)**: Python SDK for seamless integration.
- **[RustyBase Web UI](https://github.com/diptanshumahish/rustybase-admin)**: A beautiful administrative dashboard to manage your data visually.

---

<div align="center">
Built with ❤️ by [Diptanshu Mahish](https://github.com/diptanshumahish)
</div>
