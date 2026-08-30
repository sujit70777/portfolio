<div align="center">

# ehsanur.com

**Senior Flutter Engineer — Portfolio**

A Flutter Web site that ships apps the way it ships itself: data-driven, cache-safe, and built to survive a real production deploy.

<img src="web/og-preview.png" alt="ehsanur.com preview" width="640" />

**Live at [ehsanur.com](https://ehsanur.com)**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
[![Deploy](https://github.com/sujit70777/portfolio/actions/workflows/deploy.yml/badge.svg)](https://github.com/sujit70777/portfolio/actions/workflows/deploy.yml)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

</div>

---

## Contents

- [Why Flutter for a website](#why-flutter-for-a-website)
- [Features](#features)
- [Editing content](#editing-content)
- [Notable engineering details](#notable-engineering-details)
- [Project structure](#project-structure)
- [Running locally](#running-locally)
- [Deployment](#deployment)
- [Credits](#credits)
- [License](#license)
- [About me](#about-me)

---

## Why Flutter for a website

Most portfolio sites are React or plain HTML. I built this in Flutter Web deliberately — I'm a Flutter engineer, so the site itself is a working sample of what I do. It also let me reuse the same widget composition, theming and animation patterns I use in production mobile apps.

Trade-offs I accepted: a heavier initial payload than a static site, and SEO that needs explicit handling (see below). Both were worth it for a site whose audience is technical.

---

## Features

- **Fully data-driven** — all content lives in a single JSON file; no code changes needed to add a project or update experience
- **Multi-storefront links** — a project shipped to both the App Store and Google Play shows both, auto-labelled and iconed from a `platform` tag, with a small cross-platform badge on its card
- **Responsive** — desktop, tablet and mobile layouts
- **Light/dark themes**
- **SEO-aware** — meta tags, Open Graph and Twitter cards rendered in `web/index.html`, since Flutter Web doesn't emit crawlable markup by default
- **Multi-platform** — the same codebase builds for web, Android, iOS, macOS, Windows and Linux
- **Automated deploy** — push to `main` builds, pre-compresses, and ships to production

---

## Editing content

Everything visible on the site comes from one file:

```
assets/translations/en.json
```

It contains the profile summary, skills, experience, projects and contact links.

> [!IMPORTANT]
> Editing this file alone does **nothing** — it's compiled into `lib/src/localization/generated/*.g.dart` at build time via `easy_localization`, and that generated copy is what the app actually reads. After every edit, regenerate before running or committing:
> ```bash
> make localization
> ```
> The deploy workflow also runs this automatically, so a push is always safe even if you forget — but `flutter run` / `flutter build` locally will silently show stale content until you do.

Adding a project looks like this:

```json
{
  "name": "Project name",
  "description": "What it does and what I built.",
  "url": "https://link-to-live-project",
  "technologies": [
    { "name": "Flutter" },
    { "name": "Dart" }
  ]
}
```

Shipped on more than one store? Add `links` — each entry's `platform` (`ios`, `android`, `web`, `github` or `pubdev`) drives its button's label and icon in the project modal, and a project with both `ios` and `android` gets a small platform badge on its card:

```json
{
  "name": "Project name",
  "url": "https://apps.apple.com/...",
  "links": [
    { "url": "https://apps.apple.com/...", "platform": "ios" },
    { "url": "https://play.google.com/store/apps/details?id=...", "platform": "android" }
  ]
}
```

---

## Notable engineering details

A few things in here exist because they broke in practice, not because they looked good in a design doc:

- **Resume PDF is cache-proof.** The deploy workflow stamps a content hash onto the resume's URL on every build, so a re-uploaded resume is never served stale by a browser, an ISP proxy, or the host's own cache — no purge required.
- **The service worker self-destructs.** Rather than caching the app for offline use (and risking returning visitors getting stuck on a stale build), it unregisters itself on activate and forces a clean reload.
- **Static assets are pre-compressed in CI**, not at request time — the shared host's on-the-fly compression is slow and capped well below Brotli's ratio, so `.br`/`.gz` siblings are built once and served via an `.htaccess` rewrite.
- **Icons survive font tree-shaking.** FontAwesome glyphs referenced only from JSON content (a runtime string, not a compile-time `const IconData`) are invisible to Flutter's icon tree-shaker unless explicitly whitelisted — see the codepoint map in `lib/src/common/widgets/icon.dart`.

---

## Project structure

```
lib/                    Application code
assets/
  translations/         Content — en.json drives the whole site
  icons/                Tech and platform icons
  images/               Project screenshots
web/
  assets/documents/     Resume PDF (served as a static file, not a bundled asset —
                         see the comment in pubspec.yaml for why)
  index.html            Web entry point, meta tags, favicons
  .htaccess             Cache-control, compression and MIME rules for the host
.github/workflows/      Build and deploy pipeline
test/                   Widget tests
```

---

## Running locally

Requires the Flutter SDK (stable channel).

```bash
git clone https://github.com/sujit70777/portfolio.git
cd portfolio

flutter pub get
make localization   # compiles assets/translations/en.json into generated Dart
flutter run -d chrome
```

To build for production:

```bash
flutter build web --release
```

Output lands in `build/web/`.

---

## Deployment

Pushing to `main` triggers a GitHub Actions workflow that generates localization, builds the web bundle, cache-busts the resume PDF, pre-compresses static assets, and deploys to a self-hosted Linux server over rsync. Configuration lives in `.github/workflows/deploy.yml`.

---

## Credits

Built on the open-source [AladdineDev/portfolio](https://github.com/AladdineDev/portfolio) template, substantially restructured — new information architecture, redesigned sections, custom theming, and rewritten content model.

---

## License

MIT — see [LICENSE](LICENSE). Feel free to fork it for your own portfolio; a link back is appreciated but not required.

---

## About me

Senior Flutter engineer, 11 years in mobile. I specialise in offline-first architecture and conflict-free data synchronisation — apps that keep working when the network doesn't.

50+ apps shipped · 1M+ users · [9 packages on pub.dev](https://pub.dev/publishers/ehsanur.com/packages)

Open to remote Senior/Lead Flutter roles with US, UK and EU teams.

[ehsanur.com](https://ehsanur.com) · [LinkedIn](https://www.linkedin.com/in/sujit70777) · [mail@ehsanur.com](mailto:mail@ehsanur.com)
