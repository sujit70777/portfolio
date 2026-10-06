import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/src/common/widgets/scroll_reveal.dart';
import 'package:portfolio/src/constants/palette.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/features/about/domain/skill_category.dart';
import 'package:portfolio/src/features/page_search/presentation/searchable_text.dart';

/// Categorized skills grid: two columns on wide layouts, one on narrow ones.
///
/// Each category gets its own hue from [Palette.hues] — so "AI & LLM Apps"
/// and "Offline-First & Data Sync" are visibly different things at a
/// glance — and each card reveals on scroll with its chips popping in one
/// after another.
class SkillsPanel extends StatelessWidget {
  const SkillsPanel({super.key, required this.categories});

  final List<SkillCategory> categories;

  static const double _twoColumnBreakpoint = 640;
  static const double _columnGap = 16;
  static const _cardStagger = Duration(milliseconds: 90);

  @override
  Widget build(BuildContext context) {
    final palette = Palette.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= _twoColumnBreakpoint;
        final cardWidth = twoColumns
            ? (constraints.maxWidth - _columnGap) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: _columnGap,
          runSpacing: _columnGap,
          children: [
            for (final (index, category) in categories.indexed)
              SizedBox(
                width: cardWidth,
                child: ScrollReveal(
                  // Stagger across a row, not down the whole list — the
                  // last card shouldn't wait for every card above it.
                  delay: _cardStagger * (twoColumns ? index % 2 : 0),
                  duration: const Duration(milliseconds: 900),
                  child: _SkillCategoryCard(
                    category: category,
                    hue: palette.hue(index),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SkillCategoryCard extends StatefulWidget {
  const _SkillCategoryCard({required this.category, required this.hue});

  final SkillCategory category;
  final Color hue;

  @override
  State<_SkillCategoryCard> createState() => _SkillCategoryCardState();
}

class _SkillCategoryCardState extends State<_SkillCategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hue = widget.hue;
    final skills = widget.category.skills ?? const <String>[];
    final reveal = RevealScope.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // A wash of the category's hue from the top-left corner, fading
          // into the ordinary card surface.
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.alphaBlend(
                hue.withAlpha(_hovered ? 34 : 22),
                theme.colorScheme.primary,
              ),
              theme.colorScheme.primary,
            ],
            stops: const [0, 0.7],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hue.withAlpha(_hovered ? 150 : 70),
            width: _hovered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: hue.withAlpha(_hovered ? 40 : 0),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: hue,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(color: hue.withAlpha(120), blurRadius: 8),
                    ],
                  ),
                ),
                gapW12,
                Expanded(
                  child: SearchableText(
                    widget.category.category ?? '',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: hue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            gapH12,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (index, skill) in skills.indexed)
                  _PopIn(
                    animation: reveal,
                    index: index,
                    count: skills.length,
                    child: _SkillChip(label: skill, hue: hue),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Scales and fades one chip in on its own slice of the reveal, so a
/// card's chips arrive in sequence rather than all at once.
class _PopIn extends StatelessWidget {
  const _PopIn({
    required this.animation,
    required this.index,
    required this.count,
    required this.child,
  });

  final Animation<double> animation;
  final int index;
  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Chips start after the card itself has mostly risen into place, and
    // the whole sequence fits in what's left of the reveal.
    const start = 0.25;
    const window = 0.35;
    final step = count <= 1 ? 0.0 : (1 - start - window) / (count - 1);
    final begin = math.min(start + step * index, 1 - window);
    final curved = CurvedAnimation(
      parent: animation,
      curve: Interval(begin, begin + window, curve: Curves.easeOutBack),
    );
    return AnimatedBuilder(
      animation: curved,
      child: child,
      builder: (context, child) {
        final v = curved.value;
        return Opacity(
          opacity: v.clamp(0.0, 1.0),
          child: Transform.scale(scale: 0.7 + 0.3 * v, child: child),
        );
      },
    );
  }
}

/// Pill tinted with its category's hue — the text stays the ordinary body
/// colour so every chip keeps full contrast whatever the hue.
class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.label, required this.hue});

  final String label;
  final Color hue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color.alphaBlend(hue.withAlpha(26), theme.colorScheme.secondary),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: hue.withAlpha(60)),
      ),
      child: SearchableText(label, style: theme.textTheme.bodySmall),
    );
  }
}
