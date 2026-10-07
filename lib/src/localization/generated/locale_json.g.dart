// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _en = {
  "name": "Shekh Ehsanur Rahman",
  "description": "Senior Flutter Engineer · Native iOS · Android · macOS. I take on the problems that block a product, and build with AI coding agents",
  "subDescription": "Flutter architecture · Custom plugins & native integration · Offline-first sync · Payments & subscriptions · Native iOS, Android and macOS",
  "heroPrimaryCta": "Email me",
  "heroSecondaryCta": "WhatsApp",
  "availabilityBadge": "Available now · Remote from Bangladesh · No sponsorship required",
  "contractBadge": "Full-time or contract · Works with any time zone; flexible core overlap hours",
  "stats": {
    "years": "11",
    "yearsLabel": "Years shipping",
    "apps": "50+",
    "appsLabel": "Apps worked on",
    "users": "1M+",
    "usersLabel": "Combined user reach",
    "rating": "100K+",
    "ratingLabel": "Downloads each, two EdTech apps"
  },
  "contacts": [
    {
      "tooltip": "Github",
      "url": "https://github.com/sujit70777",
      "icon": {
        "assetName": "assets/icons/other/github.svg"
      }
    },
    {
      "tooltip": "LinkedIn",
      "url": "https://www.linkedin.com/in/sujit70777",
      "icon": {
        "assetName": "assets/icons/other/linkedin.svg"
      }
    },
    {
      "tooltip": "ehsanur.com",
      "url": "https://ehsanur.com",
      "icon": {
        "assetName": "assets/icons/other/globe.svg"
      }
    },
    {
      "tooltip": "mail@ehsanur.com",
      "url": "mailto:mail@ehsanur.com",
      "icon": {
        "assetName": "assets/icons/other/mail.svg"
      }
    },
    {
      "tooltip": "WhatsApp: +880 1747-931646",
      "url": "https://wa.me/8801747931646",
      "icon": {
        "assetName": "assets/icons/other/whatsapp.svg"
      }
    },
    {
      "tooltip": "App Store",
      "url": "https://apps.apple.com/us/developer/shekh-ehsanur-rahman/id1892682672",
      "icon": {
        "assetName": "assets/icons/other/app-store.svg"
      }
    },
    {
      "tooltip": "Google Play — Devxhub",
      "url": "https://play.google.com/store/apps/dev?id=4646660586516176141",
      "icon": {
        "assetName": "assets/icons/other/google-play.svg"
      }
    },
    {
      "tooltip": "Google Play — Prabartan",
      "url": "https://play.google.com/store/apps/dev?id=6504002943007145339",
      "icon": {
        "assetName": "assets/icons/other/google-play.svg"
      }
    },
    {
      "tooltip": "pub.dev — ehsanur.com",
      "url": "https://pub.dev/publishers/ehsanur.com/packages",
      "icon": {
        "assetName": "assets/icons/other/dart.svg"
      }
    },
    {
      "tooltip": "pub.dev — devxhub.com",
      "url": "https://pub.dev/publishers/devxhub.com/packages",
      "icon": {
        "assetName": "assets/icons/other/dart.svg"
      }
    }
  ],
  "resumes": [
    {
      "languageCode": "en",
      "language": "English",
      "url": "assets/documents/resume.pdf"
    }
  ],
  "aboutDescription": "I take on the mobile problems that block a product: offline data that must not be lost, payments that must reconcile across Apple and Stripe, platform edge cases, and slow components that need a native rewrite.\n\nI'm a senior Flutter engineer — 7 years of Flutter inside 11 years of shipping mobile apps — with native iOS, Android and macOS (Swift, SwiftUI, Kotlin). When a package can't do the job, I write the plugin or platform channel myself, and I've published 9 Flutter packages on pub.dev. I'm based in Bangladesh and don't need relocation or visa sponsorship to work remotely.\n\nA few problems I've solved:\n\n→ Prayer times that were wrong at high latitudes. A prayer-times app showed wrong times to users in far-northern cities, and earlier fixes hadn't worked. I traced it to the sunrise and sunset calculation and built a new offline engine, verified against a real local schedule. It works with or without internet.\n\n→ A receipt scanner too slow for the business. For an expense-reimbursement FinTech platform, I replaced a generic Flutter scanner with a native one (Swift on iOS, Java on Android) that reads a QR code or barcode in about half a second. Live verification progress replaced the spinner, claims save offline and sync later, and a reimbursement completes in about 5–10 seconds.\n\n→ Two payment systems that disagreed. A subscription app sold through Stripe on Android and Apple In-App Purchase on iOS, and the two produced duplicate purchases and mismatched accounts. As team lead I redesigned the entitlement model so both map to one account. After about two years stuck in development, the app was approved and live within about a month.\n\n→ Learning that works offline. I led a 6-developer team building offline-first learning apps (Python, CSE, ML) as free + one-time Pro editions on Google Play and the App Store; two free apps each passed 100,000 downloads.\n\n→ Lawyers losing billable hours. I built Hourwise alone and shipped it to the Mac App Store. It records work passively and learns, on the Mac itself, which client each piece of work belongs to.\n\nWhat I can do for your team: make your app work offline without losing data, fix payments and subscriptions across Stripe, Apple and Google, get a stalled app through store review, and add on-device machine learning that keeps user data private.\n\nHow I work: I own the problem, the architecture and the code review; AI coding agents write much of the code; tests and automated releases keep quality up. I've worked an overseas team's hours for three years.\n\nOpen to: Senior Flutter Engineer, Senior Flutter Developer, Lead Flutter Developer, Mobile Tech Lead. Full-time or contract.",
  "skillCategories": [
    {
      "category": "Offline-First & Data Sync",
      "skills": [
        "Offline-First Architecture",
        "CRDT & Conflict Resolution",
        "Local-First Data Layers",
        "Firebase / SQLite Sync",
        "Background Sync & Retry Queues"
      ]
    },
    {
      "category": "Flutter & Native",
      "skills": [
        "Flutter & Dart (7 years)",
        "Flutter Architecture (Clean Architecture, BLoC, Riverpod)",
        "Custom Plugins & Platform Channels",
        "Flutter Package Development (9 on pub.dev)",
        "Native iOS / SwiftUI",
        "Native macOS / AppKit",
        "Native Android / Kotlin"
      ]
    },
    {
      "category": "AI",
      "skills": [
        "AI-Assisted Development (Claude Code)",
        "On-Device Machine Learning (live)",
        "On-Device Classification",
        "Apple Foundation Models (in progress)"
      ]
    },
    {
      "category": "Languages & State Management",
      "skills": [
        "Dart",
        "Swift",
        "Kotlin",
        "Java",
        "BLoC",
        "Riverpod",
        "Jetpack Compose"
      ]
    },
    {
      "category": "Backend & Data",
      "skills": [
        "Firebase (Firestore, Auth, Functions, Crashlytics)",
        "REST APIs & WebSockets",
        "Supabase",
        "SQLite / Drift / GRDB"
      ]
    },
    {
      "category": "Quality & Delivery",
      "skills": [
        "Unit / Widget / Integration Testing",
        "CI/CD Pipelines",
        "Fastlane",
        "GitHub Actions",
        "Git & Code Review",
        "App Store & Play Release Management"
      ]
    },
    {
      "category": "Leadership & Collaboration",
      "skills": [
        "Team Leadership (6 developers)",
        "Code Review Standards",
        "Technical Mentoring (200+ trained)",
        "Async, Distributed Team Collaboration"
      ]
    }
  ],
  "experiences": [
    {
      "role": "Founder & Senior Mobile Engineer",
      "company": "Hourwise Labs",
      "description": "Solo lawyers lose billable time because they forget timers and rebuild their day from memory. I built Hourwise alone — with AI coding agents under my review — from design to Mac App Store release.\n\n• Passive time capture in a native macOS menu-bar app (SwiftUI + AppKit, ~17k lines of Swift).\n• On-device machine learning, live today: a rule engine plus a naive-Bayes classifier that learns from each user's corrections and assigns work to the right client matter. Work history never leaves the Mac.\n• Local-first SQLite/GRDB storage; PDF invoices plus LEDES 1998B, QuickBooks, Xero, XLSX and CSV exports; StoreKit 2 subscriptions.\n• In progress: on-device AI billing narratives with Apple Foundation Models.",
      "url": "https://ehsanur.com/hourwise/",
      "isPresent": true,
      "startYear": 2026,
      "startMonth": 9,
      "technologies": [
        {
          "name": "Swift",
          "icon": {
            "assetName": "assets/icons/other/swift.svg"
          }
        },
        {
          "name": "SwiftUI",
          "icon": {
            "assetName": "assets/icons/other/swift.svg"
          }
        },
        {
          "name": "macOS",
          "icon": {
            "assetName": "assets/icons/other/apple.svg"
          }
        },
        {
          "name": "SQLite / GRDB",
          "icon": {
            "assetName": "assets/icons/other/sqlite.svg"
          }
        },
        {
          "name": "Apple Foundation Models",
          "icon": {
            "assetName": "assets/icons/other/app-store.svg"
          }
        },
        {
          "name": "StoreKit 2",
          "icon": {
            "assetName": "assets/icons/other/app-store.svg"
          }
        },
        {
          "name": "PDFKit",
          "icon": {
            "assetName": "assets/icons/other/app-store.svg"
          }
        },
        {
          "name": "EventKit",
          "icon": {
            "assetName": "assets/icons/other/app-store.svg"
          }
        },
        {
          "name": "On-Device Machine Learning",
          "icon": {
            "assetName": "assets/icons/other/app-store.svg"
          }
        },
        {
          "name": "Claude Code",
          "icon": {
            "assetName": "assets/icons/software-development/claude-code.svg"
          }
        }
      ],
      "links": [
        {
          "url": "https://apps.apple.com/us/app/hourwise-billable-hours/id6811420308?mt=12",
          "label": "Mac App Store"
        },
        {
          "url": "https://ehsanur.com/hourwise/",
          "label": "Hourwise"
        },
        {
          "url": "https://www.linkedin.com/company/hourwise-labs",
          "label": "LinkedIn"
        },
        {
          "url": "https://www.facebook.com/profile.php?id=61595186930630",
          "label": "Facebook"
        }
      ]
    },
    {
      "role": "Senior Mobile Developer — Level III",
      "company": "Developer eXperience Hub (Devxhub)",
      "description": "Team lead and mobile lead on client products in FinTech, subscriptions, marketplaces and consumer apps, in Flutter with native iOS and Android code.\n\n• Expense-reimbursement FinTech platform: replaced a generic Flutter scanner with a native one (Swift/iOS, Java/Android) that reads QR codes and barcodes in about 0.5 s; added live WebSocket verification progress, offline claims with later sync, and instant payout — reimbursement in about 5–10 s after a scan.\n• Expense and FinTech apps (50,000+ users): local-first sync with deterministic conflict resolution, so claims made without signal survive and recurring sync issues dropped.\n• Prayer-times app: after earlier attempts failed, traced wrong times at high latitudes to the sunrise/sunset calculation and built a new offline engine, verified against a real local schedule.\n• Subscription app: as team lead, redesigned the account-level entitlement model so Stripe and Apple In-App Purchase stay in sync; App Store approval about a month after stabilization began, following about two years in development.\n• Multi-service marketplace: merged separate provider and customer apps into one super app. Team lead and sole mobile developer.\n• Release time from about 1 hour to 10–20 minutes with Fastlane + GitHub Actions.\n• Introduced Claude Code with code review and tests required on every merge.",
      "url": "https://devxhub.com",
      "isPresent": false,
      "startYear": 2023,
      "startMonth": 9,
      "endYear": 2026,
      "endMonth": 9,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Swift",
          "icon": {
            "assetName": "assets/icons/other/swift.svg"
          }
        },
        {
          "name": "Kotlin",
          "icon": {
            "assetName": "assets/icons/other/kotlin.svg"
          }
        },
        {
          "name": "SwiftUI",
          "icon": {
            "assetName": "assets/icons/other/swift.svg"
          }
        },
        {
          "name": "Jetpack Compose",
          "icon": {
            "assetName": "assets/icons/other/jetpack-compose.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Firebase",
          "icon": {
            "assetName": "assets/icons/other/firebase.svg"
          }
        },
        {
          "name": "Riverpod",
          "icon": {
            "assetName": "assets/icons/software-development/riverpod.svg"
          }
        },
        {
          "name": "Bloc",
          "icon": {
            "assetName": "assets/icons/software-development/bloc.svg"
          }
        },
        {
          "name": "SQLite / Drift",
          "icon": {
            "assetName": "assets/icons/other/sqlite.svg"
          }
        },
        {
          "name": "Fastlane",
          "icon": {
            "assetName": "assets/icons/software-development/fastlane.svg"
          }
        },
        {
          "name": "GitHub Actions",
          "icon": {
            "assetName": "assets/icons/software-development/github-actions.svg"
          }
        },
        {
          "name": "Claude Code",
          "icon": {
            "assetName": "assets/icons/software-development/claude-code.svg"
          }
        },
        {
          "name": "WebSockets",
          "icon": {
            "assetName": "assets/icons/other/websockets.svg"
          }
        },
        {
          "name": "REST APIs",
          "icon": {
            "assetName": "assets/icons/other/rest-api.svg"
          }
        },
        {
          "name": "StoreKit 2",
          "icon": {
            "assetName": "assets/icons/other/app-store.svg"
          }
        },
        {
          "name": "Apple Pay",
          "icon": {
            "assetName": "assets/icons/other/apple-pay.svg"
          }
        },
        {
          "name": "Stripe",
          "icon": {
            "assetName": "assets/icons/other/stripe.svg"
          }
        }
      ],
      "links": [
        {
          "url": "https://devxhub.com",
          "label": "Devxhub"
        }
      ]
    },
    {
      "role": "Senior Mobile Application Developer",
      "company": "Prabartan Information Technology",
      "description": "• Led a 6-developer team building offline-first learning apps (Python, CSE, ML & AI) for students on weak or no internet.\n• Built the Firebase/SQLite sync layer and fixed sync-conflict edge cases.\n• Shipped each product as free + one-time Pro on Google Play and the App Store; two free apps each passed 100,000 downloads.\n• Modernised the stack (Flutter 3, Jetpack Compose, SwiftUI) and introduced code review standards.",
      "isPresent": false,
      "startYear": 2019,
      "startMonth": 6,
      "endYear": 2023,
      "endMonth": 8,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Firebase",
          "icon": {
            "assetName": "assets/icons/other/firebase.svg"
          }
        },
        {
          "name": "Android",
          "icon": {
            "assetName": "assets/icons/other/android.svg"
          }
        }
      ]
    },
    {
      "role": "Android Application Developer",
      "company": "Blue Hills Information Technology",
      "description": "Part-time through 04/2017 while completing my Computer Science degree, full-time thereafter. Co-developed consumer Android applications reaching 500,000+ combined downloads and a top-10 ranking in the Education category on Google Play. Improved launch performance and reduced production defects through systematic profiling and code review practices.",
      "isPresent": false,
      "startYear": 2015,
      "startMonth": 7,
      "endYear": 2019,
      "endMonth": 5,
      "technologies": [
        {
          "name": "Android",
          "icon": {
            "assetName": "assets/icons/other/android.svg"
          }
        },
        {
          "name": "Java",
          "icon": {
            "assetName": "assets/icons/other/java.svg"
          }
        }
      ]
    },
    {
      "role": "Guest Trainer, Mobile App Development (Contract)",
      "company": "NACTAR",
      "description": "Contract guest trainer, 2–3 sessions per year. Designed and delivered mobile development curriculum to 200+ developers, with hands-on project mentorship aligned to Android and Flutter certification standards.",
      "isPresent": false,
      "startYear": 2016,
      "startMonth": 5,
      "endYear": 2024,
      "endMonth": 8,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Android",
          "icon": {
            "assetName": "assets/icons/other/android.svg"
          }
        },
        {
          "name": "Java",
          "icon": {
            "assetName": "assets/icons/other/java.svg"
          }
        }
      ]
    }
  ],
  "present": "Present",
  "projects": [
    {
      "name": "Hourwise",
      "description": "Case study: lawyers lose billable hours to forgotten timers. Hourwise records work passively and learns on the Mac which client each piece of work belongs to. Live on the Mac App Store.",
      "role": "Founder and sole engineer — product, native macOS architecture, UI design, App Store release and launch.",
      "url": "https://apps.apple.com/us/app/hourwise-billable-hours/id6811420308?mt=12",
      "icon": {
        "assetName": "assets/icons/other/apple.svg"
      },
      "status": "shipped",
      "featured": true,
      "flagship": true,
      "highlights": [
        "Problem: Solo lawyers forget timers and rebuild their day from memory; many won't put client work into a cloud tool.",
        "What I did: Designed and built a native SwiftUI + AppKit menu-bar app alone: passive capture, a rule engine plus naive-Bayes classifier that learns from corrections on-device, local-first SQLite/GRDB, PDF invoices and LEDES 1998B / QuickBooks / Xero exports, StoreKit 2.",
        "Result: Approved and live on the Mac App Store; on-device AI billing narratives are in progress."
      ],
      "technologies": [
        {
          "name": "Swift",
          "icon": {
            "assetName": "assets/icons/other/swift.svg"
          }
        },
        {
          "name": "SwiftUI",
          "icon": {
            "assetName": "assets/icons/other/swift.svg"
          }
        },
        {
          "name": "AppKit",
          "icon": {
            "assetName": "assets/icons/other/apple.svg"
          }
        },
        {
          "name": "macOS",
          "icon": {
            "assetName": "assets/icons/other/apple.svg"
          }
        },
        {
          "name": "SQLite / GRDB",
          "icon": {
            "assetName": "assets/icons/other/sqlite.svg"
          }
        },
        {
          "name": "StoreKit 2",
          "icon": {
            "assetName": "assets/icons/other/app-store.svg"
          }
        },
        {
          "name": "EventKit"
        },
        {
          "name": "PDFKit"
        }
      ],
      "links": [
        {
          "label": "Mac App Store",
          "url": "https://apps.apple.com/us/app/hourwise-billable-hours/id6811420308?mt=12",
          "platform": "ios"
        },
        {
          "label": "Product site",
          "url": "https://ehsanur.com/hourwise/",
          "platform": "web"
        }
      ]
    },
    {
      "name": "Prayer-Times App — High-Latitude Engine",
      "description": "Case study: prayer times that were wrong at high latitudes — fixed with a new offline engine.",
      "role": "Team lead and sole developer — owned architecture, implementation, release and store delivery end to end.",
      "url": "https://apps.apple.com/us/app/muslim-times-pro-prayer-quran/id6740039144",
      "icon": {
        "assetName": "assets/icons/other/app-store.svg"
      },
      "status": "shipped",
      "featured": true,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Android",
          "icon": {
            "assetName": "assets/icons/other/android.svg"
          }
        },
        {
          "name": "iOS",
          "icon": {
            "assetName": "assets/icons/other/apple.svg"
          }
        },
        {
          "name": "SQLite",
          "icon": {
            "assetName": "assets/icons/other/sqlite.svg"
          }
        },
        {
          "name": "Firebase",
          "icon": {
            "assetName": "assets/icons/other/firebase.svg"
          }
        }
      ],
      "links": [
        {
          "label": "App Store",
          "url": "https://apps.apple.com/us/app/muslim-times-pro-prayer-quran/id6740039144",
          "platform": "ios"
        },
        {
          "label": "Google Play",
          "url": "https://play.google.com/store/apps/details?id=com.devxhub.muslimtimespro",
          "platform": "android"
        }
      ],
      "highlights": [
        "Problem: Users in far-northern cities saw prayer times that didn't match the schedule they actually followed, and earlier fixes hadn't worked.",
        "What I did: Traced the error to the sunrise and sunset calculation at high latitudes, built a new offline prayer-time engine, and checked it against a real local schedule. Added offline location and time-zone data for 30+ countries with manual location selection.",
        "Result: Correct times where they were wrong before, online or fully offline. Engine published as flutter_prayer_time_calculator."
      ]
    },
    {
      "name": "FinTech Reimbursement — Native Scanner",
      "description": "Case study: a half-second native receipt scanner for an expense-reimbursement FinTech platform.",
      "role": "Led delivery at Devxhub — Flutter app, offline-first sync architecture, SEFAZ tax-agency integration.",
      "url": "https://pub.dev/packages/flutter_scanner_devxhub",
      "icon": {
        "assetName": "assets/icons/software-development/flutter.svg",
        "color": "0xffffffff"
      },
      "status": "shipped",
      "featured": true,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Android",
          "icon": {
            "assetName": "assets/icons/other/android.svg"
          }
        },
        {
          "name": "Kotlin",
          "icon": {
            "assetName": "assets/icons/other/kotlin.svg"
          }
        },
        {
          "name": "Swift",
          "icon": {
            "assetName": "assets/icons/other/swift.svg"
          }
        },
        {
          "name": "iOS",
          "icon": {
            "assetName": "assets/icons/other/apple.svg"
          }
        },
        {
          "name": "SQLite",
          "icon": {
            "assetName": "assets/icons/other/sqlite.svg"
          }
        },
        {
          "name": "Firebase",
          "icon": {
            "assetName": "assets/icons/other/firebase.svg"
          }
        }
      ],
      "links": [],
      "highlights": [
        "Problem: Reimbursement depended on scanning the QR code or barcode on each receipt. The generic Flutter scanner was too slow and couldn't be customized, and users stared at a spinner during verification.",
        "What I did: Built a native scanner (Swift on iOS, Java on Android) behind a Flutter interface, streamed verification progress over WebSockets as a live progress bar, let claims save offline and sync later, and paid out instantly. Later published as flutter_scanner_devxhub.",
        "Result: Codes recognized in about 0.5 s; a successful reimbursement completes in about 5–10 s after the scan."
      ]
    },
    {
      "name": "Offline-First Learning Apps",
      "description": "Case study: three offline learning products (Python, CSE, ML & AI) shipped as free + one-time Pro editions on Google Play and the App Store.",
      "role": "Led development at Prabartan Information Technology and now maintained and published under my developer account — Flutter, Jetpack Compose, SwiftUI; Firebase/SQLite sync layer; free + Pro listings on Android and iOS.",
      "url": "https://play.google.com/store/apps/dev?id=6504002943007145339",
      "icon": {
        "assetName": "assets/icons/other/google-play.svg"
      },
      "status": "shipped",
      "featured": true,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Android",
          "icon": {
            "assetName": "assets/icons/other/android.svg"
          }
        },
        {
          "name": "Kotlin",
          "icon": {
            "assetName": "assets/icons/other/kotlin.svg"
          }
        },
        {
          "name": "iOS",
          "icon": {
            "assetName": "assets/icons/other/apple.svg"
          }
        },
        {
          "name": "Swift",
          "icon": {
            "assetName": "assets/icons/other/swift.svg"
          }
        },
        {
          "name": "Firebase",
          "icon": {
            "assetName": "assets/icons/other/firebase.svg"
          }
        },
        {
          "name": "SQLite",
          "icon": {
            "assetName": "assets/icons/other/sqlite.svg"
          }
        }
      ],
      "links": [
        {
          "label": "Google Play",
          "url": "https://play.google.com/store/apps/dev?id=6504002943007145339",
          "platform": "android"
        },
        {
          "label": "App Store",
          "url": "https://apps.apple.com/us/developer/shekh-ehsanur-rahman/id1892682672",
          "platform": "ios"
        }
      ],
      "highlights": [
        "Problem: Students on poor connections lost lessons and progress when the network dropped.",
        "What I did: Led a 6-developer team; built the Firebase/SQLite sync layer; shipped three products (Python, CSE, ML) as free + one-time Pro on Google Play and the App Store.",
        "Result: two free apps each passed 100,000 downloads; free and Pro editions live on both stores."
      ]
    },
    {
      "name": "Subscription App — Stripe + Apple Entitlements",
      "description": "Case study: one entitlement model for Stripe and Apple In-App Purchase — a two-year-stalled subscription app launched in a month.",
      "role": "Team lead and sole developer — Flutter app with the native iOS layer built solo, including StoreKit 2 subscriptions, App Store submission and compliance.",
      "url": "https://apps.apple.com/us/app/pom-app/id6760588055",
      "icon": {
        "assetName": "assets/icons/other/app-store.svg"
      },
      "status": "shipped",
      "featured": true,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Swift",
          "icon": {
            "assetName": "assets/icons/other/swift.svg"
          }
        },
        {
          "name": "iOS",
          "icon": {
            "assetName": "assets/icons/other/apple.svg"
          }
        },
        {
          "name": "StoreKit",
          "icon": {
            "assetName": "assets/icons/other/app-store.svg"
          }
        },
        {
          "name": "Apple Pay",
          "icon": {
            "assetName": "assets/icons/other/apple-pay.svg"
          }
        }
      ],
      "links": [
        {
          "label": "App Store",
          "url": "https://apps.apple.com/us/app/pom-app/id6760588055",
          "platform": "ios"
        },
        {
          "label": "Google Play",
          "url": "https://play.google.com/store/apps/details?id=com.peaceofmind.app",
          "platform": "android"
        }
      ],
      "highlights": [
        "Problem: Android paid through Stripe and iOS through Apple In-App Purchase. Apple records purchases per Apple ID, not per app account, so accounts and payments fell out of sync: duplicate purchases, upgrades billed in full, access on the wrong account.",
        "What I did: As team lead, redesigned the payment and entitlement architecture with the backend developer: one account-level entitlement both payment systems map into, duplicate-purchase detection, reconciliation of existing records, correct StoreKit purchase states.",
        "Result: App Store approval and launch about a month after stabilization began, following about two years in development."
      ]
    },
    {
      "name": "Multi-Service Super App",
      "description": "Case study: two separate apps merged into one multi-service super app.",
      "role": "Team lead and sole developer — owned architecture, implementation, release and delivery end to end across ride-hailing, delivery, bookings, and marketplace modules.",
      "url": "https://apps.apple.com/us/app/farenow/id1638701755",
      "icon": {
        "assetName": "assets/icons/other/google-play.svg"
      },
      "status": "shipped",
      "featured": true,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Android",
          "icon": {
            "assetName": "assets/icons/other/android.svg"
          }
        },
        {
          "name": "Kotlin",
          "icon": {
            "assetName": "assets/icons/other/kotlin.svg"
          }
        },
        {
          "name": "Swift",
          "icon": {
            "assetName": "assets/icons/other/swift.svg"
          }
        },
        {
          "name": "iOS",
          "icon": {
            "assetName": "assets/icons/other/apple.svg"
          }
        },
        {
          "name": "Firebase",
          "icon": {
            "assetName": "assets/icons/other/firebase.svg"
          }
        }
      ],
      "links": [
        {
          "label": "App Store",
          "url": "https://apps.apple.com/us/app/farenow/id1638701755",
          "platform": "ios"
        },
        {
          "label": "Google Play",
          "url": "https://play.google.com/store/apps/details?id=com.app.farenow",
          "platform": "android"
        }
      ],
      "highlights": [
        "Problem: Providers and customers used separate apps, which made the product harder to use and grow as services were added.",
        "What I did: As team lead and sole mobile developer, designed one app with ride-hailing and live tracking, on-demand services, food and grocery delivery, virtual consultations and marketplace listings.",
        "Result: One app on both stores for every service."
      ]
    },
    {
      "name": "flutter_crdt_sync_kit",
      "description": "Pub.dev package for a common, costly bug: two devices edit the same data offline and one change silently overwrites the other. A CRDT-based local data layer that merges changes conflict-free on reconnect, with Supabase and REST adapters.",
      "role": "Sole developer and maintainer — open-source Flutter package.",
      "url": "https://pub.dev/packages/flutter_crdt_sync_kit",
      "icon": {
        "assetName": "assets/icons/other/cube.svg"
      },
      "status": "shipped",
      "featured": true,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Offline-First Architecture"
        },
        {
          "name": "Data Synchronization"
        },
        {
          "name": "Open Source"
        }
      ],
      "links": [
        {
          "label": "View on pub.dev",
          "url": "https://pub.dev/packages/flutter_crdt_sync_kit",
          "platform": "pubdev"
        }
      ]
    },
    {
      "name": "E-commerce Marketplace App",
      "description": "E-commerce marketplace for electronics, fashion, home goods, and daily essentials, with verified sellers, cashback rewards, and a social-impact model funding orphanages and sustainability initiatives.",
      "role": "Team lead and sole developer — owned architecture, implementation, release and store delivery end to end.",
      "url": "https://apps.apple.com/us/app/proofsell/id6755882846",
      "icon": {
        "assetName": "assets/icons/other/app-store.svg"
      },
      "status": "shipped",
      "featured": true,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Android",
          "icon": {
            "assetName": "assets/icons/other/android.svg"
          }
        },
        {
          "name": "iOS",
          "icon": {
            "assetName": "assets/icons/other/apple.svg"
          }
        },
        {
          "name": "Firebase",
          "icon": {
            "assetName": "assets/icons/other/firebase.svg"
          }
        }
      ],
      "links": [
        {
          "label": "App Store",
          "url": "https://apps.apple.com/us/app/proofsell/id6755882846",
          "platform": "ios"
        },
        {
          "label": "Google Play",
          "url": "https://play.google.com/store/apps/details?id=com.proofsell.customer",
          "platform": "android"
        }
      ]
    },
    {
      "name": "Forward SMS",
      "description": "Never miss an OTP or alert again: forwards SMS to email, Slack, Telegram and Discord, with offline queuing and custom filter rules.",
      "role": "Sole iOS developer — built and shipped independently.",
      "url": "https://apps.apple.com/us/app/forward-sms-sms-forwarder/id6759511643",
      "icon": {
        "assetName": "assets/icons/other/app-store.svg"
      },
      "status": "shipped",
      "featured": true,
      "technologies": [
        {
          "name": "Swift",
          "icon": {
            "assetName": "assets/icons/other/swift.svg"
          }
        },
        {
          "name": "iOS",
          "icon": {
            "assetName": "assets/icons/other/apple.svg"
          }
        },
        {
          "name": "StoreKit",
          "icon": {
            "assetName": "assets/icons/other/app-store.svg"
          }
        },
        {
          "name": "Automation"
        }
      ],
      "links": [
        {
          "label": "App Store",
          "url": "https://apps.apple.com/us/app/forward-sms-sms-forwarder/id6759511643",
          "platform": "ios"
        }
      ]
    },
    {
      "name": "flutter_a11y_lens",
      "description": "Pub.dev package. Accessibility bugs are found too late, by users or auditors. Inspects the running widget tree and flags WCAG violations live, with an on-screen overlay.",
      "role": "Sole developer and maintainer — open-source Flutter package.",
      "url": "https://pub.dev/packages/flutter_a11y_lens",
      "icon": {
        "assetName": "assets/icons/other/cube.svg"
      },
      "status": "shipped",
      "featured": false,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Accessibility"
        },
        {
          "name": "Open Source"
        }
      ],
      "links": [
        {
          "label": "View on pub.dev",
          "url": "https://pub.dev/packages/flutter_a11y_lens",
          "platform": "pubdev"
        }
      ]
    },
    {
      "name": "OMR Scanner",
      "description": "Grading paper answer sheets by hand is slow and error-prone. A fully offline scanner that aligns each sheet with registration marks and homography (no OCR), with live camera guidance, auto-capture and instant per-roll scoring.",
      "role": "Sole developer — personal project, in active development.",
      "url": "https://github.com/sujit70777/omr_scanner_flutter",
      "icon": {
        "assetName": "assets/icons/other/github.svg"
      },
      "status": "inDevelopment",
      "featured": false,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Computer Vision"
        },
        {
          "name": "Image Processing"
        },
        {
          "name": "Open Source"
        }
      ],
      "links": [
        {
          "label": "View on GitHub",
          "url": "https://github.com/sujit70777/omr_scanner_flutter",
          "platform": "github"
        }
      ]
    },
    {
      "name": "flutter_liquid_glass_widgets",
      "description": "Pub.dev package. UI kit implementing Apple's Liquid Glass design language: shader-powered blur, physics-based jelly animations, and dynamic lighting, across Android, iOS, web, and desktop.",
      "role": "Sole developer and Maintainer of a fork of an open-source Liquid Glass package (original author credited), with added widgets. — open-source Flutter package.",
      "url": "https://pub.dev/packages/flutter_liquid_glass_widgets",
      "icon": {
        "assetName": "assets/icons/other/cube.svg"
      },
      "status": "shipped",
      "featured": false,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "UI Design"
        },
        {
          "name": "Open Source"
        }
      ],
      "links": [
        {
          "label": "View on pub.dev",
          "url": "https://pub.dev/packages/flutter_liquid_glass_widgets",
          "platform": "pubdev"
        }
      ]
    },
    {
      "name": "local_voice",
      "description": "Pub.dev package. Voice commands that work with no internet, no cloud and no API keys — private by design and free per request.",
      "role": "Sole developer and maintainer — open-source Flutter package.",
      "url": "https://pub.dev/packages/local_voice",
      "icon": {
        "assetName": "assets/icons/other/cube.svg"
      },
      "status": "shipped",
      "featured": false,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "On-Device ML"
        },
        {
          "name": "Open Source"
        }
      ],
      "links": [
        {
          "label": "View on pub.dev",
          "url": "https://pub.dev/packages/local_voice",
          "platform": "pubdev"
        }
      ]
    },
    {
      "name": "Jatri — Bangladesh Transit App",
      "description": "GitHub project. Transit journey planner and ticketing app for Bangladesh built on real MRT Line 6 and BRTA bus route data: onboarding, home/tickets/routes shell, journey search, route results, itinerary detail, and ticket purchase flow. Routing and payments are UI-complete, not yet wired to live services.",
      "role": "Sole developer — personal project, in active development.",
      "url": "https://github.com/sujit70777/Jatri---Bangladesh-Transit-App",
      "icon": {
        "assetName": "assets/icons/other/github.svg"
      },
      "status": "inDevelopment",
      "featured": false,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Mapping"
        },
        {
          "name": "Open Source"
        }
      ],
      "links": [
        {
          "label": "View on GitHub",
          "url": "https://github.com/sujit70777/Jatri---Bangladesh-Transit-App",
          "platform": "github"
        }
      ]
    },
    {
      "name": "ar_measure",
      "description": "GitHub project. Cross-platform AR quick-measure plugin for Flutter — point the camera, tap to place anchors, and read live real-world distances and areas, wrapping ARKit and ARCore.",
      "role": "Sole developer — personal project, in active development.",
      "url": "https://github.com/sujit70777/ar_measure",
      "icon": {
        "assetName": "assets/icons/other/github.svg"
      },
      "status": "inDevelopment",
      "featured": false,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "ARKit",
          "icon": {
            "assetName": "assets/icons/other/apple.svg"
          }
        },
        {
          "name": "ARCore",
          "icon": {
            "assetName": "assets/icons/other/android.svg"
          }
        }
      ],
      "links": [
        {
          "label": "View on GitHub",
          "url": "https://github.com/sujit70777/ar_measure",
          "platform": "github"
        }
      ]
    },
    {
      "name": "Secure Video Course App",
      "description": "Secure educational platform for streaming enrolled course videos with screenshot and recording protection, progress tracking, and course search.",
      "role": "Team lead and sole developer — owned architecture, implementation, release and store delivery end to end.",
      "url": "https://apps.apple.com/us/app/sk-mobile-school/id6475169754",
      "icon": {
        "assetName": "assets/icons/other/app-store.svg"
      },
      "status": "shipped",
      "featured": false,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Android",
          "icon": {
            "assetName": "assets/icons/other/android.svg"
          }
        },
        {
          "name": "iOS",
          "icon": {
            "assetName": "assets/icons/other/apple.svg"
          }
        },
        {
          "name": "Firebase",
          "icon": {
            "assetName": "assets/icons/other/firebase.svg"
          }
        }
      ],
      "links": [
        {
          "label": "App Store",
          "url": "https://apps.apple.com/us/app/sk-mobile-school/id6475169754",
          "platform": "ios"
        },
        {
          "label": "Google Play",
          "url": "https://play.google.com/store/apps/details?id=com.devxhub.skmobileschool",
          "platform": "android"
        }
      ]
    },
    {
      "name": "Notes & Task Planner App",
      "description": "Notes, reminders, task planner, and calendar app with custom checklists, notifications, and cross-device cloud sync.",
      "role": "Team lead and sole developer — owned architecture, implementation, release and store delivery end to end.",
      "url": "https://apps.apple.com/us/app/notivio-notes-task-planner/id6748751923",
      "icon": {
        "assetName": "assets/icons/other/app-store.svg"
      },
      "status": "shipped",
      "featured": false,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Android",
          "icon": {
            "assetName": "assets/icons/other/android.svg"
          }
        },
        {
          "name": "iOS",
          "icon": {
            "assetName": "assets/icons/other/apple.svg"
          }
        }
      ],
      "links": [
        {
          "label": "App Store",
          "url": "https://apps.apple.com/us/app/notivio-notes-task-planner/id6748751923",
          "platform": "ios"
        },
        {
          "label": "Google Play",
          "url": "https://play.google.com/store/apps/details?id=com.devxhub.notivio",
          "platform": "android"
        }
      ]
    },
    {
      "name": "eSIM Data-Plan Marketplace",
      "description": "eSIM marketplace app for purchasing and managing mobile data plans.",
      "role": "Team lead and sole developer — owned architecture, implementation, release and store delivery end to end.",
      "url": "https://play.google.com/store/apps/details?id=com.esim247.app",
      "icon": {
        "assetName": "assets/icons/other/google-play.svg"
      },
      "status": "shipped",
      "featured": false,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Android",
          "icon": {
            "assetName": "assets/icons/other/android.svg"
          }
        },
        {
          "name": "iOS",
          "icon": {
            "assetName": "assets/icons/other/apple.svg"
          }
        },
        {
          "name": "Firebase",
          "icon": {
            "assetName": "assets/icons/other/firebase.svg"
          }
        }
      ],
      "links": [
        {
          "label": "Google Play",
          "url": "https://play.google.com/store/apps/details?id=com.esim247.app",
          "platform": "android"
        }
      ]
    },
    {
      "name": "flutter_fabric",
      "description": "Pub.dev package. A Flutter canvas library inspired by Fabric.js — selectable, draggable, scalable, and rotatable objects with free drawing, JSON serialization, and SVG path support.",
      "role": "Sole developer and maintainer — open-source Flutter package.",
      "url": "https://pub.dev/packages/flutter_fabric",
      "icon": {
        "assetName": "assets/icons/other/cube.svg"
      },
      "status": "shipped",
      "featured": false,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Open Source"
        }
      ],
      "links": [
        {
          "label": "View on pub.dev",
          "url": "https://pub.dev/packages/flutter_fabric",
          "platform": "pubdev"
        }
      ]
    },
    {
      "name": "flutter_scanner_devxhub",
      "description": "The native receipt scanner from the FinTech reimbursement project (Swift on iOS, Java on Android), extracted as a Flutter package.",
      "role": "Sole developer and maintainer — open-source Flutter package.",
      "url": "https://pub.dev/packages/flutter_scanner_devxhub",
      "icon": {
        "assetName": "assets/icons/other/cube.svg"
      },
      "status": "shipped",
      "featured": false,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Open Source"
        }
      ],
      "links": [
        {
          "label": "View on pub.dev",
          "url": "https://pub.dev/packages/flutter_scanner_devxhub",
          "platform": "pubdev"
        }
      ]
    },
    {
      "name": "flutter_zoom_image",
      "description": "Pub.dev package. Image zoom widgets for Flutter — standard pinch-to-zoom plus a deep-zoom (DZI tile pyramid) mode, sharing a common gesture and controller layer.",
      "role": "Sole developer and maintainer — open-source Flutter package.",
      "url": "https://pub.dev/packages/flutter_zoom_image",
      "icon": {
        "assetName": "assets/icons/other/cube.svg"
      },
      "status": "shipped",
      "featured": false,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Open Source"
        }
      ],
      "links": [
        {
          "label": "View on pub.dev",
          "url": "https://pub.dev/packages/flutter_zoom_image",
          "platform": "pubdev"
        }
      ]
    },
    {
      "name": "flutter_prayer_time_calculator",
      "description": "The high-latitude offline prayer-time engine, extracted as a Flutter package.",
      "role": "Sole developer and maintainer — open-source Flutter package.",
      "url": "https://pub.dev/packages/flutter_prayer_time_calculator",
      "icon": {
        "assetName": "assets/icons/other/cube.svg"
      },
      "status": "shipped",
      "featured": false,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Open Source"
        }
      ],
      "links": [
        {
          "label": "View on pub.dev",
          "url": "https://pub.dev/packages/flutter_prayer_time_calculator",
          "platform": "pubdev"
        }
      ]
    },
    {
      "name": "flutter_scroll_date_picker",
      "description": "Pub.dev package. A customizable, easy-to-use scroll date picker for Flutter, compatible with Android, iOS, and Web.",
      "role": "Sole developer and maintainer — open-source Flutter package.",
      "url": "https://pub.dev/packages/flutter_scroll_date_picker",
      "icon": {
        "assetName": "assets/icons/other/cube.svg"
      },
      "status": "shipped",
      "featured": false,
      "technologies": [
        {
          "name": "Flutter",
          "icon": {
            "assetName": "assets/icons/software-development/flutter.svg"
          }
        },
        {
          "name": "Dart",
          "icon": {
            "assetName": "assets/icons/other/dart.svg"
          }
        },
        {
          "name": "Open Source"
        }
      ],
      "links": [
        {
          "label": "View on pub.dev",
          "url": "https://pub.dev/packages/flutter_scroll_date_picker",
          "platform": "pubdev"
        }
      ]
    }
  ],
  "languages": [
    {
      "code": "en",
      "name": "English",
      "nativeName": "English",
      "icon": {
        "assetName": "assets/icons/flags/united-states-of-america.svg"
      }
    }
  ],
  "bottomBanner": {
    "message": "© 2026 Shekh Ehsanur Rahman —",
    "displayLink": "Try Hourwise for Mac",
    "linkUrl": "https://ehsanur.com/hourwise/"
  },
  "portfolio": "Shekh Ehsanur Rahman",
  "homeSectionTitle": "Home",
  "aboutSectionTitle": "About",
  "aboutSectionTitleAlt": "What I fix",
  "aboutLocationCaption": "Rajshahi, Bangladesh · UTC+6 · Remote",
  "skillsSectionTitle": "Skills",
  "experienceSectionTitle": "Experience",
  "projectsSectionTitle": "Problems I've solved",
  "resume": "Resume",
  "downloadResume": "Download Resume",
  "openUrlError": "Could not open the url",
  "unknownLanguageError": "Language unknown",
  "sectionEyebrowAbout": "About",
  "sectionEyebrowExperience": "Experience",
  "sectionEyebrowSkills": "Skills",
  "sectionEyebrowProjects": "Case studies",
  "projectsMoreLabel": "More projects",
  "siteUrl": "https://ehsanur.com/",
  "fitCheckSectionTitle": "Fit check",
  "sectionEyebrowFitCheck": "Fit check",
  "fitCheck": {
    "title": "Hiring for a specific role?",
    "intro": "Paste the job description or project brief. Each requirement is checked against the work on this page and linked to the role or project that shows it. Gaps are listed too.",
    "privacy": "Runs entirely in your browser. Nothing you paste is sent or stored.",
    "inputHint": "Paste a job description or project brief…",
    "checkButton": "Check fit",
    "sampleButton": "Try a sample",
    "clearButton": "Clear",
    "emailButton": "Email me about this role",
    "copySummaryButton": "Copy summary",
    "copiedSummary": "Summary copied. Paste it into your notes or send it to the hiring manager.",
    "emailSubject": "About a role: fit check from ehsanur.com",
    "notShown": "Not shown on this site. Happy to talk it through.",
    "listedOnly": "Listed skill",
    "alsoBrings": "Also brings",
    "nothingFound": "No recognisable mobile-engineering requirements found. Try pasting the full description, including the requirements list.",
    "tooShort": "Paste a little more of the description first.",
    "disclaimer": "Keyword-based and deterministic: it recognises common mobile-engineering skills and links only to evidence on this page. It won't read between the lines, so a gap here may just be something the site doesn't mention.",
    "sampleText": "Senior Mobile Engineer, Flutter (Remote)\n\nWe're a fintech startup building a payments app for 200,000 small businesses.\n\nWhat you'll do\n- Own features end to end, from architecture to App Store and Google Play release\n- Build offline-capable flows that sync reliably on poor networks\n- Lead code reviews and mentor two mid-level engineers\n\nRequirements\n- 5+ years of mobile development, 3+ years with Flutter and Dart\n- Strong state management experience (Riverpod or Bloc)\n- REST APIs and GraphQL\n- Firebase (Auth, Firestore, Crashlytics)\n- Unit, widget and integration testing; CI/CD with GitHub Actions or Codemagic\n- Comfortable dropping into native iOS (Swift) or Android (Kotlin) when a plugin is needed\n\nNice to have\n- In-app subscriptions (StoreKit / Play Billing)\n- Kotlin Multiplatform\n- Accessibility (WCAG) experience\n\nBenefits\n- Fully remote, health insurance, learning budget",
    "presetsHint": "Or pick a starting point:"
  },
  "copyEmail": "Copy email address",
  "emailCopied": "Email address copied",
  "emailOpening": "Opening your mail app. No mail app? Copy the address instead:",
  "copyProjectLink": "Copy link",
  "projectLinkCopied": "Link copied",
  "downloadOnePager": "One-pager",
  "onePagerUrl": "assets/documents/one-pager.pdf",
  "bookingUrl": "https://calendly.com/ehsanur/30min",
  "bookingLabel": "30-min intro call",
  "videoUrl": "",
  "videoCaption": "Who I am, two problems I've solved, and how to reach me.",
  "stickyAvailableLabel": "Available now",
  "stickyDismissLabel": "Dismiss",
  "stickyResumeLabel": "Resume",
  "stickyEmailLabel": "Email",
  "outcomes": [
    {
      "value": "~0.5 s",
      "label": "Native scanner reads QR / barcodes"
    },
    {
      "value": "4.7 Avg rating",
      "label": "App Store & Google Play ratings with 5K+ reviews"
    },
    {
      "value": "~1 mo",
      "label": "Stalled ~2 years → live after payment redesign"
    },
    {
      "value": "10–20 min",
      "label": "Releases, down from ~1 hour (Fastlane + Actions)"
    }
  ],
  "trustChips": [
    {
      "text": "FinTech · 50K+ users"
    },
    {
      "text": "EdTech · 2 apps past 100K downloads"
    },
    {
      "text": "Mac App Store · Hourwise"
    },
    {
      "text": "9 Flutter packages on pub.dev"
    }
  ],
  "trustBadgeLinks": [
    {
      "label": "App Store",
      "url": "https://apps.apple.com/us/developer/shekh-ehsanur-rahman/id1892682672",
      "iconAsset": "assets/icons/other/app-store.svg"
    },
    {
      "label": "Google Play",
      "url": "https://play.google.com/store/apps/dev?id=4646660586516176141",
      "iconAsset": "assets/icons/other/google-play.svg"
    },
    {
      "label": "pub.dev",
      "url": "https://pub.dev/publishers/ehsanur.com/packages",
      "iconAsset": "assets/icons/other/dart.svg"
    }
  ],
  "recruiterFit": {
    "title": "For recruiters & hiring managers",
    "targetRolesLabel": "Target roles",
    "targetRoles": "Senior Flutter Engineer · Senior Flutter Developer · Lead Flutter Developer · Mobile Tech Lead",
    "experienceLabel": "Experience",
    "experience": "11 years shipping mobile apps · 7 years of Flutter",
    "stackLabel": "Stack",
    "stack": "Flutter, Dart, Swift/SwiftUI, Kotlin, Firebase, offline-first sync, StoreKit 2 / Stripe",
    "locationLabel": "Location",
    "location": "Remote from Bangladesh · No relocation or visa sponsorship required",
    "timezoneLabel": "Time zone",
    "timezone": "Works with any time zone; flexible core overlap hours",
    "availabilityLabel": "Availability",
    "availability": "Available now",
    "engagementLabel": "Engagement",
    "engagement": "Full-time or contract",
    "resumeLabel": "Resume (PDF)",
    "onePagerLabel": "One-pager (PDF)",
    "emailLabel": "Email",
    "linkedinLabel": "LinkedIn"
  },
  "openSourcePackages": [
    {
      "name": "flutter_crdt_sync_kit",
      "blurb": "Merges offline edits from several devices without losing any.",
      "url": "https://pub.dev/packages/flutter_crdt_sync_kit"
    },
    {
      "name": "flutter_scanner_devxhub",
      "blurb": "Native receipt scanner behind Flutter (built at Devxhub, published under Devxhub).",
      "url": "https://pub.dev/packages/flutter_scanner_devxhub"
    },
    {
      "name": "flutter_a11y_lens",
      "blurb": "Live WCAG accessibility auditing in a running app.",
      "url": "https://pub.dev/packages/flutter_a11y_lens"
    },
    {
      "name": "flutter_fabric",
      "blurb": "Fabric.js-style interactive canvas: select, drag, scale and rotate objects, free drawing, JSON and SVG paths (published under Devxhub).",
      "url": "https://pub.dev/packages/flutter_fabric"
    },
    {
      "name": "flutter_zoom_image",
      "blurb": "Gesture zoom for standard images and deep-zoom (DZI) tile pyramids, on one shared controller (published under Devxhub).",
      "url": "https://pub.dev/packages/flutter_zoom_image"
    },
    {
      "name": "flutter_liquid_glass_widgets",
      "blurb": "iOS 26 Liquid Glass-style widget kit: shader-powered blur, jelly animations and dynamic lighting.",
      "url": "https://pub.dev/packages/flutter_liquid_glass_widgets"
    }
  ],
  "openSourceSectionTitle": "Open source",
  "sectionEyebrowOpenSource": "Open source",
  "notesSectionTitle": "Notes from production work",
  "sectionEyebrowNotes": "Notes",
  "videoSectionTitle": "Intro",
  "sectionEyebrowVideo": "Intro",
  "contractSectionTitle": "Contract work",
  "sectionEyebrowContract": "Contract work",
  "contractIntro": "For product teams that need a senior Flutter engineer on a clear, scoped problem. I can take ownership of the solution end to end, from architecture to App Store and Google Play release. I work with your team on a fixed-scope engagement, or as a contractor on a longer-term project.",
  "whoIHelpTitle": "Who I help",
  "engagementProcessTitle": "How an engagement works",
  "faqTitle": "FAQ",
  "notes": [
    {
      "slug": "prayer-times-high-latitude",
      "title": "Why prayer times break in the far north — and how I fixed them offline",
      "description": "Why standard prayer-time calculations go wrong at high latitudes, and how a new offline engine fixed a production app.",
      "tags": [
        "Flutter",
        "Dart",
        "offline-first",
        "algorithms"
      ],
      "body": "A prayer-times app looked correct almost everywhere. Then a user living in a far-northern city told us the times on his phone didn't match the schedule he actually prayed by. Other developers had already tried to fix it and couldn't. For a prayer app, one wrong time is enough to lose a user's trust.\n\n**Where the times come from.** Every prayer time is derived from the sun's position. Sunrise and sunset are the moments the sun's centre is about 0.833° below the horizon (that small offset covers atmospheric refraction and the sun's radius). Fajr and Isha are defined by deeper angles — typically 15° to 19.5° below the horizon, depending on the calculation method a community follows.\n\n**What changes in the far north.** Around 60° north and above, two things happen:\n\n1. In summer the sun never sinks deep enough. Near 60° N at midsummer it only reaches about 6–7° below the horizon, so an 18° Fajr or Isha angle simply has no answer.\n2. The sun crosses the horizon at a shallow slant. A tiny error in the angle becomes many minutes of error in the time.\n\nSunrise and sunset sit underneath everything else, so when they drift, every prayer built on them drifts too.\n\n**What I did.** I didn't patch individual cities. I traced the problem to the sunrise and sunset calculation, then replaced the app's calculation setup with our own engine:\n\n- fully offline — no API call for any prayer time\n- the standard calculation methods, plus high-latitude handling for the months when normal angles fail\n- offline location and time-zone data for 30+ countries, with manual location selection when GPS is off or permission is denied\n\n**How I knew it was right.** Numbers that \"look reasonable\" prove nothing. I compared the engine's output against the real local schedule followed by a person living there, and against a leading prayer app. The engine was later published as an open-source Flutter package.\n\n**What I took away:**\n\n- Your edge case is someone's daily life. Test where your users live, not where your developers sit.\n- When a bug survives several fixes, stop adjusting outputs and find the layer everything depends on.\n- Validate against reality, not against another formula."
    },
    {
      "slug": "native-scanner-behind-flutter",
      "title": "Rewriting a Flutter scanner natively: from a slow plugin to ~0.5 seconds",
      "description": "When a generic Flutter plugin is too slow, a native implementation behind a clean Flutter interface can fix speed and UX at once.",
      "tags": [
        "Flutter",
        "Swift",
        "Java",
        "platform channels",
        "FinTech"
      ],
      "body": "An expense-reimbursement app paid employees back after they scanned the QR code or barcode on a receipt. Two things hurt: the generic Flutter scanner plugin was too slow and couldn't be customized for the workflow, and after a scan users stared at an endless spinner while the server verified the receipt.\n\n**Why go native.** Tuning a generic plugin only gets you as far as its design allows. The camera pipeline is where speed is won or lost, and on each platform the native APIs give direct control over it — on iOS, AVFoundation and the Vision framework; on Android, CameraX with a barcode library. I rewrote scanning natively — Swift on iOS, Java on Android — behind a small Flutter interface, so the Flutter code stayed clean and platform-independent.\n\n**The shape of the bridge.** The pattern that works:\n\n- a platform view (or a texture) shows the native camera preview inside the Flutter layout\n- a method channel handles commands: start, stop, torch, configure code types\n- an event channel streams results back to Dart as they happen\n\nKeep the channel contract small and typed. The more logic that crosses the bridge, the harder both sides are to test.\n\n**Killing the spinner.** A spinner tells the user nothing. The scanned value went to the backend for verification, so I streamed verification progress back over WebSockets and showed it as a live progress bar: 20%, 45%, 73%, done. Same server work — very different feeling.\n\n**Never losing a claim.** Claims could be created with no signal; they were saved on the device and synced when the connection returned.\n\n**Results:** about 0.5 s to recognize a code in testing, and a successful reimbursement about 5–10 seconds after the scan. The scanner was later published as an open-source Flutter package.\n\n**Lessons:**\n\n- Flutter is the right default. Native is the right tool for the 5% that is performance-critical.\n- Design the channel API first; implement it twice.\n- Progress you can see beats speed you can't."
    },
    {
      "slug": "stripe-apple-entitlements",
      "title": "One entitlement model for Stripe and Apple In-App Purchase",
      "description": "Selling subscriptions on Android through Stripe and on iOS through Apple? Make your backend the single source of truth for what each account owns.",
      "tags": [
        "Flutter",
        "StoreKit 2",
        "Stripe",
        "subscriptions",
        "architecture"
      ],
      "body": "I joined an app that had been in development for about two years without launching. Payments were part of the reason. Android sold subscriptions through Stripe; iOS had to use Apple In-App Purchase. Each system was correct on its own — together they disagreed.\n\n**The core mismatch.** Apple records a purchase against the Apple ID, not against your app's account. So a user can log out, sign in to a different app account on the same iPhone, try to buy again, and Apple says they already own it. Meanwhile upgrades and downgrades behave differently in the two systems, and the app's own account records drift away from both.\n\n**The fix: the backend decides.** As team lead, I redesigned the model with our backend developer:\n\n- one **entitlement** per app account, stored on the backend — the only answer to \"what does this user have?\"\n- Stripe and Apple purchases are both just **inputs** that update that entitlement\n- before accepting a new payment, check whether it would create a duplicate entitlement\n- reconcile existing records once, so old data matches the new rules\n- handle StoreKit purchase states properly (pending, verified, revoked) instead of treating \"not purchased yet\" as \"failed\"\n\nThe result: something bought on iOS is recognized on Android, and the other way round. The app passed App Store review and went live about a month after the stabilization work began.\n\n**Practical tips if you're building this:**\n\n- Store your own account ID with each Apple purchase. StoreKit 2 lets you attach an `appAccountToken` (a UUID) to a purchase for exactly this.\n- Let server events drive state: App Store Server Notifications on the Apple side, webhooks on the Stripe side. Don't trust the client alone.\n- Show the right \"manage subscription\" path — a user can't cancel an Apple subscription from your Android app.\n- Write tests for the unhappy paths: interrupted purchase, restore on a new device, account switch, refund.\n\n**The principle:** payment providers are rails. Your backend owns the truth."
    },
    {
      "slug": "offline-first-conflict-resolution",
      "title": "Offline-first sync: the conflict rule matters more than the sync code",
      "description": "How to make offline writes safe in a mobile app: local-first storage, an outbox, idempotent sync and one deterministic conflict rule.",
      "tags": [
        "Flutter",
        "offline-first",
        "data sync",
        "SQLite",
        "Firebase"
      ],
      "body": "I've built offline-first data layers for learning apps used by students on weak internet and for expense apps used by people in basements, lifts and trains. The sync code is the visible part. The part that decides whether users lose work is the conflict rule.\n\n**The building blocks:**\n\n1. **The device is the source of truth for the user's own writes.** Every write goes to local storage (SQLite) first and the UI reads from there. The network is a background concern.\n2. **An outbox.** Pending changes go into a queue with a client-generated ID. When the connection returns, the queue drains in order.\n3. **Idempotent sync.** The server must accept the same change twice without creating a duplicate — the client ID makes that possible. Retries are guaranteed; duplicates are not acceptable.\n4. **One deterministic conflict rule.** When two devices change the same record, every device must reach the same result, every time.\n\n**Choosing the rule.** Common options, from simplest:\n\n- **Server wins** — simple, but can silently drop a user's offline work.\n- **Last write wins** — needs trustworthy ordering. Device clocks drift, so use server timestamps or a hybrid logical clock rather than the phone's clock.\n- **Field-level merge** — two people edit different fields of the same record and both changes survive.\n- **CRDTs** — data types designed to merge without conflicts. Worth it when many devices edit the same data offline; overkill for a single user's form.\n\nThere is no universally right rule. There is only a rule you chose deliberately, applied everywhere, and tested.\n\n**Two things people forget:**\n\n- **Deletes.** Record them as tombstones, or a deleted item comes back on the next sync.\n- **Tests.** Simulate airplane mode, kill the app mid-sync, edit the same record on two devices. If you haven't tested it, it doesn't work.\n\nI extracted these ideas into an open-source Flutter package, `flutter_crdt_sync_kit`, which merges offline edits from several devices without losing any.\n\n**Rule of thumb:** offline-first can't be added later. It changes your data model, your sync, your conflict rules and your tests — decide on day one."
    },
    {
      "slug": "flutter-home-screen-widgets",
      "title": "Home-screen widgets that share live data with a Flutter app",
      "description": "Flutter can't render inside iOS or Android home-screen widgets. Here's how to share data between the app and native widgets reliably.",
      "tags": [
        "Flutter",
        "WidgetKit",
        "Android",
        "App Groups"
      ],
      "body": "Users often want a glance at your app's key information without opening it — the next prayer time, today's progress, an upcoming deadline. I built home-screen widgets on iOS and Android for a Flutter app. The first thing to accept: **the widget is native, not Flutter.**\n\n**How it fits together:**\n\n- **iOS:** the widget is a WidgetKit extension written in SwiftUI. It runs in a separate process, so it can't read the app's memory. The app and the widget share data through an **App Group** — a shared container and shared `UserDefaults`.\n- **Android:** the widget is an `AppWidgetProvider` with a layout. The Flutter app writes the data to shared storage; the provider reads it when it updates.\n- **The Flutter side** writes a small, ready-to-display payload through a platform channel (or a package such as `home_widget`) and asks the system to refresh: `WidgetCenter.shared.reloadAllTimelines()` on iOS, an update broadcast through `AppWidgetManager` on Android.\n\n**What makes it reliable:**\n\n- **Write display-ready data.** Do the calculations in the app; the widget only shows values. Widgets have tight time and memory budgets.\n- **Plan the timeline.** On iOS, give WidgetKit a timeline of future entries (for example, every prayer time today) so the widget stays correct without the app running.\n- **Keep the contract versioned.** If the app writes a new data shape while an old widget reads it, nothing should crash.\n- **Test on real devices** across sizes, light and dark mode, and after a reboot.\n\n**Lesson:** Flutter covers the app. Knowing exactly where Flutter stops — and writing clean native code there — is what makes a senior Flutter engineer."
    },
    {
      "slug": "building-with-ai-coding-agents",
      "title": "How I build with AI coding agents without losing quality",
      "description": "How a senior mobile engineer uses AI coding agents in practice: own the problem, the architecture and the review — let the agent type.",
      "tags": [
        "AI",
        "software engineering",
        "Flutter",
        "Swift"
      ],
      "body": "I shipped a native macOS app of around 17,000 lines of Swift to the Mac App Store on my own, and AI coding agents wrote much of the code. I also introduced Claude Code to a mobile team, with one non-negotiable rule: code review and tests on every merge. The job didn't disappear. It changed.\n\n**What I still own:**\n\n- **The problem.** What are we solving, for whom, and what does \"done\" mean?\n- **The architecture and data model.** Agents are good at filling in a design. They are poor at choosing one.\n- **The review.** I read every diff as if a junior engineer wrote it — because agents make confident mistakes: missed edge cases, invented APIs, quietly changed behaviour.\n- **The release.** Tests, signing, store review, rollout.\n\n**How I work with an agent:**\n\n1. Write the plan first: modules, interfaces, phases. Give the agent that plan, not a vague wish.\n2. Ask for small, testable tasks. One feature or one refactor at a time.\n3. Give it the rules: architecture patterns, naming, what must not change.\n4. Make it write or update tests with the code, then run them myself.\n5. Review the diff before anything merges. If I can't explain a change, it doesn't go in.\n\n**Where agents help most:** boilerplate, migrations, test scaffolding, exploring an unfamiliar API, and turning a clear spec into a first draft.\n\n**Where they still need a human:** concurrency and race conditions, payments, data that must never be lost, platform review rules, and any decision that trades one cost against another.\n\n**The takeaway:** the most valuable engineering skill now is judgment — choosing the right problem, designing the system, and catching what's wrong. Typing speed matters less every month."
    }
  ],
  "contractHelpCards": [
    {
      "title": "Rescue a stalled Flutter app",
      "body": "Unstick a product blocked on architecture, store review, or a half-finished rewrite.",
      "tags": [
        "contract",
        "full-time",
        "advisory"
      ]
    },
    {
      "title": "Offline-first / sync",
      "body": "Local-first storage and conflict rules so work done without signal is never lost.",
      "tags": [
        "contract",
        "full-time"
      ]
    },
    {
      "title": "Payments (Stripe + StoreKit)",
      "body": "One entitlement model across web/Android Stripe and Apple In-App Purchase.",
      "tags": [
        "contract",
        "full-time"
      ]
    },
    {
      "title": "Native plugin / performance rewrite",
      "body": "Replace a slow Flutter path with Swift/Kotlin when the package cannot do the job.",
      "tags": [
        "contract",
        "advisory"
      ]
    },
    {
      "title": "Tech lead / architecture review",
      "body": "Own the mobile architecture, code review standards, and release pipeline for a team.",
      "tags": [
        "contract",
        "full-time",
        "advisory"
      ]
    }
  ],
  "engagementSteps": [
    {
      "title": "Discovery",
      "body": "15–30 minutes on the product, the blocker, and what success looks like."
    },
    {
      "title": "Audit",
      "body": "Short written findings on architecture, risks, and the smallest useful next step."
    },
    {
      "title": "Milestone plan",
      "body": "Scoped milestones with clear demos — not an open-ended time dump."
    },
    {
      "title": "Weekly demos",
      "body": "Working software every week, with tests and a release path."
    },
    {
      "title": "Handoff",
      "body": "Documented code, ownership transfer, and a clean exit when the goal is met."
    }
  ],
  "faqItems": [
    {
      "question": "How do engagements usually work?",
      "answer": "Project milestones or a monthly retainer for ongoing lead work. Scope and commercial terms are agreed in writing before code starts — rates are not listed publicly."
    },
    {
      "question": "What about time zones?",
      "answer": "Works with any time zone; flexible core overlap hours. Overseas team hours for three years."
    },
    {
      "question": "NDA and IP?",
      "answer": "Happy to sign an NDA. Work product belongs to the client under a standard contractor or employment agreement."
    },
    {
      "question": "What tools do you use?",
      "answer": "Flutter/Dart, native iOS and Android, Firebase/SQLite, Fastlane, GitHub Actions, and the usual design handoff tools."
    },
    {
      "question": "AI-assisted workflow?",
      "answer": "AI coding agents write much of the code under my architecture and review. Tests and automated releases keep quality up — I own the result."
    },
    {
      "question": "Remote from Bangladesh?",
      "answer": "Yes. No relocation or visa sponsorship required for remote work."
    }
  ],
  "emailPresets": [
    {
      "label": "Hiring for a full-time role",
      "subject": "Full-time role — Senior Flutter Engineer",
      "body": "Hi Ehsanur,\n\nI'm hiring for a full-time Senior Flutter / mobile role. Here's a short summary of the company, stack, and timeline:\n\n"
    },
    {
      "label": "Need a contract fix",
      "subject": "Contract — Flutter / native mobile fix",
      "body": "Hi Ehsanur,\n\nWe need contract help on a Flutter (or native) problem. Brief:\n\n- Product:\n- Blocker:\n- Timeline:\n\n"
    },
    {
      "label": "Architecture advisory",
      "subject": "Architecture advisory — mobile",
      "body": "Hi Ehsanur,\n\nI'd like a short architecture / tech-lead advisory pass on our mobile stack. Context:\n\n"
    }
  ],
  "emailPresetsTitle": "I'm reaching out about…",
  "testimonials": [
    {
      "quote": "As a Senior Flutter Developer, Shekh possesses a deep, practical understanding of cross-platform architecture that consistently elevated the quality of our applications. … Any engineering team looking for a technical powerhouse and a supportive leader would be incredibly fortunate to have Shekh onboard.",
      "name": "Tanvir Kabir",
      "role": "Flutter Developer",
      "company": "Devxhub",
      "linkedinUrl": "https://www.linkedin.com/in/sujit70777/details/recommendations/"
    },
    {
      "quote": "Whenever a new project or unfamiliar challenge comes up, he is quick to adapt, understand the requirements, and start contributing effectively.",
      "name": "Tabia Tasnia",
      "role": "Human Resources Executive",
      "linkedinUrl": "https://www.linkedin.com/in/sujit70777/details/recommendations/"
    },
    {
      "quote": "He is a skilled and dependable developer with strong technical knowledge, excellent problem-solving abilities, and a great sense of responsibility.",
      "name": "Rifa Abdullah Rafia",
      "role": "Software Business Analyst & Scrum Master",
      "linkedinUrl": "https://www.linkedin.com/in/sujit70777/details/recommendations/"
    },
    {
      "quote": "He has excellent knowledge of technology and is always eager to share his expertise with others.",
      "name": "Soma Dey",
      "role": "QA Engineer",
      "linkedinUrl": "https://www.linkedin.com/in/sujit70777/details/recommendations/"
    }
  ],
  "press": [],
  "sectionEyebrowTestimonials": "Recommendations",
  "resumeUrl": "assets/documents/resume.pdf",
  "navMore": "More",
  "navMoreTooltip": "More sections",
  "testimonialLinkedInLabel": "LinkedIn recommendation",
  "noteReadLabel": "Read note",
  "noteMinutesRead": "{} min read",
  "notePrevious": "Previous",
  "noteNext": "Next"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": _en};
}
