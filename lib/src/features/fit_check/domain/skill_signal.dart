/// One recognisable requirement a job description or project brief can ask
/// for, with the phrasings that count as asking for it.
///
/// The same patterns are run over both sides — the pasted text, and this
/// site's own content (projects, experience, skills) — so evidence is found
/// in the portfolio data itself rather than hand-maintained per skill.
/// Adding a project that mentions GraphQL is all it takes for a GraphQL
/// requirement to start linking to it.
class SkillSignal {
  const SkillSignal({
    required this.id,
    required this.label,
    required this.patterns,
    this.differentiator = false,
  });

  final String id;
  final String label;

  /// Regex alternatives, matched case-insensitively and bounded so that
  /// "Swift" doesn't match inside "SwiftUI" and "Java" doesn't match inside
  /// "JavaScript". Keep each one specific enough that a false positive on
  /// the portfolio side can't manufacture evidence that isn't there: an
  /// overclaim is worse for a hiring conversation than an honest gap.
  final List<String> patterns;

  /// Strengths worth surfacing even when a brief doesn't ask for them.
  final bool differentiator;

  RegExp get regExp => _cache[id] ??= RegExp(
    // Custom boundaries instead of \b, which treats "+", "#" and "." as
    // non-word characters and so can't bound "C++", "C#" or "Node.js".
    r'(?<![\w+#.])(?:' + patterns.join('|') + r')(?![\w+#])',
    caseSensitive: false,
  );

  static final Map<String, RegExp> _cache = {};
}

/// Every signal Fit Check recognises. Deliberately includes skills this
/// portfolio has no evidence for (GraphQL, Kotlin Multiplatform, Docker…),
/// so a brief that asks for them shows an honest gap instead of the
/// requirement silently disappearing.
const skillSignals = <SkillSignal>[
  // Languages
  SkillSignal(id: 'dart', label: 'Dart', patterns: ['dart']),
  SkillSignal(id: 'kotlin', label: 'Kotlin', patterns: ['kotlin']),
  SkillSignal(id: 'swift', label: 'Swift', patterns: ['swift']),
  SkillSignal(id: 'java', label: 'Java', patterns: ['java']),
  SkillSignal(id: 'typescript', label: 'TypeScript', patterns: ['typescript']),
  SkillSignal(
    id: 'javascript',
    label: 'JavaScript',
    patterns: ['javascript', 'es6'],
  ),
  SkillSignal(
    id: 'objc',
    label: 'Objective-C',
    patterns: [r'objective[- ]?c', r'obj-?c'],
  ),
  // Not "Learn Python" / "(Python, CSE…)" as a curriculum topic in a
  // learning product — that isn't professional Python work.
  SkillSignal(
    id: 'python',
    label: 'Python',
    patterns: [r'(?<!learn )(?<!\()python'],
  ),
  SkillSignal(id: 'cpp', label: 'C++', patterns: [r'c\+\+']),
  SkillSignal(id: 'csharp', label: 'C#', patterns: ['c#']),
  SkillSignal(id: 'go', label: 'Go', patterns: ['golang']),
  SkillSignal(id: 'rust', label: 'Rust', patterns: ['rust']),

  // Frameworks and platforms
  SkillSignal(id: 'flutter', label: 'Flutter', patterns: ['flutter']),
  SkillSignal(
    id: 'reactNative',
    label: 'React Native',
    patterns: [r'react[- ]native'],
  ),
  SkillSignal(
    id: 'react',
    label: 'React (web)',
    patterns: [r'react(?:\.?js)?(?![- ]native)'],
  ),
  SkillSignal(id: 'ios', label: 'iOS', patterns: ['ios']),
  SkillSignal(id: 'android', label: 'Android', patterns: ['android']),
  SkillSignal(
    id: 'macos',
    label: 'macOS',
    patterns: ['macos', r'mac ?os', 'os x'],
  ),
  SkillSignal(id: 'swiftui', label: 'SwiftUI', patterns: ['swiftui']),
  SkillSignal(id: 'uikit', label: 'UIKit', patterns: ['uikit']),
  SkillSignal(id: 'appkit', label: 'AppKit', patterns: ['appkit']),
  SkillSignal(
    id: 'compose',
    label: 'Jetpack Compose',
    patterns: ['jetpack compose', 'compose multiplatform'],
  ),
  SkillSignal(
    id: 'kmp',
    label: 'Kotlin Multiplatform',
    patterns: ['kotlin multiplatform', 'kmp', 'kmm'],
  ),

  // Architecture and state
  SkillSignal(id: 'riverpod', label: 'Riverpod', patterns: ['riverpod']),
  SkillSignal(id: 'bloc', label: 'Bloc', patterns: ['bloc', 'cubit']),
  SkillSignal(id: 'redux', label: 'Redux', patterns: ['redux']),
  SkillSignal(id: 'mobx', label: 'MobX', patterns: ['mobx']),
  SkillSignal(id: 'getx', label: 'GetX', patterns: ['getx']),
  SkillSignal(
    id: 'cleanArchitecture',
    label: 'Clean Architecture / MVVM',
    patterns: ['clean architecture', 'mvvm', 'mvi', 'solid principles'],
  ),
  SkillSignal(
    id: 'offlineFirst',
    label: 'Offline-first',
    patterns: [
      r'offline[- ]first',
      r'offline[- ]capab\w*',
      r'offline (?:support|mode|sync|queu\w*)',
      r'local[- ]first',
      r'works? (?:fully )?offline',
      r'fully offline',
    ],
    differentiator: true,
  ),
  SkillSignal(
    id: 'sync',
    label: 'Data sync & conflict resolution',
    patterns: [
      r'sync(?:hroni[sz]ation|hroni[sz]ing|ing|s)?',
      r'conflict[- ](?:free|resolution)',
      r'crdts?',
    ],
    differentiator: true,
  ),
  SkillSignal(
    id: 'performance',
    label: 'Performance optimisation',
    patterns: [
      'performance',
      r'profiling',
      'jank',
      r'startup time',
      r'app size',
      r'memory leaks?',
    ],
  ),
  SkillSignal(
    id: 'platformChannels',
    label: 'Native modules / platform channels',
    patterns: [
      r'platform channels?',
      r'method channels?',
      r'native modules?',
      r'native (?:bridges?|layer|plugins?)',
      'ffi',
      r'turbo ?modules?',
    ],
  ),
  SkillSignal(
    id: 'background',
    label: 'Background processing',
    patterns: [
      r'background (?:tasks?|sync|processing|jobs?|fetch|services?)',
      'workmanager',
      r'retry queues?',
    ],
  ),

  // Data and backend
  SkillSignal(
    id: 'firebase',
    label: 'Firebase',
    patterns: ['firebase', 'firestore', 'crashlytics', 'fcm'],
  ),
  SkillSignal(id: 'supabase', label: 'Supabase', patterns: ['supabase']),
  SkillSignal(
    id: 'sqlite',
    label: 'SQLite / local database',
    patterns: ['sqlite', 'drift', 'grdb', 'sqflite', r'local databases?'],
  ),
  SkillSignal(id: 'coreData', label: 'Core Data', patterns: [r'core ?data']),
  SkillSignal(id: 'realm', label: 'Realm', patterns: ['realm']),
  SkillSignal(
    id: 'postgres',
    label: 'PostgreSQL',
    patterns: [r'postgres(?:ql)?'],
  ),
  SkillSignal(
    id: 'rest',
    label: 'REST APIs',
    patterns: [
      r'rest(?:ful)? ?apis?',
      'restful',
      r'rest (?:services?|endpoints?|backend)',
    ],
  ),
  SkillSignal(id: 'graphql', label: 'GraphQL', patterns: ['graphql', 'apollo']),
  SkillSignal(
    id: 'websockets',
    label: 'WebSockets',
    patterns: [r'web ?sockets?', r'socket\.io', 'mqtt'],
  ),
  SkillSignal(
    id: 'grpc',
    label: 'gRPC / Protobuf',
    patterns: ['grpc', 'protobuf', 'protocol buffers'],
  ),
  SkillSignal(
    id: 'node',
    label: 'Node.js',
    patterns: [r'node\.?js', r'express\.js'],
  ),
  SkillSignal(
    id: 'aws',
    label: 'AWS',
    patterns: ['aws', 'amazon web services'],
  ),
  SkillSignal(
    id: 'gcp',
    label: 'Google Cloud',
    patterns: ['gcp', 'google cloud'],
  ),
  SkillSignal(id: 'docker', label: 'Docker', patterns: ['docker']),
  SkillSignal(
    id: 'kubernetes',
    label: 'Kubernetes',
    patterns: ['kubernetes', 'k8s'],
  ),

  // Platform features
  SkillSignal(
    id: 'iap',
    label: 'In-app purchases & subscriptions',
    patterns: [
      r'in[- ]app purchases?',
      'iap',
      r'storekit(?: 2)?',
      r'(?:in[- ]app |auto[- ]renewable )?subscriptions?',
      'revenuecat',
      r'(?:google )?play billing',
    ],
    differentiator: true,
  ),
  SkillSignal(
    id: 'payments',
    label: 'Payments',
    patterns: [
      r'payments?',
      'stripe',
      'apple pay',
      'google pay',
      'pix',
      'braintree',
      'paypal',
    ],
  ),
  SkillSignal(
    id: 'push',
    label: 'Push notifications',
    patterns: [r'push notifications?', r'notifications?', 'apns', 'onesignal'],
  ),
  SkillSignal(
    id: 'maps',
    label: 'Maps & location',
    patterns: [
      'mapping',
      'mapbox',
      r'google maps',
      'geolocation',
      r'location[- ]based',
      'gps',
      r'geofenc\w*',
      r'(?:mosque )?locator',
    ],
  ),
  SkillSignal(
    id: 'computerVision',
    label: 'Camera & computer vision',
    patterns: [
      r'computer vision',
      r'image processing',
      'camera',
      'ocr',
      'barcode',
      r'qr codes?',
    ],
  ),
  SkillSignal(
    id: 'ml',
    label: 'On-device ML / AI',
    patterns: [
      r'on[- ]device (?:ml|ai|machine learning|inference|learning)',
      r'tensorflow lite',
      'tflite',
      r'core ?ml',
      r'ml ?kit',
      r'machine learning',
      'ml',
      'ai',
      r'classifiers?',
    ],
  ),
  SkillSignal(
    id: 'ar',
    label: 'Augmented reality',
    patterns: [r'augmented reality', 'ar', 'arkit', 'arcore'],
  ),
  SkillSignal(
    id: 'a11y',
    label: 'Accessibility',
    patterns: [
      r'accessib\w*',
      'a11y',
      'wcag',
      'voiceover',
      'talkback',
      r'screen readers?',
    ],
    differentiator: true,
  ),
  SkillSignal(
    id: 'i18n',
    label: 'Localisation',
    patterns: [
      r'locali[sz]ation',
      r'internationali[sz]ation',
      'i18n',
      'l10n',
      r'multi[- ]language',
      'multilingual',
    ],
  ),
  SkillSignal(
    id: 'security',
    label: 'Mobile security',
    patterns: [
      r'security',
      r'biometrics?',
      r'biometric-secured',
      'encryption',
      'keychain',
      'owasp',
      r'(?:ssl|certificate) pinning',
      r'recording protection',
      'sandboxed',
    ],
  ),
  SkillSignal(
    id: 'animation',
    label: 'Animation & custom UI',
    patterns: [
      r'animations?',
      r'motion design',
      r'shaders?',
      r'shader-powered',
      r'custom painters?',
      r'canvas library',
    ],
  ),
  SkillSignal(
    id: 'designSystems',
    label: 'Design systems & UI kits',
    patterns: [
      r'design systems?',
      r'design language',
      r'ui kits?',
      r'ui design',
      r'component librar(?:y|ies)',
    ],
  ),
  SkillSignal(id: 'figma', label: 'Figma', patterns: ['figma']),

  // Quality and delivery
  SkillSignal(
    id: 'testing',
    label: 'Automated testing',
    patterns: [
      r'test(?:s|ing)?',
      'tdd',
      r'e2e',
      r'end[- ]to[- ]end tests?',
      'detox',
      'appium',
      'xctest',
      'espresso',
    ],
  ),
  SkillSignal(
    id: 'cicd',
    label: 'CI/CD',
    patterns: [
      r'ci ?/ ?cd',
      'cicd',
      r'continuous (?:integration|delivery|deployment)',
      r'github actions',
      'bitrise',
      'codemagic',
      'jenkins',
      'circleci',
      r'gitlab ci',
      'fastlane',
    ],
  ),
  SkillSignal(
    id: 'release',
    label: 'App Store & Play releases',
    patterns: [
      r'app ?store',
      r'mac app store',
      r'play store',
      r'google play',
      'testflight',
      r'store (?:releases?|submissions?|delivery)',
      r'release management',
      r'app store connect',
    ],
  ),
  SkillSignal(
    id: 'git',
    label: 'Git & code review',
    patterns: [
      'git',
      'github',
      'gitlab',
      'bitbucket',
      r'code reviews?',
      r'pull requests?',
    ],
  ),
  SkillSignal(
    id: 'monitoring',
    label: 'Crash reporting & monitoring',
    patterns: [
      'crashlytics',
      'sentry',
      'datadog',
      'observability',
      r'crash reporting',
    ],
  ),
  SkillSignal(
    id: 'openSource',
    label: 'Open source',
    patterns: [
      r'open[- ]source',
      r'open[- ]sourced',
      r'pub\.dev',
      r'published (?:\d+ )?(?:reusable )?(?:flutter )?(?:packages|libraries)',
    ],
    differentiator: true,
  ),

  // Ways of working
  SkillSignal(
    id: 'leadership',
    label: 'Technical leadership & mentoring',
    patterns: [
      r'lead(?:s|ing|ership)?',
      'led',
      r'tech(?:nical)? lead',
      r'team lead',
      r'mentor(?:s|ing|ed|ship)?',
      r'coach(?:ing)?',
      r'managed (?:a )?\d+-developer team',
    ],
  ),
  SkillSignal(
    id: 'agile',
    label: 'Agile / Scrum',
    patterns: ['agile', 'scrum', 'kanban', r'sprints?'],
  ),
  SkillSignal(
    id: 'remote',
    label: 'Remote & distributed teams',
    patterns: [
      'remote',
      // Plural on purpose: "multiple time zones" is a way of working;
      // "timezone support" in a date/time library is not.
      r'time ?zones',
      r'time ?zone overlap',
      'distributed',
      r'async(?:hronous)? (?:communication|collaboration|team|work)',
      r'async, distributed',
    ],
  ),
  SkillSignal(
    id: 'collaboration',
    label: 'Cross-functional collaboration',
    patterns: [
      r'cross[- ]functional',
      r'stakeholders?',
      r'product (?:managers?|teams?|owners?)',
      r'communication skills',
    ],
  ),
  SkillSignal(
    id: 'ownership',
    label: 'End-to-end ownership',
    patterns: [
      r'end[- ]to[- ]end(?! tests?)',
      'ownership',
      r'own(?:ing)? (?:features?|the product)',
      r'zero[- ]to[- ]one',
      r'0[- ]to[- ]1',
      'founder',
      r'sole (?:developer|engineer)',
      'startup',
    ],
  ),

  // Domains
  SkillSignal(
    id: 'fintech',
    label: 'FinTech',
    patterns: [
      'fintech',
      'financial',
      'banking',
      r'expense(?:-management)?',
      'reimbursement',
      r'wallets?',
    ],
  ),
  SkillSignal(
    id: 'ecommerce',
    label: 'E-commerce & marketplaces',
    patterns: [r'e-?commerce', r'marketplaces?', 'retail', 'checkout'],
  ),
  SkillSignal(
    id: 'edtech',
    label: 'EdTech',
    patterns: [
      r'ed-?tech',
      r'educational',
      r'e-?learning',
      r'learning (?:apps?|platform)',
    ],
  ),
  SkillSignal(
    id: 'mobility',
    label: 'Mobility, transit & delivery',
    patterns: [
      r'ride[- ]hailing',
      'mobility',
      'transit',
      r'(?:food |grocery |last[- ]mile )?delivery apps?',
      r'grocery delivery',
      'logistics',
    ],
  ),
  SkillSignal(
    id: 'health',
    label: 'Health & wellness',
    patterns: [
      r'health ?(?:care|tech)',
      'medical',
      'fitness',
      'wellness',
      'telehealth',
      r'virtual consultations?',
    ],
  ),
];
