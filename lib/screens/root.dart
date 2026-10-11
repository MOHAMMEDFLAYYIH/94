import 'package:flutter/material.dart';

import '../main.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/chrome.dart';
import 'account.dart';
import 'home.dart';
import 'info.dart';
import 'onboarding.dart';
import 'order_flow.dart';
import 'order_track.dart';

/// Root shell — boots the splash then hands off to the main flow.
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  bool booted = false;

  @override
  Widget build(BuildContext context) {
    if (!booted) {
      return SplashScreen(onDone: () {
        if (mounted) setState(() => booted = true);
      });
    }
    return const _MainFlow();
  }
}

/// Where the user is in the prototype's navigation graph. Tabs and push
/// routes both resolve through here so back behaviour matches the mock.
class _MainFlow extends StatefulWidget {
  const _MainFlow();

  @override
  State<_MainFlow> createState() => _MainFlowState();
}

class _MainFlowState extends State<_MainFlow> {
  int tab = 0;

  void go(int next) => setState(() => tab = next);

  void push(Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return switch (tab) {
      1 => OrdersScreen(
          onHome: () => go(0),
          onAccount: () => go(2),
          onOrderDetail: () => _detail(context),
          onPrice: () => push(PriceChangeScreen(onDone: _pop)),
          onCount: () => push(CountConfirmScreen(onDone: _pop)),
          onLogin: () => _phone(context),
          onOrder: () => _items(context),
        ),
      2 => AccountScreen(
          onHome: () => go(0),
          onOrders: () => go(1),
          onLogin: () => _phone(context),
          onNotifications: () => push(const NotificationSettingsScreen()),
        ),
      _ => HomeScreen(
          onOrder: () => _items(context),
          onPrices: () => push(PricesScreen(onOrder: () => _items(context))),
          onProtect: () => push(ProtectScreen(onOrder: () => _items(context))),
          onOrders: () => go(1),
          onAccount: () => go(2),
          onRecurring: () => push(const RecurringScreen()),
          onConfirmCount: () => push(CountConfirmScreen(onDone: _pop)),
          onOrderDetail: () => _detail(context),
        ),
    };
  }

  void _pop() {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  void _phone(BuildContext context) => push(PhoneScreen(
        onNext: () => push(OtpScreen(
          onNext: () {
            final app = AppScope.read(context);
            app.registered = true;
            _pop();
            _pop();
            showKwToast(context, 'تم تسجيل الدخول');
          },
        )),
      ));

  void _items(BuildContext context) {
    push(ItemsScreen(
      onClose: () async {
        final save = await _confirmExit(context);
        if (save == true && context.mounted) _pop();
      },
      onAddOther: () => push(AddItemScreen(
        onAdd: (name, service, qty) {
          final app = AppScope.read(context);
          final match = kCatalogName(name);
          app.addCustom(match, service, qty);
          _pop();
          showKwToast(context, 'أضفنا $name');
        },
        onClose: _pop,
      )),
      onNext: () => push(AddressScreen(
        onBack: _pop,
        onClose: () async {
          final save = await _confirmExit(context);
          if (save == true && context.mounted) {
            _pop();
            _pop();
          }
        },
        onNext: () => push(ScheduleScreen(
          onBack: _pop,
          onClose: _pop,
          onNext: () => push(ReviewScreen(
            onEditItems: _pop,
            onEditAddress: _pop,
            onEditSchedule: _pop,
            onConfirm: () {
              final app = AppScope.read(context);
              app.registered = true;
              _pop();
              push(OrderConfirmedScreen(onHome: _pop));
            },
          )),
        )),
      )),
    ));
  }

  Future<bool?> _confirmExit(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: const BoxDecoration(
            color: K.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(K.rLg)),
            boxShadow: K.shadowSheet,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: K.s3),
                Container(
                  width: 40,
                  height: 4,
                  decoration:
                      const BoxDecoration(color: K.hairline, borderRadius: K.rPill),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(K.s6, K.s4, K.s6, K.s3),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('نحفظ طلبك كمسودة؟', style: KT.t2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: K.s6),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'تجد القطع والعنوان كما تركتها عند عودتك إلى «اطلب استلاماً».',
                      style: KT.p,
                    ),
                  ),
                ),
                const SizedBox(height: K.s5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: K.s6),
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: K.screenWidth),
                        child: Column(
                          children: [
                            _SheetBtn(
                              'احفظ واخرج',
                              primary: true,
                              onTap: () => Navigator.of(ctx).pop(true),
                            ),
                            const SizedBox(height: K.s3),
                            _SheetBtn(
                              'أكمل الطلب',
                              primary: false,
                              onTap: () => Navigator.of(ctx).pop(false),
                            ),
                            const SizedBox(height: K.s3),
                            _SheetBtn(
                              'احذف المسودة',
                              primary: false,
                              danger: true,
                              onTap: () => Navigator.of(ctx).pop(false),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: K.s6),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _detail(BuildContext context) {
    push(OrderDetailScreen(
      onHelp: () => showKwSheet<void>(
        context,
        title: 'المساعدة في هذا الطلب',
        builder: (_) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: K.s6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('تواصل معنا عبر واتساب برسالة فيها رمز طلبك، أو اتصل بنا.', style: KT.p),
              SizedBox(height: K.s5),
            ],
          ),
        ),
      ),
      onReport: () => push(ReportScreen(
        onSent: () {
          _pop();
          showKwToast(context, 'استلمنا بلاغك');
          push(const ReportStatusScreen());
        },
      )),
      onReschedule: () => push(const RescheduleScreen()),
      onRecord: () => push(const DeliveryRecordScreen()),
      onPrice: () => push(PriceChangeScreen(
        onDone: () {
          _pop();
          showKwToast(context, 'سجّلنا موافقتك');
        },
      )),
    ));
  }
}

class _SheetBtn extends StatelessWidget {
  const _SheetBtn(this.label, {required this.primary, required this.onTap, this.danger = false});

  final String label;
  final bool primary;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final bg = primary
        ? K.brand
        : danger
            ? Colors.transparent
            : K.tintGreen;
    final fg = primary ? Colors.white : (danger ? K.danger : K.brandText);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: K.rPill,
          border: danger ? Border.all(color: K.danger, width: 1.5) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajarib',
            fontSize: 15,
            height: 24 / 15,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
      ),
    );
  }
}

/// Maps a free-text garment name onto a catalogue id.
String kCatalogName(String name) {
  final n = name.trim();
  for (final g in kCatalog) {
    if (n.contains(g.name) || g.name.contains(n)) return g.id;
  }
  return 'tshirt';
}
