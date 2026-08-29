# ehsanur.com — Portfolio

My personal portfolio site, built with Flutter Web and deployed to a self-hosted Linux server via GitHub Actions.

**Live at [ehsanur.com](https://ehsanur.com)**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

---

## Why Flutter for a website

Most portfolio sites are React or plain HTML. I built this in Flutter Web deliberately — I'm a Flutter engineer, so the site itself is a working sample of what I do. It also let me reuse the same widget composition, theming and animation patterns I use in production mobile apps.

Trade-offs I accepted: a heavier initial payload than a static site, and SEO that needs explicit handling (see below). Both were worth it for a site whose audience is technical.

---

## Features

- **Fully data-driven** — all content lives in a single JSON file; no code changes needed to add a project or update experience
- **Responsive** — desktop, tablet and mobile layouts
- **Light/dark themes**
- **SEO-aware** — meta tags, Open Graph and Twitter cards rendered in `web/index.html`, since Flutter Web doesn't emit crawlable markup by default
- **Multi-platform** — the same codebase builds for web, Android, iOS, macOS, Windows and Linux
- **Automated deploy** — push to `main` builds and ships to production

---

## Editing content

Everything visible on the site comes from one file:

```
assets/translations/en.json
```

It contains the profile summary, skills, experience, projects and contact links. Update the JSON, push, and the deploy pipeline handles the rest — no Dart changes required.

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

---

## Project structure

```
lib/                    Application code
assets/
  translations/         Content — en.json drives the whole site
  icons/                Tech and platform icons
  images/               Project screenshots
  documents/            Resume PDF
web/                    Web entry point, meta tags, favicons
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
flutter run -d chrome
```

To build for production:

```bash
flutter build web --release
```

Output lands in `build/web/`.

---

## Deployment

Pushing to `main` triggers a GitHub Actions workflow that builds the web bundle and deploys it to my Linux server. Configuration lives in `.github/workflows/`.

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
