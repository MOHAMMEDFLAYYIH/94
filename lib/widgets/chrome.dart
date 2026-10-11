import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/icons.dart';
import '../theme/svg_path.dart';

/// Top bar — `.q-top`.
class KwTopBar extends StatelessWidget {
  const KwTopBar({
    super.key,
    this.title,
    this.onBack,
    this.action,
    this.showBack = true,
  });

  final String? title;
  final VoidCallback? onBack;
  final Widget? action;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.symmetric(horizontal: K.s3, vertical: K.s2),
      decoration: const BoxDecoration(
        color: K.surface,
        border: Border(bottom: BorderSide(color: K.hairline)),
      ),
      child: Row(
        children: [
          if (showBack)
            Padding(
              padding: const EdgeInsets.only(left: K.s2),
              child: IconButton(
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_forward, size: 22, color: K.ink),
                tooltip: 'رجوع',
                splashRadius: 22,
              ),
            )
          else
            const SizedBox(width: K.s2),
          Expanded(
            child: Text(
              title ?? '',
              style: KT.t3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (action != null) action! else const SizedBox(width: 40),
        ],
      ),
    );
  }
}

/// Step header — `.q-step`.
class KwStepHeader extends StatelessWidget {
  const KwStepHeader({
    super.key,
    required this.step,
    required this.total,
    required this.title,
    this.onBack,
    this.onClose,
  });

  final int step;
  final int total;
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(K.s3, K.s2, K.s3, K.s4),
      decoration: const BoxDecoration(color: K.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (onBack != null)
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_forward, size: 22, color: K.ink),
                  tooltip: 'رجوع',
                  splashRadius: 22,
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('الخطوة $step من $total', style: KT.cap),
                    const SizedBox(height: 2),
                    Text(title, style: KT.t2),
                  ],
                ),
              ),
              if (onClose != null)
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, size: 22, color: K.ink),
                  tooltip: 'إغلاق',
                  splashRadius: 22,
                ),
            ],
          ),
          const SizedBox(height: K.s2),
          Padding(
            padding: const EdgeInsets.only(right: K.s3),
            child: ClipRRect(
              borderRadius: K.rPill,
              child: LinearProgressIndicator(
                value: step / total,
                minHeight: 4,
                backgroundColor: K.hairline,
                valueColor: const AlwaysStoppedAnimation(K.brand),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom tab bar — `.q-tabbar`.
class KwTabBar extends StatelessWidget {
  const KwTabBar({super.key, required this.index, required this.onTap, this.badge = false});

  final int index;
  final ValueChanged<int> onTap;
  final bool badge;

  static const items = [
    (icon: 'home', label: 'الرئيسية'),
    (icon: 'receipt', label: 'طلباتي'),
    (icon: 'profile', label: 'حسابي'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(K.s2, K.s2, K.s2, K.s5),
      decoration: const BoxDecoration(color: K.surface, boxShadow: K.shadowSheet),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final active = i == index;
          final color = active ? K.brand : K.inkSubtle;
          final labelColor = active ? K.brandText : K.inkMuted;
          return Semantics(
            selected: active,
            button: true,
            label: items[i].label,
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 76,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 4),
                        KwIcon(items[i].icon, size: 26, color: color),
                        const SizedBox(height: 4),
                        Text(
                          items[i].label,
                          style: TextStyle(
                            fontFamily: 'Tajarib',
                            fontSize: 12,
                            height: 16 / 12,
                            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                            color: labelColor,
                          ),
                        ),
                      ],
                    ),
                    if (badge && i == 1)
                      Positioned(
                        top: -4,
                        right: 10,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: const BoxDecoration(
                            color: K.danger,
                            borderRadius: K.rPill,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '1',
                            style: TextStyle(
                              fontFamily: 'Tajarib',
                              fontSize: 11,
                              height: 18 / 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Bottom sheet — `.q-sheet` / `.kw-sheet`.
Future<T?> showKwSheet<T>(
  BuildContext context, {
  required String title,
  required Widget Function(BuildContext) builder,
  bool dismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x73000000),
    isDismissible: dismissible,
    builder: (ctx) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.86,
              maxWidth: K.screenWidth,
            ),
            decoration: const BoxDecoration(
              color: K.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(K.rLg)),
              boxShadow: K.shadowSheet,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: K.s3),
                Container(
                  width: 40,
                  height: 4,
                  decoration: const BoxDecoration(color: K.hairline, borderRadius: K.rPill),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(K.s6, K.s4, K.s6, K.s3),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(title, style: KT.t2),
                  ),
                ),
                Flexible(child: SingleChildScrollView(child: builder(ctx))),
                const SizedBox(height: K.s6),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Toast — `.q-toast`.
void showKwToast(BuildContext context, String message, {String icon = 'check'}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (ctx) => Positioned(
      left: K.s6,
      right: K.s6,
      top: MediaQuery.of(ctx).padding.top + K.s2,
      child: KwToast(message: message, icon: icon, onDone: () => entry.remove()),
    ),
  );
  overlay.insert(entry);
  Future.delayed(const Duration(milliseconds: 2600), () {
    if (entry.mounted) entry.remove();
  });
}

class KwToast extends StatefulWidget {
  const KwToast({super.key, required this.message, required this.onDone, this.icon = 'check'});

  final String message;
  final String icon;
  final VoidCallback onDone;

  @override
  State<KwToast> createState() => _KwToastState();
}

class _KwToastState extends State<KwToast> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 220))..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _c,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: K.s4, vertical: K.s3),
          decoration: BoxDecoration(color: K.ink, borderRadius: BorderRadius.circular(K.rMd)),
          child: Row(
            children: [
              Icon(
                widget.icon == 'check' ? Icons.check : Icons.info_outline,
                size: 20,
                color: K.brand,
              ),
              const SizedBox(width: K.s2),
              Expanded(
                child: Text(
                  widget.message,
                  style: const TextStyle(
                    fontFamily: 'Tajarib',
                    fontSize: 15,
                    height: 24 / 15,
                    fontWeight: FontWeight.w500,
                    color: K.surface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The كويلي wordmark — drawn from the prototype's four-path logo.
class KwWordmark extends StatelessWidget {
  const KwWordmark({super.key, this.height = 32, this.tone = KwWordmarkTone.brand});

  final double height;
  final KwWordmarkTone tone;

  static final List<String> paths = [
    'M272.69,201.35c0,17.02-4.23,35.59-10.22,44.23-5.93,8.7-14.77,13.09-26.37,13.09-6.32,0-11.41-1.74-15.28-5.22-3.93-3.48-6.38-8.51-7.35-14.96-6.06,13.41-17.34,20.18-33.98,20.18-3.22,0-6.19-.45-8.9-1.35.58,1.68.84,3.42.84,5.22,0,4.32-1.35,8.51-4.06,12.7-2.77,4.13-6.38,7.87-10.96,11.22-4.58,3.29-9.74,5.93-15.47,7.93-5.67,1.93-11.54,2.9-17.47,2.9-10.45,0-18.57-3.03-24.37-9.09-5.87-6.06-8.77-14.38-8.77-25.15,0-9.09,2.19-18.89,6.71-29.4,1.61.45,3.22.97,4.64,1.42,1.48.52,3.48,1.23,5.93,2.13-1.81,4.58-3.16,8.77-4,12.44-.77,3.74-1.23,7.35-1.23,10.9,0,15.73,7.54,23.6,22.63,23.6,4.13,0,8.25-.64,12.38-1.93,4.06-1.29,7.8-2.97,11.15-5.09,3.29-2.13,6-4.51,8-7.16,2-2.64,2.97-5.29,2.97-8,0-5.8-5.48-12.32-16.51-19.67.97-1.55,2-3.16,3.03-4.64,1.03-1.55,2.26-3.22,3.67-5.03.39.26.84.58,1.29.9.52.26,1.03.64,1.48.97,4.06,2.77,7.61,4.96,10.7,6.51,3.03,1.61,5.93,2.71,8.7,3.35,2.77.64,5.74,1.03,8.96,1.03,8.96,0,15.8-2.77,20.57-8.32,4.71-5.55,7.74-14.25,9.03-26.11.39-3.29.71-6.64,1.16-10.25.39-3.55.84-7.67,1.35-12.38.52-4.64,2.42-22.86,3.2-29.44,3.61-.45,7.61-.65,12.06-.65-1.03,7.22-3.13,26.99-3.97,34.02-.77,7.03-1.42,13.35-1.87,19.09-.19,2.45-.39,4.64-.45,6.51-.13,1.81-.19,3.35-.19,4.58,0,8.32,1.23,14.19,3.68,17.67,2.39,3.48,6.38,5.29,11.99,5.29,7.22,0,12.7-3.16,16.51-9.48,3.8-6.32,6.94-21.34,6.94-33.79,1.81-.26,3.74-.45,5.87-.58,2.06-.13,4.06-.19,6-.19Z',
    'M378.21,216.56c-4.45-6.77-10.77-13.99-18.96-21.6,14.12-6.32,25.47-16.76,33.46-30.82l-10.06-5.74c-10.64,18.7-28.37,29.79-51.26,31.98l1.1,11.54c4.96-.45,9.74-1.35,14.31-2.58,4.38,3.61,8.12,7.03,11.28,10.38,3.8,3.87,6.9,7.67,9.41,11.48,3.8,5.87,5.67,10.45,5.67,13.8,0,5.55-4.77,9.09-14.31,10.7-4.45.77-9.99,1.23-16.96,1.23h-.06c-2.26,0-4.32-.06-6.51-.06-2.19-.06-4.32-.13-6.51-.19,1.48-5.42,2.19-10.45,2.19-15.15,0-5.61-.97-10.7-2.84-15.15-1.93-4.45-4.51-8-7.8-10.57-3.22-2.58-6.96-3.87-11.15-3.87-3.16,0-6.25.84-9.28,2.51-2.97,1.68-5.74,3.87-8.19,6.71-2.45,2.84-4.45,6-5.87,9.41-1.48,3.48-2.19,7.03-2.19,10.64,0,6.32,2.51,11.86,7.54,16.51,5.03,4.71,12.06,8.12,20.96,10.19-2.97,5.22-6.58,10.25-10.77,15.09-4.19,4.84-13.09,12.9-17.86,16.38,2.26,1.81,4.32,3.29,6,4.45,1.74,1.16,3.55,2.32,5.48,3.48,5.09-4.32,14.18-13.41,18.44-19.34,4.32-5.87,7.87-11.99,10.7-18.38,5.03.39,10.45.65,16.38.65,9.16,0,16.7-.71,22.57-2.06,14.7-3.1,22.12-10.32,22.12-21.66,0-2.9-.58-6-1.61-9.35-1.1-3.29-2.9-6.83-5.42-10.57ZM317.99,245.45c-7.48-1.1-13.28-3.09-17.41-6-4.13-2.9-6.13-6.45-6.13-10.51,0-2.51.65-4.9,1.93-7.09,1.29-2.32,2.97-4.13,5.03-5.55,2.06-1.48,4.19-2.19,6.51-2.19,3.74,0,6.77,1.68,9.16,4.9,2.39,3.29,3.55,7.48,3.55,12.57,0,4.19-.9,8.77-2.64,13.86Z',
    'M113.98,323.19l-4.16-12.2c10.36-3.54,21.53-4.94,33.27-4.07l-.92,12.86c-10.11-.71-19.34.4-28.19,3.41Z',
    'M262.08,268.86l-.9,12.83c-1.68-.13-3.35-.19-4.9-.19h-1.29c-1.87,0-3.61.06-5.48.19-5.74.45-11.15,1.61-16.51,3.42l-4.19-12.19c10.38-3.55,21.54-4.96,33.27-4.06Z',
  ];

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      KwWordmarkTone.brand => K.brand,
      KwWordmarkTone.ink => K.ink,
    };
    return SizedBox(
      height: height,
      width: height * 311 / 174,
      child: CustomPaint(painter: _WordmarkPainter(color)),
    );
  }
}

enum KwWordmarkTone { brand, ink }

class _WordmarkPainter extends CustomPainter {
  _WordmarkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // viewBox is "86 154 311 174"
    const vb = Rect.fromLTWH(86, 154, 311, 174);
    final scale = math.min(size.width / vb.width, size.height / vb.height);
    final dx = (size.width - vb.width * scale) / 2 - vb.left * scale;
    final dy = (size.height - vb.height * scale) / 2 - vb.top * scale;

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale);
    final paint = Paint()..color = color;
    for (final d in KwWordmark.paths) {
      canvas.drawPath(cachedKwPath(d), paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_WordmarkPainter old) => old.color != color;
}
