import 'package:flutter/material.dart';

/// كويلي — design tokens.
/// Ported 1:1 from the `tokens.css` custom properties of the كويلي design system.
class K {
  K._();

  // ---- colour ----
  static const brand = Color(0xFF0DC189);
  static const brandSoft = Color(0xFF58BE8D);
  static const brandText = Color(0xFF08704F);
  static const action = Color(0xFF098760);
  static const actionPressed = Color(0xFF076A4B);
  static const onAction = Color(0xFFFFFFFF);

  static const tintGreen = Color(0xFFABFFCD);
  static const tintMint = Color(0xFFBCFFF5);
  static const tintGrey = Color(0xFFE9E9E7);

  static const black = Color(0xFF111111);
  static const white = Color(0xFFFFFFFF);

  static const ground = Color(0xFFEFEFEF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSunken = Color(0xFFF7F7F7);
  static const hairline = Color(0xFFEBEBEB);

  static const ink = Color(0xFF111111);
  static const inkMuted = Color(0xFF6B6B6B);
  static const inkSubtle = Color(0xFF949494);
  static const accentSpark = Color(0xFFF08A5D);
  static const danger = Color(0xFFC62F2F);
  static const focus = Color(0xFF098760);

  // ---- space ----
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 12.0;
  static const s4 = 16.0;
  static const s5 = 20.0;
  static const s6 = 24.0;
  static const s8 = 32.0;
  static const s10 = 40.0;

  // ---- radius ----
  static const rSm = 6.0;
  static const rMd = 12.0;
  static const rLg = 24.0;
  static const rXl = 40.0;

  static const rPill = BorderRadius.all(Radius.circular(999));

  static const shadowSheet = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 24, offset: Offset(0, -6)),
  ];

  static const shadowCard = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  /// 390pt design width from the prototype.
  static const screenWidth = 390.0;
}

/// Type ramp — `.q-*` / `.kw-*` classes from the design system.
class KT {
  KT._();

  static const display = TextStyle(
      fontSize: 40, height: 52 / 40, fontWeight: FontWeight.w900, color: K.ink);
  static const t1 = TextStyle(
      fontSize: 26, height: 38 / 26, fontWeight: FontWeight.w700, color: K.ink);
  static const t2 = TextStyle(
      fontSize: 20, height: 30 / 20, fontWeight: FontWeight.w700, color: K.ink);
  static const t3 = TextStyle(
      fontSize: 17, height: 26 / 17, fontWeight: FontWeight.w700, color: K.ink);
  static const p = TextStyle(
      fontSize: 15, height: 24 / 15, fontWeight: FontWeight.w400, color: K.ink);
  static const strong = TextStyle(
      fontSize: 15, height: 24 / 15, fontWeight: FontWeight.w500, color: K.ink);
  static const cap = TextStyle(
      fontSize: 13, height: 20 / 13, fontWeight: FontWeight.w400, color: K.inkMuted);
  static const label = TextStyle(
      fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w500, color: K.ink);
  static const num = TextStyle(
      fontSize: 16,
      height: 22 / 16,
      fontWeight: FontWeight.w500,
      color: K.ink,
      fontFeatures: [FontFeature.tabularFigures()]);

  /// Tabular LTR numerals — `.q-ltr`.
  static TextStyle ltr(TextStyle base) => base.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle green(TextStyle base) => base.copyWith(color: K.brandText);
  static TextStyle muted(TextStyle base) => base.copyWith(color: K.inkMuted);
}
