<h1 align="center">
  <code>@open-lingua/ielts-mastery-hub</code>
</h1>

<p align="center">
  <img src="assets/app-banner.png" alt="IELTS Mastery Hub" width="800" />
</p>

<p align="center">
An open-source desktop IELTS preparation platform offering timed reading, listening, and AI-graded writing practice — with progress tracking and realistic exam simulations.
</p>

![Open Source](https://img.shields.io/badge/Open%20Source-%E2%9D%A4-brightgreen)
![License](https://img.shields.io/badge/license-MIT-yellow)  [![](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-blue.svg)](https://github.com/open-lingua/ielts-mastery-hub)

## Preview

Watch a quick demo of IELTS Mastery Hub in action:

https://github.com/user-attachments/assets/b7f83657-4ea3-4c20-afce-fa3374f2c0b1

🎥 Full video with audio available at [`assets/preview.mp4`](assets/preview.mp4)
## Documentation

Full documentation is available at [https://open-lingua.github.io/ielts-mastery-hub/docs/intro/](IELTS Mastery Hub Docs).

## Disclaimer

This is an independent, non-commercial, open-source project for educational purposes. It is **not affiliated with or endorsed by** the British Council, IDP Education, or Cambridge Assessment English.

**IELTS** and **International English Language Testing System** are registered trademarks of their respective owners. All practice content in this repository is AI-generated for educational and demonstration purposes only — no official IELTS test material is used or reproduced.

This application is still a **work in progress** and may contain bugs or issues. If you encounter any problems, please report them here: please report them on [https://github.com/open-lingua/ielts-mastery-hub/issues](GitHub Issues).

The practice tests in this application are **generated using AI**, and therefore may not be 100% accurate. Their purpose is primarily educational, allowing users to practice in a realistic but non-official test environment.

This software is provided **"as is"** without warranty of any kind. The authors are not liable for any damages arising from its use.

## What it is

IELTS Mastery Hub simulates the real IELTS exam experience:

- 📖 **Reading** — split-screen practice covering official question types with auto-scoring
- 🎧 **Listening** — audio-driven sections with progressive difficulty
- ✍️ **Writing** — dual-pane editor with AI-based evaluation across official scoring criteria
- 📊 **Dashboard** — track scores and progress over time

The app is built with a TypeScript frontend and a Rust-powered core (Tauri) for local, native performance.

## Why

Most IELTS prep tools are either paid, gated behind subscriptions, or don't reflect the real exam format. This project aims to provide a free, open, and realistic practice environment for candidates preparing for Academic and General Training modules.

## Getting Started

### Install

**macOS / Linux:**

```bash
curl -fsSL https://open-lingua.github.io/ielts-mastery-hub/install/install.sh | sh
```

**Windows:**

```powershell
irm https://open-lingua.github.io/ielts-mastery-hub/install/install.ps1 | iex
```

### Build from source

```bash
# Clone the repo
git clone https://github.com/open-lingua/ielts-mastery-hub.git
cd ielts-mastery-hub

# Install dependencies
bun install

# Run the app
bun run tauri dev
```
