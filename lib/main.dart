import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/root.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  applySystemChrome();
  runApp(const KwailiApp());
}

class KwailiApp extends StatefulWidget {
  const KwailiApp({super.key});

  @override
  State<KwailiApp> createState() => _KwailiAppState();
}

class _KwailiAppState extends State<KwailiApp> {
  final state = AppState();

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AppScope sits above MaterialApp so pushed routes can reach the state too.
    return AppScope(
      state: state,
      child: MaterialApp(
        title: 'كويلي — تطبيق الزبون',
        debugShowCheckedModeBanner: false,
        theme: buildKwailiTheme(),
        locale: const Locale('ar', 'IQ'),
        supportedLocales: const [Locale('ar', 'IQ'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) => Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        ),
        home: const RootScreen(),
      ),
    );
  }
}

/// Makes the shared [AppState] available to the widget tree.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in context');
    return scope!.notifier!;
  }

  /// Read without subscribing to rebuilds.
  static AppState read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in context');
    return scope!.notifier!;
  }
}
