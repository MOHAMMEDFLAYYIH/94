import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;

import '../theme/icons.dart';
import '../theme/tokens.dart';
import 'controls.dart';

/// Screen frame — `.q-screen`. Fixed 390pt column, ground background.
class KwScreen extends StatelessWidget {
  const KwScreen({super.key, required this.child, this.scrollable = false});

  final Widget child;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    Widget content = child;
    if (scrollable) {
      content = SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: child,
      );
    }
    return ColoredBox(
      color: K.ground,
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: K.screenWidth),
            child: MediaQuery.removePadding(
              context: context,
              removeLeft: true,
              removeRight: true,
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

/// Scrollable body — `.q-body`.
class KwBody extends StatelessWidget {
  const KwBody({super.key, required this.child, this.gap = K.s3, this.pad});

  final Widget child;
  final double gap;
  final EdgeInsets? pad;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.only(top: K.s4, bottom: K.s8),
        child: Padding(
          padding: pad ??
              const EdgeInsets.fromLTRB(K.s6, 0, K.s6, 0).copyWith(top: K.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _spread(gap, child),
          ),
        ),
      ),
    );
  }

  static List<Widget> _spread(double gap, Widget child) {
    if (child is! Column) return [child];
    final kids = <Widget>[];
    final all = child.children;
    for (var i = 0; i < all.length; i++) {
      if (i > 0) kids.add(SizedBox(height: gap));
      kids.add(all[i]);
    }
    return kids;
  }
}

/// Sticky footer — `.q-foot`.
class KwFooter extends StatelessWidget {
  const KwFooter({super.key, required this.children, this.sum});

  final List<Widget> children;
  final Widget? sum;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    if (sum != null) items.addAll([sum!, const SizedBox(height: K.s3)]);
    Widget? prev;
    for (final c in children) {
      if (prev != null) items.add(const SizedBox(height: K.s3));
      items.add(c);
      prev = c;
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(K.s6, K.s4, K.s6, K.s8),
      decoration: const BoxDecoration(
        color: K.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(K.rLg)),
        boxShadow: K.shadowSheet,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: items),
    );
  }
}

/// Footer total row — `.q-foot__sum`.
class KwSum extends StatelessWidget {
  const KwSum(this.label, this.value, {super.key, this.amount, this.total = false});

  final String label;
  final String value;
  final String? amount;
  final bool total;

  @override
  Widget build(BuildContext context) {
    final vStyle = total ? KT.t2.copyWith(color: K.brandText) : KT.t2;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Text(
            label,
            style: KT.p.copyWith(color: K.inkMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: K.s2),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Ltr(value, style: vStyle),
            if (amount != null) ...[
              const SizedBox(width: 5),
              Text(amount!, style: vStyle),
            ],
          ],
        ),
      ],
    );
  }
}

/// Card — `.q-card`.
class KwCard extends StatelessWidget {
  const KwCard({
    super.key,
    required this.child,
    this.gap = K.s3,
    this.padding = const EdgeInsets.all(K.s5),
    this.onTap,
    this.outlined = false,
    this.outlinedColor,
    this.margin,
  });

  final Widget child;
  final double gap;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final bool outlined;
  final Color? outlinedColor;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    Widget col = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _withGaps(gap, child),
      ),
    );

    if (onTap != null) {
      col = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: col,
      );
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: K.surface,
        borderRadius: BorderRadius.circular(K.rMd),
        border: outlined
            ? Border.all(color: outlinedColor ?? K.action, width: 2)
            : (outlinedColor != null ? Border.all(color: outlinedColor!) : null),
      ),
      child: col,
    );
  }

  static List<Widget> _withGaps(double gap, Widget child) {
    if (child is! Column) return [child];
    final out = <Widget>[];
    for (var i = 0; i < child.children.length; i++) {
      if (i > 0) out.add(SizedBox(height: gap));
      out.add(child.children[i]);
    }
    return out;
  }
}

/// Group label with a hairline rule — `.q-group-label`.
class KwGroupLabel extends StatelessWidget {
  const KwGroupLabel(this.label, {super.key, this.trailing});

  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: KT.cap),
        const SizedBox(width: K.s3),
        if (trailing != null) ...[trailing!, const SizedBox(width: K.s3)],
        const Expanded(child: Divider(height: 1, color: K.hairline)),
      ],
    );
  }
}

/// Section header — `.q-sec`.
class KwSection extends StatelessWidget {
  const KwSection(this.title, {super.key, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: K.s3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: KT.t2),
          if (action != null) action!,
        ],
      ),
    );
  }
}

/// List row — `.q-row`.
class KwRow extends StatelessWidget {
  const KwRow({
    super.key,
    this.title,
    this.description,
    this.leading,
    this.trailing,
    this.onTap,
    this.chevron = false,
    this.leadingColor,
    this.leadingBg,
    this.minHeight = 56,
  });

  final String? title;
  final String? description;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool chevron;
  final Color? leadingColor;
  final Color? leadingBg;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.symmetric(vertical: K.s3),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: K.hairline)),
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: K.s3),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) Text(title!, style: KT.strong),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(description!, style: KT.cap),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (chevron) ...[
              const SizedBox(width: K.s2),
              const Icon(Icons.chevron_left, size: 18, color: K.inkSubtle),
            ],
          ],
        ),
      ),
    );
  }
}

/// Square lead icon — `.q-lead`.
class KwLead extends StatelessWidget {
  const KwLead(this.icon, {super.key, this.size = 44, this.color, this.bg});

  final String icon;
  final double size;
  final Color? color;
  final Color? bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg ?? K.surfaceSunken,
        borderRadius: BorderRadius.circular(K.rSm),
      ),
      alignment: Alignment.center,
      child: KwIcon(icon, size: size * 0.55, color: color ?? K.brand),
    );
  }
}

/// Banner — `.q-banner`.
class KwBanner extends StatelessWidget {
  const KwBanner({
    super.key,
    required this.child,
    this.icon,
    this.tone = KwBannerTone.grey,
  });

  final Widget child;
  final String? icon;
  final KwBannerTone tone;

  @override
  Widget build(BuildContext context) {
    final alert = tone == KwBannerTone.alert;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: K.s4, vertical: 14),
      decoration: BoxDecoration(
        color: alert ? K.surface : (tone == KwBannerTone.mint ? K.tintMint : K.tintGrey),
        borderRadius: BorderRadius.circular(K.rMd),
        border: alert ? Border.all(color: K.danger, width: 2) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            KwIcon(icon!, size: 20, color: alert ? K.danger : K.brandText),
            const SizedBox(width: K.s3),
          ],
          Expanded(child: child),
        ],
      ),
    );
  }
}

enum KwBannerTone { grey, mint, alert }

/// Amount row — `.q-amount`.
class KwAmount extends StatelessWidget {
  const KwAmount(this.label, this.value, {super.key, this.badge, this.strong = false});

  final String label;
  final String value;
  final Widget? badge;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: strong ? KT.strong.copyWith(fontWeight: FontWeight.w700) : KT.p,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (badge != null) ...[const SizedBox(width: 6), badge!],
            ],
          ),
        ),
        const SizedBox(width: K.s3),
        Flexible(
          child: Text(
            value,
            style: KT.num,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Six-stage order tracker — `.q-tracker`.
class KwTracker extends StatelessWidget {
  const KwTracker({
    super.key,
    required this.stages,
    required this.strongNow,
  });

  final List<String> stages;
  final int strongNow;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(stages.length, (i) {
        final isDone = i < strongNow;
        final isNow = i == strongNow;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: i == stages.length - 1 ? 0 : 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: isDone ? K.brand : (isNow ? K.brandText : K.hairline),
                    borderRadius: K.rPill,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  stages[i],
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontFamily: 'Tajarib',
                    fontSize: 11,
                    height: 15 / 11,
                    fontWeight: isNow ? FontWeight.w700 : FontWeight.w400,
                    color: isNow
                        ? K.brandText
                        : (isDone ? K.ink : K.inkMuted),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// Compact 6-segment progress — `.q-mini`.
class KwMiniTracker extends StatelessWidget {
  const KwMiniTracker({super.key, required this.done, this.total = 6});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(left: i == total - 1 ? 0 : 4),
            decoration: BoxDecoration(
              color: i < done ? K.brand : K.hairline,
              borderRadius: K.rPill,
            ),
          ),
        );
      }),
    );
  }
}

/// Timeline — `.q-timeline`.
class KwTimeline extends StatelessWidget {
  const KwTimeline({super.key, required this.items});

  final List<({String title, String when, bool done})> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(items.length, (i) {
        final it = items[i];
        final last = i == items.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 22,
                child: Column(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: it.done ? K.brand : K.hairline,
                        border: it.done
                            ? Border.all(color: K.tintGreen, width: 5)
                            : null,
                      ),
                    ),
                    if (!last)
                      Expanded(
                        child: Container(width: 2, color: K.brandSoft),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: K.s3),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: last ? 0 : K.s4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(it.title, style: KT.strong),
                      const SizedBox(height: 2),
                      Text(it.when, style: KT.cap),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

/// Text field — `.q-input` + `.q-field`.
class KwField extends StatelessWidget {
  const KwField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.error,
    this.keyboardType,
    this.maxLines = 1,
    this.suffix,
    this.inputFormatters,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? error;
  final TextInputType? keyboardType;
  final int maxLines;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: KT.cap.copyWith(color: K.ink, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          style: const TextStyle(
            fontFamily: 'Tajarib',
            fontSize: 16,
            color: K.ink,
          ),
          cursorColor: K.action,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'Tajarib',
              fontSize: 16,
              color: K.inkSubtle,
            ),
            filled: true,
            fillColor: K.surface,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: K.s4, vertical: K.s4),
            suffixIcon: suffix,
            border: _b(K.hairline, 1),
            enabledBorder: _b(error != null ? K.danger : K.hairline, error != null ? 2 : 1),
            focusedBorder: _b(error != null ? K.danger : K.focus, 2),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const KwIcon('info', size: 16, color: K.danger),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  error!,
                  style: const TextStyle(
                    fontFamily: 'Tajarib',
                    fontSize: 13,
                    height: 20 / 13,
                    fontWeight: FontWeight.w500,
                    color: K.danger,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  OutlineInputBorder _b(Color c, double w) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(K.rMd),
        borderSide: BorderSide(color: c, width: w),
      );
}

/// Search bar — `.q-search`.
class KwSearch extends StatelessWidget {
  const KwSearch({super.key, required this.hint, this.onTap, this.controller, this.onChanged});

  final String hint;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final inner = Row(
      children: [
        const KwIcon('search', size: 20, color: K.inkMuted),
        const SizedBox(width: K.s2),
        Expanded(
          child: controller == null
              ? Text(hint, style: KT.p.copyWith(color: K.inkMuted))
              : TextField(
                  controller: controller,
                  onChanged: onChanged,
                  style: const TextStyle(fontFamily: 'Tajarib', fontSize: 15, color: K.ink),
                  cursorColor: K.action,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: const TextStyle(
                      fontFamily: 'Tajarib',
                      fontSize: 15,
                      color: K.inkMuted,
                    ),
                  ),
                ),
        ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.symmetric(horizontal: K.s4),
        decoration: BoxDecoration(
          color: K.surface,
          borderRadius: BorderRadius.circular(K.rMd),
          border: Border.all(color: K.hairline),
        ),
        alignment: Alignment.center,
        child: inner,
      ),
    );
  }
}

/// Photo placeholder — `.q-photo`.
class KwPhoto extends StatelessWidget {
  const KwPhoto({super.key, this.label, this.icon = 'image', this.size = 64});

  final String? label;
  final String icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final inner = label == null
        ? KwIcon(icon, size: size * 0.38, color: K.inkMuted)
        : Padding(
            padding: EdgeInsets.all(size * 0.09),
            child: FittedBox(
              child: Text(
                label!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Tajarib',
                  fontSize: 12,
                  height: 16 / 12,
                  color: K.inkMuted,
                ),
              ),
            ),
          );

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: K.tintGrey,
        borderRadius: BorderRadius.circular(K.rSm),
      ),
      alignment: Alignment.center,
      child: inner,
    );
  }
}

/// Empty / error state — `.q-state`.
class KwState extends StatelessWidget {
  const KwState({
    super.key,
    this.icon = 'basket',
    required this.title,
    required this.body,
    this.cta,
    this.onCta,
  });

  final String icon;
  final String title;
  final String body;
  final String? cta;
  final VoidCallback? onCta;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(K.s8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(color: K.surface, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: KwIcon(icon, size: 44, color: K.brand),
              ),
              const SizedBox(height: K.s3),
              Text(title, textAlign: TextAlign.center, style: KT.t3),
              const SizedBox(height: K.s2),
              Text(body, textAlign: TextAlign.center, style: KT.cap),
              if (cta != null) ...[
                const SizedBox(height: K.s6),
                KwButton(cta!, onPressed: onCta, md: true, block: false),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Shimmering skeleton — `.q-sk`.
class KwSkeleton extends StatefulWidget {
  const KwSkeleton({super.key, this.width, this.height = 16, this.radius = K.rSm});

  final double? width;
  final double height;
  final double radius;

  @override
  State<KwSkeleton> createState() => _KwSkeletonState();
}

class _KwSkeletonState extends State<KwSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1 + 4 * t, 0),
              end: Alignment(-0.2 + 4 * t, 0),
              colors: const [K.tintGrey, K.surfaceSunken, K.tintGrey],
              stops: const [0.1, 0.5, 0.9],
            ),
          ),
        );
      },
    );
  }
}

/// LTR isolate for numbers and latin text inside RTL copy — `.q-ltr`.
class Ltr extends StatelessWidget {
  const Ltr(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(text, style: style),
    );
  }
}

/// Arabic-Indic digit normalisation for phone entry.
String normalizeDigits(String input) {
  const map = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
    '۰': '0',
    '۱': '1',
    '۲': '2',
    '۳': '3',
    '۴': '4',
    '۵': '5',
    '۶': '6',
    '۷': '7',
    '۸': '8',
    '۹': '9',
  };
  final buf = StringBuffer();
  for (final ch in input.split('')) {
    buf.write(map[ch] ?? ch);
  }
  return buf.toString().replaceAll(RegExp(r'\s'), '');
}

/// Grouped thousands with latin separators, as the prototype does.
String fmtK(int n) {
  final s = n.abs().toString();
  final buf = StringBuffer(n < 0 ? '-' : '');
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}
