import 'dart:ui';

import 'package:path_parsing/path_parsing.dart';

/// Adapts a `dart:ui` [Path] to the `PathProxy` sink that
/// `writeSvgPathDataToPath` emits into.
class _PathSink implements PathProxy {
  _PathSink(this.path);

  final Path path;

  @override
  void moveTo(double x, double y) => path.moveTo(x, y);

  @override
  void lineTo(double x, double y) => path.lineTo(x, y);

  @override
  void cubicTo(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) =>
      path.cubicTo(x1, y1, x2, y2, x3, y3);

  @override
  void close() => path.close();
}

/// Parses an SVG path `d` attribute into a [Path].
///
/// Paths from the كويلي prototype are authored on a 24x24 grid (icons) or in
/// the `86 154 311 174` wordmark viewBox, so no scaling is applied here —
/// painters position the result themselves.
Path parseKwPath(String d) {
  final path = Path();
  writeSvgPathDataToPath(d, _PathSink(path));
  return path;
}

/// Memoised [parseKwPath] — painters re-run on every frame.
final Map<String, Path> _cache = <String, Path>{};

Path cachedKwPath(String d) => _cache.putIfAbsent(d, () => parseKwPath(d));
