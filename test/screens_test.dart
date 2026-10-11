import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kwaili/main.dart';
import 'package:kwaili/screens/account.dart';
import 'package:kwaili/screens/home.dart';
import 'package:kwaili/screens/info.dart';
import 'package:kwaili/screens/onboarding.dart';
import 'package:kwaili/screens/order_flow.dart';
import 'package:kwaili/screens/order_track.dart';
import 'package:kwaili/state/app_state.dart';

/// A deliberately cramped phone: the pinned home sheet plus tab bar must
/// degrade gracefully rather than overflow.
const small = Size(360, 640);
const tall = Size(390, 844);

Widget host(Widget child, AppState state) => AppScope(
      state: state,
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Tajarib'),
        home: Scaffold(
          backgroundColor: const Color(0xFFEFEFEF),
          body: Directionality(textDirection: TextDirection.rtl, child: child),
        ),
      ),
    );

void main() {
  AppState fresh() => AppState();

  Future<void> pumpAt(WidgetTester tester, Widget screen, {Size size = tall}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(host(screen, fresh()));
    await tester.pump(const Duration(milliseconds: 100));
  }

  void expectNoOverflow(WidgetTester tester) {
    final err = tester.takeException();
    expect(
      err,
      isNull,
      reason: 'screen threw during layout',
    );
  }

  group('every screen lays out without overflow', () {
    testWidgets('splash', (t) async {
      await pumpAt(t, SplashScreen(onDone: () {}));
      await t.pump(const Duration(seconds: 3)); // let the auto-advance timer fire
      expectNoOverflow(t);
    });

    testWidgets('area selection', (t) async {
      await pumpAt(t, AreaScreen(onNext: () {}, onWaitlist: () {}));
      expect(find.text('نبدأ بحيّ واحد في بغداد'), findsOneWidget);
      expectNoOverflow(t);
    });

    testWidgets('waitlist', (t) async {
      await pumpAt(t, WaitlistScreen(onPrices: () {}, onRegistered: () {}));
      expect(find.text('لم نصل حيّك بعد'), findsOneWidget);
      expectNoOverflow(t);
    });

    testWidgets('phone entry', (t) async {
      await pumpAt(t, PhoneScreen(onNext: () {}));
      expectNoOverflow(t);
    });

    testWidgets('otp', (t) async {
      await pumpAt(t, OtpScreen(onNext: () {}));
      expectNoOverflow(t);
    });

    testWidgets('home — with an active order', (t) async {
      await pumpAt(t, const HomeScreen(
        onOrder: _noop,
        onPrices: _noop,
        onProtect: _noop,
        onOrders: _noop,
        onAccount: _noop,
        onRecurring: _noop,
        onConfirmCount: _noop,
        onOrderDetail: _noop,
      ));
      expect(find.text('طلبك الجاري'), findsOneWidget);
      expectNoOverflow(t);
    });

    testWidgets('home — guest, no pinned order', (t) async {
      final state = AppState()..registered = false;
      t.view.physicalSize = tall;
      t.view.devicePixelRatio = 1.0;
      addTearDown(t.view.reset);
      await t.pumpWidget(host(
        const HomeScreen(
          onOrder: _noop,
          onPrices: _noop,
          onProtect: _noop,
          onOrders: _noop,
          onAccount: _noop,
          onRecurring: _noop,
          onConfirmCount: _noop,
          onOrderDetail: _noop,
        ),
        state,
      ));
      await t.pump(const Duration(milliseconds: 100));
      expectNoOverflow(t);
    });

    testWidgets('home on a 360x640 screen does not overflow', (t) async {
      await pumpAt(
        t,
        const HomeScreen(
          onOrder: _noop,
          onPrices: _noop,
          onProtect: _noop,
          onOrders: _noop,
          onAccount: _noop,
          onRecurring: _noop,
          onConfirmCount: _noop,
          onOrderDetail: _noop,
        ),
        size: small,
      );
      expectNoOverflow(t);
    });

    testWidgets('items step 1', (t) async {
      await pumpAt(t, ItemsScreen(onNext: _noop, onClose: _noop));
      expect(find.text('الخطوة 1 من 4'), findsOneWidget);
      expectNoOverflow(t);
    });

    testWidgets('add another item', (t) async {
      await pumpAt(t, AddItemScreen(onAdd: (_, __, ___) {}, onClose: _noop));
      expectNoOverflow(t);
    });

    testWidgets('address step 2', (t) async {
      await pumpAt(t, AddressScreen(onNext: _noop, onBack: _noop, onClose: _noop));
      expectNoOverflow(t);
    });

    testWidgets('address step 2 — out of range shows the alert', (t) async {
      final state = AppState()..selectAddress('work');
      t.view.physicalSize = tall;
      t.view.devicePixelRatio = 1.0;
      addTearDown(t.view.reset);
      await t.pumpWidget(host(
        AddressScreen(onNext: _noop, onBack: _noop, onClose: _noop),
        state,
      ));
      await t.pump(const Duration(milliseconds: 100));
      expect(find.text('هذا العنوان خارج منطقة الخدمة الآن.'), findsOneWidget);
      expectNoOverflow(t);
    });

    testWidgets('schedule step 3', (t) async {
      await pumpAt(t, ScheduleScreen(onNext: _noop, onBack: _noop, onClose: _noop));
      expectNoOverflow(t);
    });

    testWidgets('review step 4', (t) async {
      await pumpAt(t, ReviewScreen(
        onConfirm: _noop,
        onEditItems: _noop,
        onEditAddress: _noop,
        onEditSchedule: _noop,
      ));
      expect(find.text('المبلغ المتوقّع'), findsWidgets);
      expectNoOverflow(t);
    });

    testWidgets('order failure', (t) async {
      await pumpAt(t, OrderFailureScreen(mode: 'send', onRetry: _noop));
      expectNoOverflow(t);
    });

    testWidgets('order confirmed', (t) async {
      await pumpAt(t, OrderConfirmedScreen(onHome: _noop));
      expectNoOverflow(t);
    });

    testWidgets('prices', (t) async {
      await pumpAt(t, PricesScreen(onOrder: _noop));
      expectNoOverflow(t);
    });

    testWidgets('no search results', (t) async {
      await pumpAt(t, NoResultsScreen(onAdd: _noop, onOrder: _noop));
      expectNoOverflow(t);
    });

    testWidgets('protect your clothes', (t) async {
      await pumpAt(t, ProtectScreen(onOrder: _noop));
      expectNoOverflow(t);
    });

    testWidgets('loading home skeleton', (t) async {
      await pumpAt(t, const LoadingHomeScreen());
      expectNoOverflow(t);
    });

    testWidgets('offline', (t) async {
      await pumpAt(t, OfflineScreen(onRetry: _noop));
      expectNoOverflow(t);
    });

    testWidgets('error', (t) async {
      await pumpAt(t, ErrorScreen(onRetry: _noop, onOrders: _noop));
      expectNoOverflow(t);
    });

    testWidgets('order detail — needs reply', (t) async {
      await pumpAt(t, OrderDetailScreen(
        onHelp: _noop,
        onReschedule: _noop,
        onPrice: _noop,
        onRecord: _noop,
        onReport: _noop,
      ));
      expectNoOverflow(t);
    });

    testWidgets('order detail — delay variant', (t) async {
      await pumpAt(t, OrderDetailScreen(
        onHelp: _noop,
        onReschedule: _noop,
        onPrice: _noop,
        onRecord: _noop,
        onReport: _noop,
        variant: OrderDetailVariant.delay,
      ));
      expectNoOverflow(t);
    });

    testWidgets('order detail — follow-up variant', (t) async {
      await pumpAt(t, OrderDetailScreen(
        onHelp: _noop,
        onReschedule: _noop,
        onPrice: _noop,
        onRecord: _noop,
        onReport: _noop,
        variant: OrderDetailVariant.followUp,
      ));
      expectNoOverflow(t);
    });

    testWidgets('count confirmation', (t) async {
      await pumpAt(t, CountConfirmScreen(onDone: _noop));
      expectNoOverflow(t);
    });

    testWidgets('price change approval', (t) async {
      await pumpAt(t, PriceChangeScreen(onDone: _noop));
      expectNoOverflow(t);
    });

    testWidgets('out for delivery', (t) async {
      await pumpAt(t, DeliveryScreen(
        delivered: false,
        onRate: _noop,
        onReport: _noop,
        onRepeat: _noop,
        onRecord: _noop,
      ));
      expectNoOverflow(t);
    });

    testWidgets('delivered', (t) async {
      await pumpAt(t, DeliveryScreen(
        delivered: true,
        onRate: _noop,
        onReport: _noop,
        onRepeat: _noop,
        onRecord: _noop,
      ));
      expectNoOverflow(t);
    });

    testWidgets('map tracking', (t) async {
      await pumpAt(t, const MapTrackingScreen());
      await t.pump(const Duration(seconds: 5));
      expectNoOverflow(t);
    });

    testWidgets('delivery record', (t) async {
      await pumpAt(t, const DeliveryRecordScreen());
      expectNoOverflow(t);
    });

    testWidgets('rating', (t) async {
      await pumpAt(t, const RatingScreen());
      expectNoOverflow(t);
    });

    testWidgets('orders — current', (t) async {
      await pumpAt(t, OrdersScreen(
        onHome: _noop,
        onAccount: _noop,
        onOrderDetail: _noop,
        onPrice: _noop,
        onCount: _noop,
        onLogin: _noop,
        onOrder: _noop,
      ));
      expectNoOverflow(t);
    });

    testWidgets('account', (t) async {
      await pumpAt(t, AccountScreen(
        onHome: _noop,
        onOrders: _noop,
        onLogin: _noop,
        onNotifications: _noop,
      ));
      expectNoOverflow(t);
    });

    testWidgets('notification settings', (t) async {
      await pumpAt(t, const NotificationSettingsScreen());
      expectNoOverflow(t);
    });

    testWidgets('notifications list', (t) async {
      await pumpAt(t, NotificationsScreen(onOpen: (_) {}));
      expectNoOverflow(t);
    });

    testWidgets('report an issue', (t) async {
      await pumpAt(t, ReportScreen(onSent: _noop));
      expectNoOverflow(t);
    });

    testWidgets('report status — reviewing', (t) async {
      await pumpAt(t, const ReportStatusScreen());
      expectNoOverflow(t);
    });

    testWidgets('report status — decided', (t) async {
      await pumpAt(t, const ReportStatusScreen(decided: true));
      expectNoOverflow(t);
    });

    testWidgets('recurring slot', (t) async {
      await pumpAt(t, const RecurringScreen());
      expectNoOverflow(t);
    });

    testWidgets('reschedule delivery', (t) async {
      await pumpAt(t, const RescheduleScreen());
      expectNoOverflow(t);
    });
  });
}

void _noop() {}
