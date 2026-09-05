// Plux — Liquid interactive primitives.
//
// Two reusable pieces:
// - LiquidCard: a card whose border-radius morphs on hover. Press scales
//   slightly. Tinted by the active theme.
// - LiquidButton: a button that morphs to an asymmetric border-radius on
//   press, returning to symmetric on release. The metaball filter isn't
//   used here (Flutter web doesn't have a clean SVG filter primitive);
//   instead the visual "bending" is achieved with morphing radii.

import 'package:flutter/material.dart';

class LiquidCard extends StatefulWidget {
  const LiquidCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  State<LiquidCard> createState() => _LiquidCardState();
}

class _LiquidCardState extends State<LiquidCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.lerp(
            BorderRadius.circular(20),
            BorderRadius.only(
              topLeft: const Radius.circular(28),
              topRight: const Radius.circular(28),
              bottomLeft: const Radius.circular(8),
              bottomRight: const Radius.circular(28),
            ),
            _hover ? 1.0 : 0.0,
          ),
          border: Border.all(
            color: _hover
                ? scheme.outline.withValues(alpha: 0.6)
                : scheme.outlineVariant,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(padding: widget.padding, child: widget.child),
          ),
        ),
      ),
    );
  }
}

class LiquidButton extends StatefulWidget {
  const LiquidButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.primary = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool primary;

  @override
  State<LiquidButton> createState() => _LiquidButtonState();
}

class _LiquidButtonState extends State<LiquidButton> {
  bool _pressed = false;
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = widget.primary ? scheme.primary : scheme.surfaceContainerHighest;
    final fgColor = widget.primary ? scheme.onPrimary : scheme.onSurface;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.lerp(
              BorderRadius.circular(20),
              BorderRadius.only(
                topLeft: const Radius.circular(28),
                topRight: const Radius.circular(8),
                bottomLeft: const Radius.circular(28),
                bottomRight: const Radius.circular(28),
              ),
              _pressed ? 1.0 : (_hover ? 0.4 : 0.0),
            ),
            border: Border.all(
              color: widget.primary
                  ? scheme.primary
                  : scheme.outlineVariant,
              width: 1,
            ),
            boxShadow: _pressed && isDark
                ? [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: -4,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: fgColor, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  color: fgColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Plux — EdgeRail.
//
// A vertical column of text labels running along the screen's left
// edge. Inspired by the "book spine" navigation pattern (text-only
// category names rotated 90°, no icons, no rail background).
//
// Active state: the label color darkens and a soft shadow elongates
// toward the content card, suggesting the card is "pulled out" of the
// rail. Inactive labels stay low-contrast.
//
// Used as the leftmost widget in a Row, with content to the right.
class EdgeRail extends StatelessWidget {
  const EdgeRail({
    super.key,
    required this.labels,
    required this.activeIndex,
    required this.onChanged,
  });

  final List<String> labels;
  final int activeIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return MouseRegion(
      // Hit area: every label is the full width of the rail. Easier
      // to discover than trying to hit a tiny rotated text target.
      child: SizedBox(
        width: 44,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < labels.length; i++) ...[
              _RailLabel(
                label: labels[i],
                active: i == activeIndex,
                onTap: () => onChanged(i),
                activeColor: scheme.onSurface,
                inactiveColor: scheme.onSurfaceVariant.withValues(alpha: 0.35),
              ),
              if (i < labels.length - 1) const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}

class _RailLabel extends StatefulWidget {
  const _RailLabel({
    required this.label,
    required this.active,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;

  @override
  State<_RailLabel> createState() => _RailLabelState();
}

class _RailLabelState extends State<_RailLabel> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isOn = widget.active || _hover;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: RotatedBox(
            quarterTurns: 3, // 270deg; read top-to-bottom on the left edge
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isOn ? FontWeight.w500 : FontWeight.w400,
                color: isOn ? widget.activeColor : widget.inactiveColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Plux — ExtendingShadowCard.
//
// A card whose shadow elongates *toward* a side (default left) when
// active. Pairs with EdgeRail to give the "card pulled out of a shelf"
// effect from the reference design.
//
// On hover: shadow extends + opacity rises. On press: further extension.
// Mirrors the morphing-radius pattern from LiquidCard.
class ExtendingShadowCard extends StatefulWidget {
  const ExtendingShadowCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.shadowSide = ShadowSide.left,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final ShadowSide shadowSide;
  final VoidCallback? onTap;

  @override
  State<ExtendingShadowCard> createState() => _ExtendingShadowCardState();
}

enum ShadowSide { left, right }

class _ExtendingShadowCardState extends State<ExtendingShadowCard> {
  bool _hover = false;
  bool _press = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOn = _hover || _press;

    final shadowBlur = isOn ? 28.0 : 12.0;
    final shadowOpacity = isOn ? 0.18 : 0.08;
    final shadowOffsetX = widget.shadowSide == ShadowSide.left ? -16.0 : 16.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _press = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _press = true),
        onTapCancel: () => setState(() => _press = false),
        onTapUp: (_) => setState(() => _press = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.lerp(
              BorderRadius.circular(20),
              BorderRadius.circular(28),
              isOn ? 1.0 : 0.0,
            ),
            border: Border.all(
              color: isOn
                  ? scheme.outline.withValues(alpha: 0.5)
                  : scheme.outlineVariant,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black : scheme.primary)
                    .withValues(alpha: shadowOpacity),
                blurRadius: shadowBlur,
                offset: Offset(shadowOffsetX, 4),
                spreadRadius: isOn ? 0 : -4,
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}