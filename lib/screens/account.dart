import 'package:flutter/material.dart';

import '../main.dart';
import '../state/app_state.dart';
import '../theme/icons.dart';
import '../theme/tokens.dart';
import '../widgets/chrome.dart';
import '../widgets/controls.dart';
import '../widgets/layout.dart';
import 'catalog_index.dart';

/// C2 · طلباتي.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    super.key,
    required this.onHome,
    required this.onAccount,
    required this.onOrderDetail,
    required this.onPrice,
    required this.onCount,
    required this.onLogin,
    required this.onOrder,
  });

  final VoidCallback onHome;
  final VoidCallback onAccount;
  final VoidCallback onOrderDetail;
  final VoidCallback onPrice;
  final VoidCallback onCount;
  final VoidCallback onLogin;
  final VoidCallback onOrder;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int seg = 0;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return KwScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header matching C2 PNG
          Padding(
            padding: const EdgeInsets.fromLTRB(K.s6, K.s10, K.s6, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('طلباتي', style: KT.t1),
                ),
                if (app.registered) ...[
                  const SizedBox(height: K.s4),
                  _UnderlineTabs(
                    index: seg,
                    labels: const ['الحالية', 'المجدولة', 'السابقة'],
                    onTap: (i) => setState(() => seg = i),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: !app.registered
                ? _emptyState(context)
                : seg == 0
                    ? _currentOrders(context, app)
                    : seg == 1
                        ? _scheduled(context)
                        : _past(context),
          ),
          KwTabBar(
            index: 1,
            badge: app.registered && seg == 0,
            onTap: (i) => [widget.onHome, widget.onAccount][i == 0 ? 0 : 1](),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(K.s6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: K.tintGreen,
              borderRadius: BorderRadius.circular(K.rLg),
            ),
            alignment: Alignment.center,
            child: const KwIcon('phone', size: 52, color: K.brand),
          ),
          const SizedBox(height: K.s6),
          const Text('سجّل برقم هاتفك لترى طلباتك', style: KT.t2, textAlign: TextAlign.center),
          const SizedBox(height: K.s2),
          const Text(
            'نحفظ طلباتك ومواعيدك على رقمك، وتتابعها من هنا.',
            textAlign: TextAlign.center,
            style: KT.p,
          ),
          const SizedBox(height: K.s6),
          KwButton('سجّل الدخول', block: false, onPressed: widget.onLogin),
        ],
      ),
    );
  }

  Widget _currentOrders(BuildContext context, AppState app) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(K.s6, K.s4, K.s6, K.s8),
      children: [
        // Q-0142 (with action needed green border)
        GestureDetector(
          onTap: widget.onOrderDetail,
          child: Container(
            padding: const EdgeInsets.all(K.s4),
            decoration: BoxDecoration(
              color: K.surface,
              borderRadius: BorderRadius.circular(K.rMd),
              border: Border.all(color: K.action, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Ltr('Q-0142', style: TextStyle(fontFamily: 'Tajarib', fontSize: 15, fontWeight: FontWeight.w700)),
                            SizedBox(width: 6),
                            KwBadge('قيد التجهيز', tone: KwBadgeTone.neutral),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    KwBadge('يحتاج ردّك', tone: KwBadgeTone.danger),
                  ],
                ),
                const SizedBox(height: K.s3),
                const KwMiniTracker(done: 3),
                const SizedBox(height: K.s3),
                Text(
                  'قطعة إضافية بـ 2,000 د.ع — توافق؟',
                  style: KT.t3.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 2),
                const Row(
                  children: [
                    Expanded(child: Text('12 قطعة · جاهزة قبل السبت 10 أكتوبر', style: KT.cap)),
                    KwIcon('chevron-left', size: 14, color: K.inkSubtle),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: K.s3),
        // Q-0139
        GestureDetector(
          onTap: widget.onOrderDetail,
          child: Container(
            padding: const EdgeInsets.all(K.s4),
            decoration: BoxDecoration(
              color: K.surface,
              borderRadius: BorderRadius.circular(K.rMd),
              border: Border.all(color: K.hairline),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Ltr('Q-0139', style: TextStyle(fontFamily: 'Tajarib', fontSize: 16, fontWeight: FontWeight.w700)),
                    SizedBox(width: K.s2),
                    KwBadge('جاهزة', tone: KwBadgeTone.neutral),
                  ],
                ),
                SizedBox(height: K.s3),
                KwMiniTracker(done: 4),
                SizedBox(height: K.s3),
                Text('نوصلها الجمعة 6–8 م', style: KT.strong),
                SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(child: Text('7 قطع · 8,500 د.ع نقداً', style: KT.cap)),
                    KwIcon('chevron-left', size: 14, color: K.inkSubtle),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: K.s3),
        // Q-0136
        GestureDetector(
          onTap: widget.onOrderDetail,
          child: Container(
            padding: const EdgeInsets.all(K.s4),
            decoration: BoxDecoration(
              color: K.surface,
              borderRadius: BorderRadius.circular(K.rMd),
              border: Border.all(color: K.hairline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    Ltr('Q-0136', style: TextStyle(fontFamily: 'Tajarib', fontSize: 16, fontWeight: FontWeight.w700)),
                    SizedBox(width: K.s2),
                    KwBadge('قيد التجهيز', tone: KwBadgeTone.neutral),
                  ],
                ),
                const SizedBox(height: K.s3),
                const KwMiniTracker(done: 3),
                const SizedBox(height: K.s3),
                Container(
                  padding: const EdgeInsets.all(K.s3),
                  decoration: BoxDecoration(
                    color: K.tintGrey,
                    borderRadius: BorderRadius.circular(K.rSm),
                  ),
                  child: const Row(
                    children: [
                      KwIcon('clock', size: 16, color: K.ink),
                      SizedBox(width: K.s2),
                      Expanded(
                        child: Text(
                          'تأخّر طلبك — الموعد الجديد الأحد 6–8 م. لا تحتاج فعل شيء.',
                          style: TextStyle(
                            fontFamily: 'Tajarib',
                            fontSize: 13,
                            height: 20 / 13,
                            color: K.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: K.s2),
                const Row(
                  children: [
                    Expanded(child: Text('4 قطع · قاطات', style: KT.cap)),
                    KwIcon('chevron-left', size: 14, color: K.inkSubtle),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _scheduled(BuildContext context) {
    return KwState(
      icon: 'clock',
      title: 'اجعلها كل أسبوع',
      body: 'نأتيك بنفس اليوم والوقت كل أسبوع. تقدر تتخطّى أي أسبوع.',
      cta: 'اطلب وكرّر كل أسبوع',
      onCta: widget.onOrder,
    );
  }

  Widget _past(BuildContext context) {
    final groups = <String, List<_PastOrderItem>>{
      'أكتوبر 2026': [
        const _PastOrderItem('Q-0142', 'تم التسليم', 'السبت 10 أكتوبر · 13 قطعة · كوي', '15,000 د.ع', false),
        const _PastOrderItem('Q-0131', 'تم التسليم', 'الخميس 1 أكتوبر · 10 قطع · كوي', '10,000 د.ع', false),
      ],
      'سبتمبر 2026': [
        const _PastOrderItem('Q-0124', 'أُلغي', 'ألغيته قبل خروج المندوب · بلا رسوم', '—', true),
        const _PastOrderItem('Q-0117', 'تم التسليم', 'الخميس 24 سبتمبر · 8 قطع · غسيل وكوي', '9,500 د.ع', false),
      ],
    };

    return ListView(
      padding: const EdgeInsets.fromLTRB(K.s6, K.s3, K.s6, K.s8),
      children: [
        for (final entry in groups.entries) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: K.s2),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(entry.key, style: KT.cap),
            ),
          ),
          for (final o in entry.value)
            Container(
              margin: const EdgeInsets.only(bottom: K.s3),
              padding: const EdgeInsets.all(K.s4),
              decoration: BoxDecoration(
                color: K.surface,
                borderRadius: BorderRadius.circular(K.rMd),
                border: Border.all(color: K.hairline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(o.price, style: const TextStyle(fontFamily: 'Tajarib', fontSize: 16, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      KwBadge(o.status, tone: o.isCanceled ? KwBadgeTone.neutral : KwBadgeTone.mint),
                      const SizedBox(width: K.s2),
                      Ltr(o.code, style: const TextStyle(fontFamily: 'Tajarib', fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: K.s1),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(o.desc, style: KT.cap),
                  ),
                  const SizedBox(height: K.s3),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: KwButton(
                      'أعد الطلب',
                      variant: KwBtnVariant.secondary,
                      md: true,
                      block: false,
                      onPressed: widget.onOrder,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

class _PastOrderItem {
  const _PastOrderItem(this.code, this.status, this.desc, this.price, this.isCanceled);
  final String code;
  final String status;
  final String desc;
  final String price;
  final bool isCanceled;
}

class _UnderlineTabs extends StatelessWidget {
  const _UnderlineTabs({
    required this.index,
    required this.labels,
    required this.onTap,
  });

  final int index;
  final List<String> labels;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: i == index ? K.brand : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontFamily: 'Tajarib',
                      fontSize: 16,
                      height: 24 / 16,
                      fontWeight: i == index ? FontWeight.w800 : FontWeight.w500,
                      color: i == index ? K.brandText : K.inkMuted,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Pill tab strip — `.kw-tabs` / `.kw-tab`.
class KwTabs extends StatelessWidget {
  const KwTabs({
    super.key,
    required this.index,
    required this.labels,
    required this.onTap,
  });

  final int index;
  final List<String> labels;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Semantics(
              selected: i == index,
              button: true,
              child: GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: K.s2),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: i == index ? K.tintGreen : Colors.transparent,
                      borderRadius: K.rPill,
                      border: Border.all(color: i == index ? K.action : K.hairline),
                    ),
                    child: Text(
                      labels[i],
                      style: TextStyle(
                        fontFamily: 'Tajarib',
                        fontSize: 15,
                        height: 24 / 15,
                        fontWeight: FontWeight.w700,
                        color: i == index ? K.brandText : K.inkMuted,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// C3 · حسابي.
class AccountScreen extends StatelessWidget {
  const AccountScreen({
    super.key,
    required this.onHome,
    required this.onOrders,
    required this.onLogin,
    required this.onNotifications,
  });

  final VoidCallback onHome;
  final VoidCallback onOrders;
  final VoidCallback onLogin;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return KwScreen(
      child: Column(
        children: [
          const KwTopBar(title: 'حسابي', showBack: false),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(K.s6, K.s4, K.s6, K.s8),
              children: [
                if (app.registered)
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundColor: K.tintGreen,
                        child: Text('ح',
                            style: TextStyle(
                                fontFamily: 'Tajarib',
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: K.brandText)),
                      ),
                      const SizedBox(width: K.s3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(app.firstName, style: KT.t2),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(app.phone, style: KT.cap),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else ...[
                  const Text('سجّل برقم هاتفك لتحفظ عناوينك وطلباتك.', style: KT.p),
                  const SizedBox(height: K.s4),
                  KwButton('سجّل الدخول', md: true, onPressed: onLogin),
                  const SizedBox(height: K.s5),
                ],
                const SizedBox(height: K.s5),
                const Text('الإعدادات', style: KT.t3),
                const SizedBox(height: K.s2),
                const KwRow(
                  leading: KwLead('profile', size: 44),
                  title: 'الاسم ورقم الهاتف',
                  chevron: true,
                ),
                const KwRow(
                  leading: KwLead('pin', size: 44),
                  title: 'العناوين وتعليمات الباب',
                  description: 'البيت (الافتراضي)، العمل',
                  chevron: true,
                ),
                const KwRow(
                  leading: KwLead('shield', size: 44),
                  title: 'الخصوصية والتغليف',
                  description: 'كيس معتم بلا شعار',
                  chevron: true,
                ),
                KwRow(
                  leading: const KwLead('bell', size: 44),
                  title: 'الإشعارات والحساب',
                  description: 'واتساب · إشعارات التطبيق',
                  chevron: true,
                  onTap: onNotifications,
                ),
                const SizedBox(height: K.s5),
                const Text('المساعدة والسياسات', style: KT.t3),
                const SizedBox(height: K.s2),
                const KwRow(
                  leading: KwLead('help', size: 44),
                  title: 'المساعدة',
                  description: 'واتساب، اتصال، الأسئلة الشائعة',
                  chevron: true,
                ),
                const KwRow(
                  leading: KwLead('shield', size: 44),
                  title: 'الضمان والسياسات',
                  description: 'ضمان كويلي، الإلغاء، القطع غير المقبولة، الصور',
                  chevron: true,
                ),
                const SizedBox(height: K.s5),
                const Text('فهرس الشاشات والتصاميم', style: KT.t3),
                const SizedBox(height: K.s2),
                KwRow(
                  leading: const KwLead('sparkle', size: 44, color: K.brand),
                  title: 'فهرس كل الشاشات (39 شاشة ومودال)',
                  description: 'استعراض واختبار كافة شاشات وتدفقات التطبيق بنقرة واحدة',
                  chevron: true,
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const ScreenCatalogSheet(),
                    );
                  },
                ),
                const SizedBox(height: K.s5),
                KwRow(
                  leading: const KwLead('logout', size: 44, color: K.danger),
                  title: 'تسجيل الخروج',
                  onTap: () {
                    app.registered = false;
                    app.touch();
                  },
                ),
                const SizedBox(height: K.s4),
                const Center(child: Text('الإصدار 1.0.0', style: KT.cap)),
              ],
            ),
          ),
          KwTabBar(
            index: 2,
            onTap: (i) => [onHome, onOrders][i == 0 ? 0 : 1](),
          ),
        ],
      ),
    );
  }
}

/// C3.6 · الإشعارات والحساب.
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool askDelete = false;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    Widget toggleRow(String title, String desc, bool value, ValueChanged<bool> onChanged) =>
        Padding(
          padding: const EdgeInsets.symmetric(vertical: K.s3),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: KT.strong),
                    if (desc.isNotEmpty) Text(desc, style: KT.cap),
                  ],
                ),
              ),
              KwToggle(value: value, label: title, onChanged: onChanged),
            ],
          ),
        );

    return KwScreen(
      child: Column(
        children: [
          KwTopBar(title: 'الإشعارات والحساب', onBack: () => Navigator.of(context).maybePop()),
          KwBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('قنوات الإشعار', style: KT.t3),
                const SizedBox(height: K.s2),
                KwCard(
                  padding: const EdgeInsets.symmetric(horizontal: K.s4, vertical: K.s2),
                  child: Column(
                    children: [
                      toggleRow('واتساب', '', app.pushWa,
                          (v) => app.pushWa = v),
                      toggleRow('إشعارات التطبيق', '', app.pushApp, (v) => app.pushApp = v),
                    ],
                  ),
                ),
                const SizedBox(height: K.s5),
                const Text('أنواع الإشعار', style: KT.t3),
                const SizedBox(height: K.s2),
                KwCard(
                  padding: const EdgeInsets.symmetric(horizontal: K.s4, vertical: K.s2),
                  child: Column(
                    children: [
                      toggleRow('«يحتاج ردّك»', 'لا يمكن إيقافه — طلبك ينتظر قرارك.', true, (_) {}),
                      toggleRow('مراحل الطلب', 'من التأكيد حتى التسليم', app.pushStages,
                          (v) => app.pushStages = v),
                      toggleRow('تذكير الموعد الثابت', 'قبل يوم من الاستلام', app.pushWeekly,
                          (v) => app.pushWeekly = v),
                      toggleRow('العروض', '', app.pushOffers, (v) => app.pushOffers = v),
                    ],
                  ),
                ),
                const SizedBox(height: K.s5),
                const Text('الحساب', style: KT.t3),
                const SizedBox(height: K.s2),
                const KwRow(
                  leading: KwLead('logout', size: 44),
                  title: 'تسجيل الخروج',
                  chevron: true,
                ),
                KwRow(
                  leading: const KwLead('trash', size: 44, color: K.danger),
                  title: 'حذف الحساب',
                  chevron: true,
                  onTap: () => setState(() => askDelete = true),
                ),
                if (askDelete) ...[
                  const SizedBox(height: K.s3),
                  const KwBanner(
                    icon: 'info',
                    tone: KwBannerTone.alert,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'حذف حسابك؟',
                          style: TextStyle(
                              fontFamily: 'Tajarib',
                              fontSize: 15,
                              height: 24 / 15,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'تُحذف عناوينك وسجل طلباتك ولا يمكن استرجاعها.',
                          style: KT.cap,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'لا يمكن الحذف مع طلب جارٍ. لديك طلب Q-0142.',
                          style: TextStyle(
                            fontFamily: 'Tajarib',
                            fontSize: 13,
                            height: 20 / 13,
                            fontWeight: FontWeight.w500,
                            color: K.danger,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: K.s3),
                  Row(
                    children: [
                      Expanded(
                        child: KwButton('تراجع', variant: KwBtnVariant.ghost, md: true,
                            onPressed: () => setState(() => askDelete = false)),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: KwButton('احذف حسابي', variant: KwBtnVariant.danger, md: true,
                            onPressed: null),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// N01–N15 · الإشعارات ورسائل واتساب.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key, required this.onOpen});

  final void Function(String id) onOpen;

  static final groups = <(String, List<(String, String, String, bool)>)>[
    ('قبل الاستلام', [
      ('N01', 'طلبك Q-0142 مؤكد. الاستلام الخميس 6–8 مساءً.', 'تفاصيل الطلب', false),
      ('N02', 'سيأتيك علي من كويلي.', 'تفاصيل الطلب · من سيأتي', false),
      ('N03', 'علي في الطريق إليك، يصل خلال 15 دقيقة.', 'تفاصيل الطلب', false),
      ('N04', 'عدّنا 12 قطعة. أكّد أو صحّح.', 'تأكيد العدد', true),
      ('N05', 'استلمنا 12 قطعة. هذا سجلها.', 'سجل التسليم', false),
      ('N14', 'غداً موعدك الثابت 6–8 مساءً. تريد التخطّي؟', 'موعدي الثابت', false),
    ]),
    ('أثناء التجهيز', [
      ('N06', 'وجدنا قطعة إضافية بـ 2,000 د.ع. توافق؟', 'الموافقة على تغيير السعر', true),
      ('N07', 'نتابع أمراً في طلبك: قميص يحتاج كوياً ثانياً. نعيد كيّه بلا مقابل. لا تحتاج فعل شيء.',
          'تفاصيل الطلب', false),
      ('N08', 'تأخّر طلبك. الموعد الجديد الأحد 6–8 مساءً.', 'تفاصيل الطلب', false),
      ('N09', 'ملابسك جاهزة. نوصلها السبت 6–8 مساءً.', 'تفاصيل الطلب', false),
    ]),
    ('التسليم والدفع', [
      ('N10', 'في الطريق إليك. المبلغ 15,000 د.ع نقداً.', 'تفاصيل الطلب', false),
      ('N11', 'تم التسليم. كيف كانت الخدمة؟', 'التقييم', false),
      ('N12', 'لم نجدك في الموعد. اختر موعداً جديداً.', 'اختيار موعد تسليم جديد', true),
    ]),
    ('البلاغات والإلغاء', [
      ('N13', 'راجعنا بلاغك. هذا القرار والدليل.', 'متابعة البلاغ', false),
      ('N15', 'أُلغي طلبك Q-0124. ألغيته قبل خروج المندوب.', 'تفاصيل الطلب', false),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return KwScreen(
      child: Column(
        children: [
          KwTopBar(title: 'الإشعارات', onBack: () => Navigator.of(context).maybePop()),
          KwBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'تصل على واتساب وكإشعار من التطبيق. كل رسالة تفتح الشاشة التي تقول أين طلبك وما الخطوة التالية.',
                  style: KT.cap,
                ),
                for (final g in groups) ...[
                  const SizedBox(height: K.s4),
                  KwGroupLabel(g.$1),
                  const SizedBox(height: K.s2),
                  for (final n in g.$2)
                    KwCard(
                      padding: const EdgeInsets.all(K.s4),
                      gap: K.s2,
                      margin: const EdgeInsets.only(bottom: K.s2),
                      onTap: () => onOpen(n.$1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Ltr(n.$1, style: KT.cap),
                              const Spacer(),
                              if (n.$4)
                                const KwBadge('يحتاج ردّك', tone: KwBadgeTone.danger),
                            ],
                          ),
                          Text(n.$2, style: KT.p),
                          Text('يفتح: ${n.$3}', style: KT.cap),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// C2.3 · مشكلة في الطلب.
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key, required this.onSent});

  final VoidCallback onSent;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final note = TextEditingController(
    text: 'في الدشداشة لمعة على الياقة لم تكن موجودة.',
  );
  String type = 'damaged';
  final Set<String> items = {'dish'};
  final List<String> photos = [];

  static const types = [
    ('quality', 'جودة الكوي'),
    ('missing', 'قطعة ناقصة'),
    ('damaged', 'قطعة تالفة'),
    ('notmine', 'قطعة ليست لي'),
    ('late', 'تأخير'),
    ('other', 'غير ذلك'),
  ];

  static const itemList = [
    ('shirt', 'قميص'),
    ('pants', 'بنطرون'),
    ('dish', 'دشداشة'),
    ('abaya', 'عباءة'),
  ];

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  bool get needPhoto => type == 'damaged' || type == 'quality';

  @override
  Widget build(BuildContext context) {
    return KwScreen(
      child: Column(
        children: [
          KwTopBar(
            title: 'مشكلة في الطلب · Q-0142',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          KwBody(
            gap: K.s4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'أخبرنا ونحن نتابع مع المندوب والمحل. لا تحتاج التواصل مع أحد غيرنا.',
                  style: KT.p,
                ),
                const SizedBox(height: K.s2),
                const Text('نوع المشكلة', style: KT.t3),
                Wrap(
                  spacing: K.s2,
                  runSpacing: K.s2,
                  children: [
                    for (final t in types)
                      KwChip(t.$2, small: true, selected: type == t.$1, onTap: () {
                        setState(() => type = t.$1);
                      }),
                  ],
                ),
                const Text('القطعة المعنية', style: KT.t3),
                Wrap(
                  spacing: K.s2,
                  runSpacing: K.s2,
                  children: [
                    for (final i in itemList)
                      KwChip(i.$2, selected: items.contains(i.$1), onTap: () {
                        setState(() => items.contains(i.$1)
                            ? items.remove(i.$1)
                            : items.add(i.$1));
                      }),
                  ],
                ),
                Text(
                  needPhoto ? 'صور (مطلوبة، حتى 3)' : 'صور (اختيارية، حتى 3)',
                  style: KT.t3,
                ),
                Wrap(
                  spacing: K.s2,
                  runSpacing: K.s2,
                  children: [
                    for (final _ in photos) ...[
                      SizedBox(
                        width: 72,
                        child: Stack(
                          children: [
                            const KwPhoto(icon: 'camera'),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: GestureDetector(
                                onTap: () => setState(() => photos.remove(photos.last)),
                                child: const Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Icon(Icons.close, size: 16, color: K.danger),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (photos.length < 3)
                      GestureDetector(
                        onTap: () => setState(() => photos.add('صورة ${photos.length + 1}')),
                        child: const SizedBox(width: 72, child: KwPhoto(icon: 'camera')),
                      ),
                  ],
                ),
                KwField(label: 'ملاحظة', controller: note, maxLines: 3),
              ],
            ),
          ),
          KwFooter(
            children: [
              KwButton('أرسل البلاغ', onPressed: widget.onSent),
            ],
          ),
        ],
      ),
    );
  }
}

/// C2.3b · متابعة البلاغ.
class ReportStatusScreen extends StatelessWidget {
  const ReportStatusScreen({super.key, this.decided = false});

  final bool decided;

  @override
  Widget build(BuildContext context) {
    return KwScreen(
      child: Column(
        children: [
          KwTopBar(title: 'بلاغ · Q-0142', onBack: () => Navigator.of(context).maybePop()),
          KwBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KwTracker(
                  stages: const ['استلمنا', 'نراجع', 'القرار'],
                  strongNow: decided ? 2 : 1,
                ),
                const SizedBox(height: K.s2),
                const Text('آخر تحديث · اليوم 10:15 ص', style: KT.cap),
                const SizedBox(height: K.s4),
                const KwCard(
                  gap: K.s2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('ماذا حدث:', style: KT.strong),
                      Text('وصلنا بلاغك عن دشداشة تالفة.', style: KT.p),
                      SizedBox(height: K.s2),
                      Text('ماذا نفعل:', style: KT.strong),
                      Text('نراجع صور الاستلام وملاحظات المحل.', style: KT.p),
                      SizedBox(height: K.s2),
                      Text('هل عليك شيء:', style: KT.strong),
                      Text('لا. نبلغك بالقرار هنا وعلى واتساب.', style: KT.p),
                    ],
                  ),
                ),
                const SizedBox(height: K.s5),
                if (decided) ...[
                  const Text('القرار', style: KT.t3),
                  const SizedBox(height: K.s2),
                  KwCard(
                    gap: K.s2,
                    outlined: true,
                    outlinedColor: K.brand,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('تعويض', style: KT.strong),
                            Text('${fmtK(2000)} د.ع',
                                style: KT.t2.copyWith(color: K.brandText)),
                          ],
                        ),
                        const Text(
                          'صور الاستلام تُظهر الياقة سليمة، فالتلف حدث أثناء المعالجة ويشمله ضمان كويلي.',
                          style: KT.p,
                        ),
                        const Text(
                          'تستلم المبلغ نقداً مع المندوب في طلبك القادم.',
                          style: KT.cap,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: K.s5),
                  const Text('الدليل المستخدم', style: KT.t3),
                  const KwRow(
                    leading: KwLead('image', size: 44),
                    title: 'صورة دشداشة 1 · عند الاستلام',
                    chevron: true,
                  ),
                  const KwRow(
                    leading: KwLead('receipt', size: 44),
                    title: 'ملاحظات المحل · لا ملاحظات على الدشداشة',
                  ),
                ] else ...[
                  const Text('ما أرسلته', style: KT.t3),
                  const SizedBox(height: K.s2),
                  const KwCard(
                    gap: K.s2,
                    padding: EdgeInsets.all(K.s4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        KwAmount('النوع', 'قطعة تالفة'),
                        KwAmount('القطعة', 'دشداشة'),
                        SizedBox(height: K.s1),
                        Text('صورتك', style: KT.strong),
                        Text('«في الدشداشة لمعة على الياقة لم تكن موجودة.»', style: KT.cap),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: K.s5),
                const Text('غير راضٍ؟', style: KT.t3),
                const SizedBox(height: K.s2),
                const KwRow(
                  leading: KwLead('whatsapp', size: 44),
                  title: 'تواصل معنا',
                  description: 'على واتساب برسالة فيها رمز البلاغ.',
                  chevron: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// C2.4 · موعدي الثابت.
class RecurringScreen extends StatelessWidget {
  const RecurringScreen({super.key});

  static const weeks = [
    'الخميس 15 أكتوبر',
    'الخميس 22 أكتوبر',
    'الخميس 29 أكتوبر',
    'الخميس 5 نوفمبر',
  ];

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final paused = app.recurringPaused;

    void skip(int i, BuildContext ctx) {
      app.skippedWeeks.contains(i)
          ? app.skippedWeeks.remove(i)
          : app.skippedWeeks.add(i);
      app.touch();
      showKwToast(
        ctx,
        app.skippedWeeks.contains(i) ? 'تم تخطّي هذا الأسبوع' : 'أعدنا استلام هذا الأسبوع',
      );
    }

    return KwScreen(
      child: Column(
        children: [
          KwTopBar(title: 'موعدي الثابت', onBack: () => Navigator.of(context).maybePop()),
          KwBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Expanded(child: Text('كل خميس · 6–8 مساءً', style: KT.t2)),
                    KwBadge(paused ? 'موقوف حتى 5 نوفمبر' : 'نشط',
                        tone: paused ? KwBadgeTone.neutral : KwBadgeTone.green),
                  ],
                ),
                const SizedBox(height: K.s2),
                Text(
                  paused
                      ? 'لن نأتيك حتى 5 نوفمبر. تقدر تستأنف في أي وقت.'
                      : 'الاستلام القادم الخميس 15 أكتوبر.',
                  style: KT.cap,
                ),
                const SizedBox(height: K.s5),
                const Text('التفاصيل', style: KT.t3),
                const SizedBox(height: K.s2),
                KwCard(
                  gap: K.s2,
                  padding: const EdgeInsets.all(K.s4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const KwRow(title: 'العنوان', description: 'البيت · المنصور'),
                      const KwRow(title: 'تعليمات الباب', description: 'أنا · اتصل قبل الوصول'),
                      const KwRow(title: 'القطع المعتادة', description: '6 قمصان، 4 بناطير'),
                      KwAmount('المبلغ المتوقّع للأسبوع', fmtK(10000), strong: true),
                    ],
                  ),
                ),
                const SizedBox(height: K.s5),
                const Text('الأسابيع القادمة', style: KT.t3),
                const SizedBox(height: K.s2),
                for (var i = 0; i < weeks.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: K.s2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: K.s4, vertical: K.s2),
                      decoration: BoxDecoration(
                        color: K.surface,
                        borderRadius: BorderRadius.circular(K.rMd),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  weeks[i],
                                  style: KT.strong.copyWith(
                                    decoration: (paused || app.skippedWeeks.contains(i))
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: (paused || app.skippedWeeks.contains(i))
                                        ? K.inkMuted
                                        : K.ink,
                                  ),
                                ),
                                Text(
                                  paused
                                      ? 'موقوف'
                                      : app.skippedWeeks.contains(i)
                                          ? 'تم التخطّي'
                                          : '6–8 م',
                                  style: KT.cap,
                                ),
                              ],
                            ),
                          ),
                          KwToggle(
                            value: app.skippedWeeks.contains(i),
                            label: weeks[i],
                            onChanged: (_) => skip(i, context),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: K.s3),
                const Text(
                  'التخطّي ممكن حتى 12 ساعة قبل الموعد؛ بعدها تواصل معنا.',
                  style: KT.cap,
                ),
                const SizedBox(height: K.s4),
                KwButton(
                  paused ? 'استئناف' : 'إيقاف مؤقت',
                  variant: KwBtnVariant.ghost,
                  md: true,
                  onPressed: () {
                    app.recurringPaused = !paused;
                    app.touch();
                    showKwToast(
                      context,
                      paused ? 'استأنفنا موعدك الثابت' : 'أوقفنا موعدك حتى 5 نوفمبر',
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// M04 · تعذّر التسليم / تغيير الموعد.
class RescheduleScreen extends StatefulWidget {
  const RescheduleScreen({super.key, this.change = false});

  final bool change;

  @override
  State<RescheduleScreen> createState() => _RescheduleScreenState();
}

class _RescheduleScreenState extends State<RescheduleScreen> {
  int slot = 0;

  static const slots = [
    ('الأحد 11 أكتوبر · 6–8 م', ''),
    ('الأحد 11 أكتوبر · 8–10 ص', 'ممتلئة'),
    ('الاثنين 12 أكتوبر · 4–6 م', ''),
    ('الاثنين 12 أكتوبر · 6–8 م', ''),
  ];

  @override
  Widget build(BuildContext context) {
    return KwScreen(
      child: Column(
        children: [
          KwTopBar(title: 'Q-0142', onBack: () => Navigator.of(context).maybePop()),
          KwBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.change
                      ? 'تغيير موعد التسليم'
                      : 'لم نجدك في الموعد — اختر موعداً جديداً',
                  style: KT.t2,
                ),
                const SizedBox(height: K.s2),
                const Text(
                  'ملابسك محفوظة لدينا. اختر الوقت المناسب ونوصلها إليك.',
                  style: KT.p,
                ),
                const SizedBox(height: K.s5),
                for (var i = 0; i < slots.length; i++) ...[
                  KwSelect(
                    enabled: slots[i].$2.isEmpty,
                    selected: slot == i,
                    radio: false,
                    padding: const EdgeInsets.all(K.s4),
                    onTap: () => setState(() => slot = i),
                    child: Row(
                      children: [
                        Expanded(child: Text(slots[i].$1, style: KT.strong)),
                        if (slots[i].$2.isNotEmpty)
                          Text(slots[i].$2, style: KT.cap),
                      ],
                    ),
                  ),
                  const SizedBox(height: K.s2),
                ],
                const SizedBox(height: K.s3),
                const Text('متاح مرة واحدة لهذا الطلب.', style: KT.cap),
              ],
            ),
          ),
          KwFooter(
            children: [
              KwButton('تأكيد الموعد', onPressed: () {
                showKwToast(context, 'سنوصّلها ${slots[slot].$1}');
                Navigator.of(context).pop();
              }),
            ],
          ),
        ],
      ),
    );
  }
}
