import 'package:flutter/material.dart';

import '../theme/icons.dart';
import '../theme/tokens.dart';

/// Buttons — `.kw-btn`. Pill shape, 56/44 size ladder.
enum KwBtnVariant { primary, secondary, ghost, danger }

class KwButton extends StatefulWidget {
  const KwButton(
    this.label, {
    super.key,
    this.onPressed,
    this.variant = KwBtnVariant.primary,
    this.md = false,
    this.block = true,
    this.icon,
    this.iconSize = 20,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final KwBtnVariant variant;
  final bool md;
  final bool block;
  final String? icon;
  final double iconSize;
  final bool busy;

  @override
  State<KwButton> createState() => _KwButtonState();
}

class _KwButtonState extends State<KwButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.busy;

    late Color bg, fg;
    Border? border;
    switch (widget.variant) {
      case KwBtnVariant.primary:
        bg = _down ? const Color(0xFF0AA877) : const Color(0xFF0DC189);
        fg = Colors.white;
      case KwBtnVariant.secondary:
        bg = _down ? K.tintMint : K.tintGreen;
        fg = K.brandText;
      case KwBtnVariant.ghost:
        bg = _down ? K.tintMint : Colors.transparent;
        fg = K.brandText;
        border = Border.all(color: K.action, width: 1.5);
      case KwBtnVariant.danger:
        bg = _down ? const Color(0xFFA92828) : K.danger;
        fg = Colors.white;
    }
    if (!enabled) {
      bg = K.tintGrey;
      fg = K.inkSubtle;
      border = null;
    }

    final h = widget.md ? 44.0 : 56.0;
    final style = TextStyle(
      fontFamily: 'Tajarib',
      fontSize: widget.md ? 15 : 17,
      height: (widget.md ? 24 : 26) / (widget.md ? 15 : 17),
      fontWeight: FontWeight.w700,
      color: fg,
    );

    final child = widget.busy
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: fg),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                KwIcon(widget.icon!, size: widget.iconSize, color: fg),
                SizedBox(width: widget.md ? 8 : 10),
              ],
              Flexible(child: Text(widget.label, style: style, overflow: TextOverflow.ellipsis)),
            ],
          );

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _down = true) : null,
        onTapUp: enabled ? (_) => setState(() => _down = false) : null,
        onTapCancel: enabled ? () => setState(() => _down = false) : null,
        onTap: enabled ? widget.onPressed : null,
        child: AnimatedScale(
          scale: _down ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            height: h,
            width: widget.block ? double.infinity : null,
            padding: EdgeInsets.symmetric(horizontal: widget.md ? 20 : 28),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: K.rPill,
              border: border,
            ),
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}

class KwTextButton extends StatelessWidget {
  const KwTextButton(this.label, {super.key, this.onTap, this.color, this.dense = false});

  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: dense ? 4 : 16, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajarib',
            fontSize: 15,
            height: 24 / 15,
            fontWeight: FontWeight.w700,
            color: color ?? K.brandText,
          ),
        ),
      ),
    );
  }
}

class KwIconButton extends StatelessWidget {
  const KwIconButton(this.icon, {super.key, this.onTap, this.size = 24, this.tooltip});

  final String icon;
  final VoidCallback? onTap;
  final double size;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(color: K.surfaceSunken, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: KwIcon(icon, size: size, color: K.ink),
        ),
      ),
    );
  }
}

/// Badges — `.kw-badge`.
enum KwBadgeTone { mint, green, neutral, danger }

class KwBadge extends StatelessWidget {
  const KwBadge(this.label, {super.key, this.tone = KwBadgeTone.mint});

  final String label;
  final KwBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    late Color bg, fg;
    BoxBorder? border;
    switch (tone) {
      case KwBadgeTone.mint:
        bg = K.tintMint;
        fg = K.brandText;
      case KwBadgeTone.green:
        bg = K.tintGreen;
        fg = K.brandText;
      case KwBadgeTone.neutral:
        bg = K.tintGrey;
        fg = K.ink;
      case KwBadgeTone.danger:
        bg = K.surface;
        fg = K.danger;
        border = Border.all(color: K.danger, width: 1);
    }
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: K.s2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(K.rSm),
        border: border,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Tajarib',
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w500,
          color: fg,
        ),
      ),
    );
  }
}

/// Cart bubble — `.kw-bubble`, with the little speech tail.
class KwBubble extends StatelessWidget {
  const KwBubble(this.label, {super.key, this.icon = 'basket'});

  final String label;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: K.s4),
          decoration: const BoxDecoration(color: K.tintMint, borderRadius: K.rPill),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              KwIcon(icon, size: 20, color: K.brandText),
              const SizedBox(width: K.s2),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(label, style: KT.strong.copyWith(color: K.brandText)),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -6,
          child: Container(
            width: 14,
            height: 8,
            decoration: const BoxDecoration(
              color: K.tintMint,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(2),
                bottomRight: Radius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Chips — `.q-chip` / `.kw-tab` (pills used as filters and selectors).
class KwChip extends StatelessWidget {
  const KwChip(
    this.label, {
    super.key,
    this.selected = false,
    this.onTap,
    this.enabled = true,
    this.icon,
    this.iconSize = 18,
    this.small = false,
    this.expand = false,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final bool enabled;
  final String? icon;
  final double iconSize;
  final bool small;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final on = enabled && selected;
    final bg = on ? K.tintGreen : K.surfaceSunken;
    final fg = on ? K.brandText : (enabled ? K.ink : K.inkSubtle);

    final btn = Container(
      constraints: BoxConstraints(minHeight: small ? 36 : 40),
      padding: EdgeInsets.symmetric(horizontal: small ? 12 : 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: K.rPill,
        border: Border.all(color: on ? K.action : K.hairline, width: on ? 2 : 1),
      ),
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            KwIcon(icon!, size: iconSize, color: fg),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Tajarib',
                fontSize: small ? 13 : 15,
                height: (small ? 18 : 24) / (small ? 13 : 15),
                fontWeight: FontWeight.w500,
                color: fg,
                decoration: enabled ? null : TextDecoration.lineThrough,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: btn,
      ),
    );
  }
}

/// Selectable card — `.q-select` (radio-style surface).
class KwSelect extends StatelessWidget {
  const KwSelect({
    super.key,
    required this.child,
    this.selected = false,
    this.onTap,
    this.enabled = true,
    this.radio = true,
    this.column = false,
    this.padding = const EdgeInsets.all(K.s4),
  });

  final Widget child;
  final bool selected;
  final VoidCallback? onTap;
  final bool enabled;
  final bool radio;
  final bool column;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final on = enabled && selected;
    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: padding,
          decoration: BoxDecoration(
            color: on ? K.tintGreen : K.surface,
            borderRadius: BorderRadius.circular(K.rMd),
            boxShadow: [
              BoxShadow(
                color: on ? K.action : K.hairline,
                spreadRadius: on ? -1 : 0,
                blurRadius: on ? 0 : 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: column ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              if (radio) ...[
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: K.surface,
                    border: Border.all(
                      color: on ? K.action : K.inkSubtle,
                      width: on ? 7 : 2,
                    ),
                  ),
                ),
                SizedBox(width: column ? K.s3 : K.s3),
              ],
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

/// Toggle switch — `.q-toggle`.
class KwToggle extends StatelessWidget {
  const KwToggle({super.key, this.value = false, this.onChanged, this.label});

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    return Semantics(
      toggled: value,
      label: label,
      enabled: enabled,
      child: GestureDetector(
        onTap: enabled ? () => onChanged!(!value) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 52,
          height: 32,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: value ? K.action : K.inkSubtle,
            borderRadius: K.rPill,
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
          ),
        ),
      ),
    );
  }
}

/// Quantity stepper — `.q-stepper`.
class KwStepper extends StatelessWidget {
  const KwStepper({
    super.key,
    required this.value,
    required this.onDec,
    required this.onInc,
    this.small = false,
    this.decLabel,
    this.incLabel,
  });

  final int value;
  final VoidCallback onDec;
  final VoidCallback onInc;
  final bool small;
  final String? decLabel;
  final String? incLabel;

  @override
  Widget build(BuildContext context) {
    final d = small ? 32.0 : 40.0;
    Widget btn(String icon, VoidCallback onTap, double size, String? sem) => Semantics(
          button: true,
          label: sem,
          child: GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: d,
              height: d,
              decoration: BoxDecoration(
                color: K.surface,
                shape: BoxShape.circle,
                border: Border.all(color: K.hairline),
              ),
              alignment: Alignment.center,
              child: KwIcon(icon, size: size, color: K.brandText),
            ),
          ),
        );

    return Container(
      padding: small ? EdgeInsets.zero : const EdgeInsets.all(2),
      decoration: const BoxDecoration(color: K.surfaceSunken, borderRadius: K.rPill),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: btn('minus', onDec, small ? 16 : 18, decLabel)),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: small ? 16 : 24),
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Tajarib',
                fontSize: small ? 14 : 16,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color: K.ink,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          Flexible(child: btn('plus', onInc, small ? 16 : 18, incLabel)),
        ],
      ),
    );
  }
}
