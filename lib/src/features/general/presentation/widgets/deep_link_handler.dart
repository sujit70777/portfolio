import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/conversion/data/conversion_repository.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/note_reader_dialog.dart';
import 'package:portfolio/src/features/general/provider/section_key_provider.dart';
import 'package:portfolio/src/features/project/data/project_repository.dart';
import 'package:portfolio/src/features/project/presentation/widgets/project_detail_modal.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/slugify.dart';

/// The link to one project, as the project modal's "Copy link" shares it.
/// Always the canonical domain, so a link copied from a local or preview
/// build still works for whoever receives it.
String projectShareUrl(String projectName) {
  final site = Uri.parse(tr(LocaleKeys.siteUrl));
  return site
      .replace(queryParameters: {'project': slugify(projectName)})
      .toString();
}

/// The link to one note, as the note reader's "Copy link" shares it.
String noteShareUrl(String slug) {
  final site = Uri.parse(tr(LocaleKeys.siteUrl));
  return site.replace(queryParameters: {'note': slug}).toString();
}

/// Acts on `?project=<slug>`, `?note=<slug>` and `?section=<name>` once
/// the page is up: a shared project or note link opens its modal over its
/// own section, and a section link (e.g. `?section=fit-check` in a cold
/// email) scrolls straight to it.
///
/// Query parameters rather than paths, because a path would need the host
/// to rewrite it to index.html — and this site shares its host with real
/// directories (/hourwise/, /privacy-policy/, …).
class DeepLinkHandler extends ConsumerStatefulWidget {
  const DeepLinkHandler({super.key, this.uri});

  /// Defaults to the page's own URL; overridable for tests.
  final Uri? uri;

  @override
  ConsumerState<DeepLinkHandler> createState() => _DeepLinkHandlerState();
}

class _DeepLinkHandlerState extends ConsumerState<DeepLinkHandler> {
  // Long enough for the first layout to settle (fonts, the hero's device
  // frame) so the scroll target doesn't move after it's scrolled to.
  static const _settleDelay = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    final params = (widget.uri ?? Uri.base).queryParameters;
    final project = params['project'];
    final note = params['note'];
    final section = params['section'];
    if (project == null && note == null && section == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(_settleDelay, () {
        if (!mounted) return;
        if (project != null) {
          _openProject(project);
        } else if (note != null) {
          _openNote(note);
        } else {
          _scrollToSection(section!);
        }
      });
    });
  }

  void _openNote(String slug) {
    final notes = ref.read(conversionRepositoryProvider).getNotes();
    final note = notes.firstWhereOrNull((n) => n.slug == slug);
    if (note == null) return;
    // Land on Notes underneath, so closing the reader leaves the visitor
    // beside the other notes.
    _scrollTo(ref.read(notesSectionKeyProvider), animate: false);
    showNoteReader(context, note: note, allNotes: notes);
  }

  void _openProject(String slug) {
    final project = ref
        .read(projectRepositoryProvider)
        .getProjects()
        .firstWhereOrNull((p) => slugify(p.name ?? '') == slug);
    if (project == null) return;
    // Land on Projects underneath, so closing the modal leaves the visitor
    // among the rest of the work rather than back at the top.
    _scrollTo(ref.read(projectSectionKeyProvider), animate: false);
    showProjectDetailModal(context, project: project);
  }

  void _scrollToSection(String name) {
    final key = switch (name) {
      'about' => aboutSectionKeyProvider,
      'skills' => skillsSectionKeyProvider,
      'experience' => experienceSectionKeyProvider,
      'projects' => projectSectionKeyProvider,
      'notes' => notesSectionKeyProvider,
      'fit-check' || 'fit' => fitCheckSectionKeyProvider,
      _ => null,
    };
    if (key != null) _scrollTo(ref.read(key), animate: true);
  }

  void _scrollTo(GlobalKey key, {required bool animate}) {
    final context = key.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: animate ? const Duration(milliseconds: 600) : Duration.zero,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
