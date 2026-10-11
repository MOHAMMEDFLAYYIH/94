import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens.dart';

/// App theme. RTL-first, Tajarib throughout, tokens from `tokens.dart`.
ThemeData buildKwailiTheme() {
  const scheme = ColorScheme.light(
    primary: K.action,
    onPrimary: K.onAction,
    secondary: K.brand,
    onSecondary: K.onAction,
    surface: K.surface,
    onSurface: K.ink,
    error: K.danger,
    onError: Colors.white,
  );

  TextStyle t(TextStyle s) => s.copyWith(fontFamily: 'Tajarib');

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Tajarib',
    scaffoldBackgroundColor: K.ground,
    splashFactory: InkSparkle.splashFactory,
    visualDensity: VisualDensity.standard,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: K.action,
      selectionColor: K.tintMint,
      selectionHandleColor: K.action,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
    textTheme: TextTheme(
      displayLarge: t(KT.display),
      headlineMedium: t(KT.t1),
      titleLarge: t(KT.t2),
      titleMedium: t(KT.t3),
      bodyMedium: t(KT.p),
      bodySmall: t(KT.cap),
      labelSmall: t(KT.label),
    ),
    dividerTheme: const DividerThemeData(color: K.hairline, thickness: 1, space: 1),
  );
}

/// `SystemChrome` setup — Arabic RTL, light status bar on the light surface.
void applySystemChrome() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: K.surface,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
}
