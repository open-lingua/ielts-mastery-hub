<h1 align="center">
  <code>IELTS Mastery Hub</code>
</h1>

<p align="center">
A browser-based IELTS preparation platform offering timed reading, listening, and AI-graded writing practice — with progress tracking and realistic exam simulations.
</p>

![Open Source](https://img.shields.io/badge/Open%20Source-%E2%9D%A4-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)

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

```bash
# Clone the repo
git clone https://github.com/open-lingua/ielts-mastery-hub.git
cd ielts-mastery-hub

# Install dependencies
npm install

# Run the app
npm run tauri dev
```