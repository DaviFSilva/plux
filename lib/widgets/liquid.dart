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