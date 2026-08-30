<div align="center">

# ehsanur.com

**Portfolio site of Ehsanur Rahman — Senior Flutter Engineer, 11 years in mobile**

Built in Flutter Web. Data-driven, cache-safe, and deployed by a pipeline that survives a real production host.

<img src="web/og-preview.png" alt="ehsanur.com preview" width="640" />

**Live at [ehsanur.com](https://ehsanur.com)**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
[![Deploy](https://github.com/sujit70777/portfolio/actions/workflows/deploy.yml/badge.svg)](https://github.com/sujit70777/portfolio/actions/workflows/deploy.yml)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

</div>

---

## Why Flutter for a website

Most portfolio sites are React or static HTML. This one is Flutter Web on purpose: I build Flutter for a living, so the site is itself a working sample of the widget composition, theming and animation patterns I use in production apps.

The trade-offs were deliberate. A Flutter Web bundle is heavier than static HTML, and Flutter doesn't emit crawlable markup, so SEO needs explicit handling. For a site whose audience is technical — hiring managers, engineers, clients — both were worth paying.

---

## What's interesting in here

Everything below exists because it broke in practice, not because it looked good in a design doc.

**The resume PDF can't be served stale.** The deploy workflow stamps a content hash onto the resume's URL on every build. A re-uploaded resume is never cached by a browser, an ISP proxy, or the host itself — and no manual purge is needed.

**The service worker self-destructs.** Instead of caching the app for offline use — and stranding returning visitors on a stale build — it unregisters on activate and forces a clean reload.

**Static assets are pre-compressed in CI, not at request time.** The shared host's on-the-fly compression is slow and capped well below Brotli's ratio, so `.br` and `.gz` siblings are built once and served through an `.htaccess` rewrite.

**Icons survive font tree-shaking.** FontAwesome glyphs referenced only from JSON content arrive as runtime strings, not compile-time `const IconData`, so Flutter's icon tree-shaker can't see them and strips them from the build. The codepoint whitelist in `lib/src/common/widgets/icon.dart` keeps them.

---

## Features

- **Fully data-driven** — every piece of content lives in one JSON file; adding a project or updating experience takes no code changes
- **Multi-storefront links** — a project shipped to both stores renders both buttons, labelled and iconed from its `platform` tag, plus a cross-platform badge on the card
- **Responsive** — separate desktop, tablet and mobile layouts
- **Light and dark themes**
- **SEO-aware** — meta tags, Open Graph and Twitter cards rendered directly in `web/index.html`
- **Multi-platform** — the same codebase builds for web, Android, iOS, macOS, Windows and Linux
- **Automated deploy** — a push to `main` builds, cache-busts, pre-compresses and ships

---

## Editing content

Everything visible on the site comes from a single file:

```
assets/translations/en.json
```

Profile summary, skills, experience, projects and contact links all live there.

> [!IMPORTANT]
> Editing that file alone does **nothing**. It's compiled into `lib/src/localization/generated/*.g.dart` at build time by `easy_localization`, and the generated copy is what the app actually reads. Regenerate after every edit:
> ```bash
> make localization
> ```
> CI runs this too, so a push is always safe — but a local `flutter run` or `flutter build` will silently show stale content until you do.

A project entry:

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

Shipped to more than one store? Add `links`. Each entry's `platform` — `ios`, `android`, `web`, `github` or `pubdev` — drives that button's label and icon in the project modal, and a project with both `ios` and `android` picks up a platform badge on its card:

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

## Project structure

```
lib/                    Application code
assets/
  translations/         Content — en.json drives the whole site
  icons/                Tech and platform icons
  images/               Project screenshots
web/
  assets/documents/     Resume PDF (a static file, not a bundled asset —
                        see the note in pubspec.yaml)
  index.html            Web entry point, meta tags, favicons
  .htaccess             Cache-control, compression and MIME rules
.github/workflows/      Build and deploy pipeline
test/                   Widget tests
```

---

## Running locally

Requires the Flutter SDK on the stable channel.

```bash
git clone https://github.com/sujit70777/portfolio.git
cd portfolio

flutter pub get
make localization       # compiles assets/translations/en.json into Dart
flutter run -d chrome
```

Production build:

```bash
flutter build web --release   # output lands in build/web/
```

---

## Deployment

A push to `main` triggers a GitHub Actions workflow that generates localization, builds the web bundle, cache-busts the resume PDF, pre-compresses static assets, and rsyncs the result to a self-hosted Linux server. The pipeline is in `.github/workflows/deploy.yml`.

---

## Credits and license

Built on the open-source [AladdineDev/portfolio](https://github.com/AladdineDev/portfolio) template and substantially restructured — new information architecture, redesigned sections, custom theming, rewritten content model.

MIT licensed, see [LICENSE](LICENSE). Fork it for your own portfolio; a link back is appreciated, not required.

---

## About me

Senior Flutter engineer, 11 years in mobile. I specialise in offline-first architecture and conflict-free data synchronisation — apps that keep working when the network doesn't. Most recently I've led mobile teams as sole developer end to end: architecture, implementation, release and store delivery.

**50+ apps shipped · 1M+ users · [9 packages on pub.dev](https://pub.dev/publishers/ehsanur.com/packages)**

Available for remote Senior/Lead Flutter roles, full-time or contract, with US, UK and EU teams.

[ehsanur.com](https://ehsanur.com) · [LinkedIn](https://www.linkedin.com/in/sujit70777) · [mail@ehsanur.com](mailto:mail@ehsanur.com)
