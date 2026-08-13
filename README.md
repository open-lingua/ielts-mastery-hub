<h1 align="center">
  <code>IELTS Mastery Hub</code>
</h1>

<p align="center">
An open-source desktop IELTS preparation platform offering timed reading, listening, and AI-graded writing practice — with progress tracking and realistic exam simulations.
</p>

![Open Source](https://img.shields.io/badge/Open%20Source-%E2%9D%A4-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)

## Disclaimer

**IELTS Mastery Hub** is an independent, open source, community-driven project created for educational and non-commercial purposes. It is **not affiliated with, endorsed by, sponsored by, or in any way officially connected** with IELTS, the British Council, IDP Education Ltd., IDP IELTS, Cambridge Assessment English, or any of their subsidiaries or affiliates (collectively, the "IELTS Owners").

The names **IELTS**, **International English Language Testing System**, and any associated logos, trademarks, or trade names are registered trademarks of their respective owners. All product and company names, logos, and brands mentioned in this repository are the property of their respective owners. Use of these names, trademarks, and brands does not imply endorsement.

This project does not use any official IELTS test content, copyrighted materials, or proprietary question banks. All practice materials, question sets, and simulated exam content included in this repository are either originally created by contributors or produced for demonstrative and educational purposes only, and are not intended to replicate or substitute official IELTS test material.

No part of this project is intended for commercial use, and it generates no revenue or profit of any kind. It is maintained on a voluntary, community basis and distributed free of charge under an open source license (MIT), with the sole intent of helping learners practice English proficiency skills in a format inspired by, but not identical or official to, the real IELTS examination.

This software is provided **"as is"**, without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and non-infringement. In no event shall the authors, contributors, or copyright holders be liable for any claim, damages, or other liability, whether in an action of contract, tort, or otherwise, arising from, out of, or in connection with the software or the use or other dealings in the software — including, without limitation, any reliance on this application as a substitute for official IELTS test preparation materials or guidance from Test Owners or authorized test centers.

If you are the rightful owner of any trademark referenced herein and have concerns about its use in this repository, please open an issue and it will be addressed promptly, including removal or renaming if required.

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
