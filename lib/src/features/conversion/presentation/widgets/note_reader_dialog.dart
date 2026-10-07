import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/common/widgets/copy_link_button.dart';
import 'package:portfolio/src/common/widgets/responsive.dart';
import 'package:portfolio/src/common/widgets/selection_area.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/constants/themes.dart';
import 'package:portfolio/src/features/conversion/data/conversion_repository.dart';
import 'package:portfolio/src/features/conversion/domain/conversion_models.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/note_body.dart';
import 'package:portfolio/src/features/conversion/presentation/widgets/tag_chips.dart';
import 'package:portfolio/src/features/general/presentation/widgets/deep_link_handler.dart';
import 'package:portfolio/src/features/project/presentation/widgets/browser_query.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';
import 'package:portfolio/src/utils/analytics.dart';

const _desktopMaxWidth = 860.0;
const _readingWidth = 680.0;

/// Opens a note in place — same barrier and entrance as the project modal —
/// so it can be read and shared (`?note=<slug>`) without leaving the page.
///
/// [allNotes] (for Previous/Next) defaults to the repository list; tests
/// pass a short fake list.
Future<void> showNoteReader(
  BuildContext context, {
  required Note note,
  List<Note>? allNotes,
}) {
  final reduceMotion = MediaQuery.disableAnimationsOf(context);
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black87,
    transitionDuration:
        reduceMotion ? Duration.zero : const Duration(milliseconds: 150),
    pageBuilder: (context, animation, secondaryAnimation) {
      return NoteReaderDialog(note: note, allNotes: allNotes);
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.98, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class NoteReaderDialog extends ConsumerStatefulWidget {
  const NoteReaderDialog({super.key, required this.note, this.allNotes});

  final Note note;
  final List<Note>? allNotes;

  @override
  ConsumerState<NoteReaderDialog> createState() => _NoteReaderDialogState();
}

class _NoteReaderDialogState extends ConsumerState<NoteReaderDialog> {
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  late Note _note;

  List<Note> get _notes =>
      widget.allNotes ?? ref.read(conversionRepositoryProvider).getNotes();

  int get _index => _notes.indexWhere((n) => n.slug == _note.slug);

  @override
  void initState() {
    super.initState();
    _note = widget.note;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _opened();
    });
  }

  @override
  void dispose() {
    // Drop ?note= so a reload or a copied address bar doesn't reopen it.
    setBrowserQueryParam('note', null);
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _opened() {
    setBrowserQueryParam('note', _note.slug);
    Analytics.track('note_open', props: {'slug': _note.slug});
  }

  void _go(int delta) {
    final notes = _notes;
    final next = _index + delta;
    if (next < 0 || next >= notes.length) return;
    setState(() => _note = notes[next]);
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
    _opened();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.escape:
        Navigator.of(context).pop();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowLeft:
        _go(-1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowRight:
        _go(1);
        return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = Palette.of(context);
    final isMobile = Responsive.isMobile(context);
    final index = _index;
    final hue = palette.hue(index < 0 ? 0 : index);
    final notes = _notes;
    final gutter = isMobile ? 20.0 : 32.0;

    final shell = Material(
      color: theme.colorScheme.primary,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius:
            isMobile ? BorderRadius.zero : BorderRadius.circular(20),
        side: isMobile
            ? BorderSide.none
            : BorderSide(color: hue.withAlpha(90)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The note's hue as a lit top edge, like the cards' accent edge.
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [hue, hue.withAlpha(30)]),
            ),
          ),
          _Header(
            note: _note,
            number: index + 1,
            hue: hue,
            gutter: gutter,
            onClose: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: MySelectionArea(
              child: Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(gutter, 24, gutter, 40),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: _readingWidth),
                      // Keyed per note, so selection and layout don't carry
                      // over when Previous/Next swaps the text.
                      child: Column(
                        key: ValueKey(_note.slug),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Description and tags scroll with the text so
                          // the fixed header stays short on a phone.
                          if (_note.description.isNotEmpty) ...[
                            Text(
                              _note.description,
                              style: theme.textTheme.titleMedium?.copyWith(
                                height: 1.5,
                                color: mutedTextColor(theme.colorScheme),
                              ),
                            ),
                            gapH12,
                          ],
                          if (_note.tags.isNotEmpty) ...[
                            TagChips(tags: _note.tags, hue: hue),
                            gapH24,
                          ],
                          NoteBody(body: _note.body, hue: hue),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _ActionBar(
            shareUrl: noteShareUrl(_note.slug),
            compact: isMobile,
            onPrevious: index > 0 ? () => _go(-1) : null,
            onNext: index >= 0 && index < notes.length - 1
                ? () => _go(1)
                : null,
            onClose: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKey,
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: isMobile
              ? shell
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: _desktopMaxWidth,
                        maxHeight: MediaQuery.sizeOf(context).height * 0.88,
                      ),
                      child: shell,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.note,
    required this.number,
    required this.hue,
    required this.gutter,
    required this.onClose,
  });

  final Note note;
  final int number;
  final Color hue;
  final double gutter;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meta = [
      'NOTE ${number.toString().padLeft(2, '0')}',
      tr(LocaleKeys.noteMinutesRead, args: ['${note.readingMinutes}'])
          .toUpperCase(),
    ].join('  ·  ');

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.onSurface.withAlpha(20)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(gutter, 20, 8, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meta,
                    style: monoLabelStyle(
                      fontSize: 12,
                      letterSpacing: 0.08,
                      color: hue,
                    ),
                  ),
                  gapH8,
                  Text(
                    note.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              color: theme.colorScheme.onSurface,
              tooltip: MaterialLocalizations.of(context).closeButtonLabel,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.shareUrl,
    required this.compact,
    required this.onPrevious,
    required this.onNext,
    required this.onClose,
  });

  final String shareUrl;

  /// Phone width: Previous/Next drop to icons so the bar fits one row.
  final bool compact;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    // Set explicitly: this theme's colorScheme.primary is the dialog's own
    // surface, so default-coloured buttons would vanish into it.
    final navStyle = TextButton.styleFrom(
      foregroundColor: onSurface,
      disabledForegroundColor: onSurface.withAlpha(70),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: onSurface.withAlpha(20))),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Full Previous/Next + Copy + Close labels need ~800px; drop
            // to icon nav when the dialog is narrower (or phone layout).
            final useCompact = compact || constraints.maxWidth < 800;
            Widget navButton({
              required VoidCallback? onPressed,
              required IconData icon,
              required String label,
              bool iconAfter = false,
            }) {
              if (useCompact) {
                return IconButton(
                  onPressed: onPressed,
                  icon: Icon(icon),
                  color: onSurface,
                  disabledColor: onSurface.withAlpha(70),
                  tooltip: label,
                );
              }
              return TextButton.icon(
                style: navStyle,
                onPressed: onPressed,
                icon: Icon(icon, size: 18),
                label: Text(label),
                iconAlignment:
                    iconAfter ? IconAlignment.end : IconAlignment.start,
              );
            }

            return Row(
              children: [
                navButton(
                  onPressed: onPrevious,
                  icon: Icons.arrow_back_rounded,
                  label: tr(LocaleKeys.notePrevious),
                ),
                navButton(
                  onPressed: onNext,
                  icon: Icons.arrow_forward_rounded,
                  label: tr(LocaleKeys.noteNext),
                  iconAfter: true,
                ),
                const Spacer(),
                CopyLinkButton(url: shareUrl),
                gapW8,
                OutlinedButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(onSurface),
                    side: WidgetStatePropertyAll(
                      BorderSide(color: onSurface.withAlpha(60)),
                    ),
                  ),
                  onPressed: onClose,
                  child: Text(
                    MaterialLocalizations.of(context).closeButtonLabel,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
