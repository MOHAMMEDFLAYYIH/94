
import 'package:flutter/material.dart';
import 'svg_path.dart';
import 'tokens.dart';

/// The كويلي icon set — 34 glyphs on a 24x24 grid.
/// Paths are lifted verbatim from the prototype's `Kwaili.Icon` map plus the
/// inline SVGs used inside screen markup, so they render pixel-identically.
class KwIcons {
  KwIcons._();

  static const Map<String, String> paths = {
  'home': 'M11.3 2.9a1 1 0 0 1 1.4 0l9 9c.4.4.2 1.1-.4 1.1H19.5v8H4.5v-8H2.7c-.6 0-.8-.7-.4-1.1Z',
  'basket': 'M2.5 7h19c.6 0 1 .5.9 1.1l-.3 1.4H1.9l-.3-1.4C1.5 7.5 1.9 7 2.5 7ZM2.4 11h19.2l-1.8 9.2a1 1 0 0 1-1 .8H5.2a1 1 0 0 1-1-.8Zm5.4 2.2v5h1.8v-5Zm3.3 0v5h1.8v-5Zm3.3 0v5h1.8v-5ZM6.9 2.6l1.6-.9 3 5.3H9.2Zm10.2 0-1.6-.9-3 5.3h2.3Z',
  'iron': 'M9.5 4h9a2 2 0 0 1 2 2v3.5h-2.2V6.2H11.7V9H9.5ZM7 10.5h11a4.5 4.5 0 0 1 4.5 4.5V19a1 1 0 0 1-1 1H2.1a.7.7 0 0 1-.6-1l2.3-5.5A5 5 0 0 1 7 10.5Z',
  'receipt': 'M5 2h14a1 1 0 0 1 1 1v15.6L16.6 22H5a1 1 0 0 1-1-1V3a1 1 0 0 1 1-1Z',
  'profile': 'M12 2a3.6 3.6 0 1 1 0 7.2A3.6 3.6 0 0 1 12 2ZM4.6 12.7l4.8-1.4 2.6 4.4 2.6-4.4 4.8 1.4c.4.1.6.5.6.9V22H4v-8.4c0-.4.2-.8.6-.9Z',
  'shirt': 'M8.5 3h7l1 .3 5.2 3.1c.4.2.5.7.3 1.1l-2 3.6c-.3.4-.8.6-1.2.3L18 10.6V20a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1v-9.4l-.8.8c-.4.3-.9.1-1.2-.3l-2-3.6c-.2-.4-.1-.9.3-1.1L7.5 3.3Zm.6 0a2.9 2.9 0 0 0 5.8 0Z',
  'hanger': 'M12 2.5a3 3 0 0 1 3 3c0 1.3-.8 2.2-1.9 2.7l-.1.1v.9l9.2 6.6c.8.6.4 1.7-.6 1.7H2.4c-1 0-1.4-1.1-.6-1.7L11 9.2V7.4c0-.5.4-1 .9-1.1.6-.1 1.1-.4 1.1-.8a1 1 0 0 0-2 0H9a3 3 0 0 1 3-3Z',
  'truck': 'M2 5h12a1 1 0 0 1 1 1v2h3.5c.3 0 .6.1.8.4l2.5 3.3c.1.2.2.4.2.6V17a1 1 0 0 1-1 1h-1.1a2.9 2.9 0 0 0-5.8 0H9.9a2.9 2.9 0 0 0-5.8 0H2a1 1 0 0 1-1-1V6a1 1 0 0 1 1-1Zm13 5v3h4.6l-2.2-3ZM7 16.2a1.8 1.8 0 1 1 0 3.6 1.8 1.8 0 0 1 0-3.6Zm10 0a1.8 1.8 0 1 1 0 3.6 1.8 1.8 0 0 1 0-3.6Z',
  'clock': 'M12 2a10 10 0 1 1 0 20 10 10 0 0 1 0-20Zm-1 5v6.2l4.9 2.9 1-1.7-3.9-2.3V7Z',
  'check': 'M12 2a10 10 0 1 1 0 20 10 10 0 0 1 0-20Zm4.3 6.3-5.6 5.6-3-3-1.4 1.4 4.4 4.4 7-7Z',
  'pin': 'M12 2a7.5 7.5 0 0 1 7.5 7.5c0 5.2-6 11.2-6.8 12a1 1 0 0 1-1.4 0c-.8-.8-6.8-6.8-6.8-12A7.5 7.5 0 0 1 12 2Zm0 4.5a3 3 0 1 0 0 6 3 3 0 0 0 0-6Z',
  'bell': 'M12 2a6.5 6.5 0 0 1 6.5 6.5v4.3l1.8 3c.4.7-.1 1.5-.9 1.5H4.6c-.8 0-1.3-.8-.9-1.5l1.8-3V8.5A6.5 6.5 0 0 1 12 2Zm-2.8 16.5h5.6a2.8 2.8 0 0 1-5.6 0Z',
  'plus': 'M10.8 4h2.4v6.8H20v2.4h-6.8V20h-2.4v-6.8H4v-2.4h6.8Z',
  'close': 'm5.6 3.9 6.4 6.4 6.4-6.4 1.7 1.7-6.4 6.4 6.4 6.4-1.7 1.7-6.4-6.4-6.4 6.4-1.7-1.7 6.4-6.4-6.4-6.4Z',
  'chevron-left': 'M15.3 3.3 17 5l-7 7 7 7-1.7 1.7L6.6 12Z',
  'chevron-right': 'M8.7 3.3 7 5l7 7-7 7 1.7 1.7 8.7-8.7Z',
  'sparkle': 'M12 1.5c.4 0 .7.3.8.6l1.3 5.4c.2.6.6 1.1 1.2 1.2l5.4 1.3c.7.2.7 1.4 0 1.6l-5.4 1.3c-.6.2-1.1.6-1.2 1.2l-1.3 5.4c-.2.7-1.4.7-1.6 0L9.9 13.1c-.2-.6-.6-1.1-1.2-1.2L3.3 10.6c-.7-.2-.7-1.4 0-1.6l5.4-1.3c.6-.2 1.1-.6 1.2-1.2l1.3-5.4c.1-.3.4-.6.8-.6Z',
  'search': 'M10.5 3a7.5 7.5 0 0 1 6 12l4.3 4.3-1.8 1.8-4.3-4.3A7.5 7.5 0 1 1 10.5 3Zm0 2.5a5 5 0 1 0 0 10 5 5 0 0 0 0-10Z',
  'minus': 'M4 10.8h16v2.4H4Z',
  'info': 'M12 2a10 10 0 1 1 0 20 10 10 0 0 1 0-20Zm-1.2 5v7h2.4V7Zm0 8.6V18h2.4v-2.4Z',
  'cash': 'M2 6h20v12H2Zm10 3a3 3 0 1 0 0 6 3 3 0 0 0 0-6ZM4.5 8.5v2a2 2 0 0 0 2-2Zm15 0h-2a2 2 0 0 0 2 2Zm-15 7v-2a2 2 0 0 1 2 2Zm15 0v-2a2 2 0 0 0-2 2Z',
  'star': 'M12 2.6l2.9 5.9 6.5.9-4.7 4.6 1.1 6.5L12 17.4 6.2 20.5l1.1-6.5L2.6 9.4l6.5-.9Z',
  'camera': 'M9.4 4h5.2l1.3 2H20a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4.1ZM12 8.5a3.5 3.5 0 1 0 0 7 3.5 3.5 0 0 0 0-7Z',
  'whatsapp': 'M12 2a10 10 0 0 0-8.6 15L2 22l5.2-1.4A10 10 0 1 0 12 2Zm5.1 13.6c-.2.6-1.2 1.2-1.7 1.2-.5.1-1 .1-1.7-.1-.4-.2-.9-.3-1.5-.5-2.6-1.1-4.3-3.7-4.4-3.9-.1-.2-1-1.3-1-2.6s.6-1.8.9-2.1c.2-.2.5-.3.7-.3h.5c.2 0 .4-.1.6.4l.8 1.9c.1.2.1.4 0 .5l-.3.5-.4.4c-.1.1-.3.3-.1.6.1.3.6 1 1.3 1.6.9.8 1.6 1 1.9 1.2.2.1.4 0 .5-.1l.7-.8c.2-.2.3-.2.6-.1l1.8.9c.2.1.4.2.4.3.1.1.1.7-.1 1.3Z',
  'phone': 'M6.6 2.9a1.6 1.6 0 0 1 1.7.4l1.5 2.2c.3.5.3 1.1 0 1.6l-.8 1.2a12.4 12.4 0 0 0 4.7 4.7l1.2-.8c.5-.3 1.1-.3 1.6 0l2.2 1.5a1.6 1.6 0 0 1 .4 1.7l-.9 1.7a2 2 0 0 1-2.3 1A15.6 15.6 0 0 1 3.9 6.2a2 2 0 0 1 1-2.3Z',
  'shield': 'M12 2.2l8 3v6c0 5-3.4 9.3-8 10.6-4.6-1.3-8-5.6-8-10.6v-6Zm-1.2 12.4 5.6-5.6-1.7-1.7-3.9 3.9-1.6-1.6-1.7 1.7Z',
  'bag': 'M6 7h12l1 14H5ZM9 7V5a3 3 0 0 1 6 0v2',
  'help': 'M12 2a10 10 0 1 1 0 20 10 10 0 0 1 0-20Zm.1 14.4a1.2 1.2 0 1 0 0 2.4 1.2 1.2 0 0 0 0-2.4ZM12 6.2c-1.9 0-3.3 1.2-3.4 3h2.1c0-.7.5-1.2 1.3-1.2s1.2.4 1.2 1c0 .5-.3.9-.9 1.3-1 .6-1.5 1.2-1.5 2.3v.5h2v-.4c0-.6.2-.9.9-1.4 1-.6 1.5-1.3 1.5-2.4 0-1.6-1.4-2.7-3.2-2.7Z',
  'logout': 'M10 3v2H5v14h5v2H3V3ZM16 6l5 6-5 6v-4H9v-4h7Z',
  'trash': 'M9 3h6l1 2h5v2H3V5h5ZM5 8h14l-1 13H6Z',
  'pause': 'M7 4h4v16H7Zm6 0h4v16h-4Z',
  'alert': 'M12 2a10 10 0 1 1 0 20 10 10 0 0 1 0-20Zm-1.2 5v7h2.4V7Zm0 8.6V18h2.4v-2.4Z',
  'image': 'M3 4h18v16H3Zm2 13 4.5-5 3 3.4L15 12l4 5ZM8.5 9a1.4 1.4 0 1 0 0-2.8 1.4 1.4 0 0 0 0 2.8Z',
  'edit': 'M4 16.5 15.1 5.4l3.5 3.5L7.5 20H4ZM17.2 3.3l1.4-1.4 3.5 3.5-1.4 1.4Z',
  'washer': 'M4 3h16a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2Zm0 2v3h16V5H4Zm8 5a5 5 0 1 0 0 10 5 5 0 0 0 0-10Zm0 2a3 3 0 1 1 0 6 3 3 0 0 1 0-6Z',
  'jacket': 'M8 2 3 5v5l3-1v11a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V9l3 1V5l-5-3-4 5-4-5Zm4 7.5L14 12v8h-4v-8l2-2.5Z',
  };

  static const List<String> names = [
    'home',
    'basket',
    'iron',
    'receipt',
    'profile',
    'shirt',
    'hanger',
    'truck',
    'clock',
    'check',
    'pin',
    'bell',
    'plus',
    'close',
    'chevron-left',
    'chevron-right',
    'sparkle',
    'search',
    'minus',
    'info',
    'cash',
    'star',
    'camera',
    'whatsapp',
    'phone',
    'shield',
    'bag',
    'help',
    'logout',
    'trash',
    'pause',
    'alert',
    'image',
    'edit',
  ];

  static String? pathOf(String name) => paths[name];
}

class KwIcon extends StatelessWidget {
  const KwIcon(this.name, {super.key, this.size = 24, this.color, this.semanticLabel});

  final String name;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final d = KwIcons.pathOf(name);
    if (d == null) return SizedBox(width: size, height: size);
    final c = color ?? DefaultTextStyle.of(context).style.color ?? K.ink;
    return Semantics(
      label: semanticLabel,
      image: semanticLabel != null,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _KwIconPainter(d, c)),
      ),
    );
  }
}

class _KwIconPainter extends CustomPainter {
  _KwIconPainter(this.d, this.color);

  final String d;
  final Color color;
  Path? _path;

  @override
  void paint(Canvas canvas, Size size) {
    _path ??= cachedKwPath(d);
    final s = size.width / 24.0;
    canvas.save();
    canvas.scale(s);
    canvas.drawPath(
      _path!,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill
        ..isAntiAlias = true,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_KwIconPainter old) => old.color != color || old.d != d;
}
