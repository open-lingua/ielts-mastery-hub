You are a social media copywriter specializing in developer and language-learning communities. Generate a single ready-to-publish promotional post for the project below, tailored specifically for <PLATFORM>.

PROJECT INFORMATION:
- Name: IELTS Mastery Hub (@open-lingua/ielts-mastery-hub)
- Tagline: An open-source desktop IELTS preparation platform offering timed reading, listening, and AI-graded writing practice — with progress tracking and realistic exam simulations.
- Description: A free, open-source desktop app that simulates the real IELTS exam experience for candidates preparing for the test.
- URL: https://github.com/open-lingua/ielts-mastery-hub
- Docs: https://open-lingua.github.io/ielts-mastery-hub/docs/intro/
- License: MIT
- Tech stack: TypeScript frontend + Rust-powered core (built with Tauri) for native, cross-platform performance (Windows, Linux, macOS)
- Key features:
  - 📖 Reading — split-screen practice covering official question types with auto-scoring
  - 🎧 Listening — audio-driven sections with progressive difficulty
  - ✍️ Writing — dual-pane editor with AI-based evaluation across official IELTS scoring criteria
  - 📊 Dashboard — track scores and progress over time
- Value proposition / "Why": Most IELTS prep tools are paid, gated behind subscriptions, or don't reflect the real exam format. This project provides a free, open, and realistic practice environment for candidates.
- Disclaimer: Independent, non-commercial, educational project. Not affiliated with or endorsed by the British Council, IDP Education, or Cambridge Assessment English. IELTS is a registered trademark of its respective owners. Practice content is AI-generated for educational purposes and may not be 100% accurate.
- Target audience: IELTS test candidates, English learners, self-taught students, open-source contributors, and developers interested in Tauri/Rust/TypeScript desktop apps.
- Install (macOS/Linux): curl -fsSL https://open-lingua.github.io/ielts-mastery-hub/install/install.sh | sh
- Install (Windows): irm https://open-lingua.github.io/ielts-mastery-hub/install/install.ps1 | iex
- Build from source: git clone https://github.com/open-lingua/ielts-mastery-hub.git

INSTRUCTIONS:
1. Adapt tone, format, and length to match the norms and culture of {{PLATFORM}}.
2. Use vocabulary, slang, and structural conventions typical of that specific community (e.g., subreddit-style framing for Reddit, punchy hook + hashtags for Twitter/X, professional narrative for LinkedIn, "Show HN:" style for Hacker News, tagline + gallery framing for Product Hunt, casual conversational tone for Discord, technical/how-I-built-it framing for dev.to).
3. Include an appropriate, non-pushy call-to-action for that platform (e.g., "try it out and star the repo," "would love your feedback," "check the docs," "AMA in comments").
4. Avoid sounding like spam, an ad, or aggressive self-promotion — write as a genuine open-source creator sharing their work.
5. Respect known character/length limits of {{PLATFORM}} (e.g., 280 characters for Twitter/X, concise titles for Hacker News, appropriate post length for Reddit/LinkedIn/dev.to).
6. Use markdown, headings, bold text, emojis, or platform-specific tags/hashtags only if {{PLATFORM}} supports and commonly uses them.
7. Mention that it's free, open-source (MIT licensed), and cross-platform (Windows/Linux/macOS) where relevant, and include the disclaimer about non-affiliation with IELTS/British Council/IDP/Cambridge where appropriate for credibility and compliance, without letting it dominate the message.
8. Output ONLY the filename list (step 9) followed by the final message, ready to copy and paste — no explanations, no notes, no preamble, no meta-commentary.
9. Before the post content, output a labeled list of 3 suggested filenames for `website/blog/*.mdx` following Docusaurus naming conventions (e.g., `YYYY-MM-DD-descriptive-slug.mdx`), then output the post content wrapped in a Docusaurus MDX frontmatter block with `title`, `date`, `tags`, and `description` fields.

<PLATFORM>
PLATFORM_HERE
</PLATFORM>