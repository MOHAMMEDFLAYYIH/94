import 'package:flutter/material.dart';

import '../theme/icons.dart';
import '../theme/tokens.dart';
import '../widgets/chrome.dart';
import '../widgets/controls.dart';
import '../widgets/layout.dart';
import 'account.dart';
import 'home.dart';
import 'info.dart';
import 'onboarding.dart';
import 'order_flow.dart';
import 'order_track.dart';

/// Item description for the 39 PNG design catalog.
class CatalogScreenItem {
  const CatalogScreenItem({
    required this.code,
    required this.title,
    required this.category,
    required this.pngName,
    required this.isModal,
    required this.builder,
  });

  final String code;
  final String title;
  final String category;
  final String pngName;
  final bool isModal;
  final Widget Function(BuildContext context) builder;
}

/// فهرس كل الشاشات الـ 39 المستخرجة من التصميم (Figma/PNG)
class ScreenCatalogSheet extends StatefulWidget {
  const ScreenCatalogSheet({super.key});

  @override
  State<ScreenCatalogSheet> createState() => _ScreenCatalogSheetState();
}

class _ScreenCatalogSheetState extends State<ScreenCatalogSheet> {
  String _selectedCategory = 'الكل';
  String _query = '';

  static const categories = [
    'الكل',
    'البداية (S)',
    'الرئيسية (C1)',
    'الطلب (F1)',
    'النوافذ (M)',
    'التتبّع (C2)',
    'الحساب (C3)',
    'الإشعارات (N)',
    'النظام (X)',
  ];

  List<CatalogScreenItem> _getItems(BuildContext context) {
    void pop() => Navigator.of(context).maybePop();

    return [
      // ─── S: Onboarding & Auth ───
      CatalogScreenItem(
        code: 'S00',
        title: 'شاشة البداية (Splash)',
        category: 'البداية (S)',
        pngName: 'S00 · شاشة البداية.png',
        isModal: false,
        builder: (_) => SplashScreen(onDone: pop),
      ),
      CatalogScreenItem(
        code: 'S01',
        title: 'هل نخدم حيّك؟ (اختيار المنطقة)',
        category: 'البداية (S)',
        pngName: 'S01 · هل نخدم حيّك؟.png',
        isModal: false,
        builder: (_) => AreaScreen(
          onNext: pop,
          onWaitlist: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => WaitlistScreen(onPrices: pop, onRegistered: pop),
              ),
            );
          },
        ),
      ),
      CatalogScreenItem(
        code: 'S01b',
        title: 'لم نصل حيّك بعد (قائمة الانتظار)',
        category: 'البداية (S)',
        pngName: 'S01b · لم نصل حيّك بعد.png',
        isModal: false,
        builder: (_) => WaitlistScreen(onPrices: pop, onRegistered: pop),
      ),
      CatalogScreenItem(
        code: 'S02',
        title: 'رقم الهاتف (تسجيل الدخول)',
        category: 'البداية (S)',
        pngName: 'S02 · رقم الهاتف.png',
        isModal: false,
        builder: (_) => PhoneScreen(
          onNext: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => OtpScreen(onNext: pop),
              ),
            );
          },
        ),
      ),
      CatalogScreenItem(
        code: 'S03',
        title: 'رمز التحقق (OTP) والاسم',
        category: 'البداية (S)',
        pngName: 'S03 · رمز التحقق.png',
        isModal: false,
        builder: (_) => OtpScreen(onNext: pop),
      ),

      // ─── C1: Home & Services ───
      CatalogScreenItem(
        code: 'C1',
        title: 'الرئيسية (وضع الزائر)',
        category: 'الرئيسية (C1)',
        pngName: 'C1 · الرئيسية (زائر).png',
        isModal: false,
        builder: (_) {
          return Builder(
            builder: (ctx) {
              return HomeScreen(
                onOrder: () => _openOrderFlow(ctx),
                onPrices: () => Navigator.of(ctx).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PricesScreen(onOrder: () => _openOrderFlow(ctx)),
                  ),
                ),
                onProtect: () => Navigator.of(ctx).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ProtectScreen(onOrder: () => _openOrderFlow(ctx)),
                  ),
                ),
                onOrders: pop,
                onAccount: pop,
                onRecurring: () => Navigator.of(ctx).push(
                  MaterialPageRoute<void>(builder: (_) => const RecurringScreen()),
                ),
                onConfirmCount: () => _openCountConfirm(ctx),
                onOrderDetail: () => _openOrderDetail(ctx),
              );
            },
          );
        },
      ),
      CatalogScreenItem(
        code: 'C1 (جارٍ)',
        title: 'الرئيسية (طلب جارٍ + يحتاج ردّك)',
        category: 'الرئيسية (C1)',
        pngName: 'C1 · الرئيسية (طلب جارٍ + يحتاج ردّك).png',
        isModal: false,
        builder: (_) => _HomeActiveOrderPreview(onClose: pop),
      ),
      CatalogScreenItem(
        code: 'C1.1',
        title: 'الأسعار والخدمات',
        category: 'الرئيسية (C1)',
        pngName: 'C1.1 · الأسعار.png',
        isModal: false,
        builder: (_) => PricesScreen(onOrder: () => _openOrderFlow(context)),
      ),
      CatalogScreenItem(
        code: 'C1.1 (بحث)',
        title: 'الأسعار — بحث بلا نتائج',
        category: 'الرئيسية (C1)',
        pngName: 'C1.1 · بحث بلا نتائج.png',
        isModal: false,
        builder: (_) => NoResultsScreen(
          onAdd: () {
            pop();
            _openAddItem(context);
          },
          onOrder: () {
            pop();
            _openOrderFlow(context);
          },
        ),
      ),
      CatalogScreenItem(
        code: 'C1.2',
        title: 'كيف نحمي ملابسك (الضمان والخطوات)',
        category: 'الرئيسية (C1)',
        pngName: 'C1.2 · كيف نحمي ملابسك.png',
        isModal: false,
        builder: (_) => ProtectScreen(onOrder: () => _openOrderFlow(context)),
      ),

      // ─── F1: Order Flow ───
      CatalogScreenItem(
        code: 'F1.1',
        title: 'الخطوة 1: القطع والخدمات',
        category: 'الطلب (F1)',
        pngName: 'F1.1 · القطع والخدمات.png',
        isModal: false,
        builder: (_) => ItemsScreen(
          onClose: pop,
          onAddOther: () => _openAddItem(context),
          onNext: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => AddressScreen(
                  onBack: pop,
                  onClose: pop,
                  onNext: pop,
                ),
              ),
            );
          },
        ),
      ),
      CatalogScreenItem(
        code: 'F1.2',
        title: 'الخطوة 2: العنوان والباب',
        category: 'الطلب (F1)',
        pngName: 'F1.2 · العنوان.png',
        isModal: false,
        builder: (_) => AddressScreen(
          onBack: pop,
          onClose: pop,
          onNext: pop,
        ),
      ),
      CatalogScreenItem(
        code: 'F1.3',
        title: 'الخطوة 3: الموعد والاستلام',
        category: 'الطلب (F1)',
        pngName: 'F1.3 · الموعد.png',
        isModal: false,
        builder: (_) => ScheduleScreen(
          onBack: pop,
          onClose: pop,
          onNext: pop,
        ),
      ),
      CatalogScreenItem(
        code: 'F1.4',
        title: 'الخطوة 4: المراجعة والتأكيد',
        category: 'الطلب (F1)',
        pngName: 'F1.4 · المراجعة والتأكيد.png',
        isModal: false,
        builder: (_) => ReviewScreen(
          onEditItems: pop,
          onEditAddress: pop,
          onEditSchedule: pop,
          onConfirm: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => OrderConfirmedScreen(onHome: pop),
              ),
            );
          },
        ),
      ),
      CatalogScreenItem(
        code: 'F1.4 (فشل)',
        title: 'فشل الإرسال — امتلأ الموعد',
        category: 'الطلب (F1)',
        pngName: 'F1.4 · فشل الإرسال امتلأ الموعد.png',
        isModal: true,
        builder: (_) => OrderFailureScreen(
          mode: 'slot',
          onRetry: pop,
          onReschedule: pop,
        ),
      ),
      CatalogScreenItem(
        code: 'F1.5',
        title: 'نؤكّد طلبك (نجاح إرسال الطلب)',
        category: 'الطلب (F1)',
        pngName: 'F1.5 · نؤكّد طلبك.png',
        isModal: false,
        builder: (_) => OrderConfirmedScreen(onHome: pop),
      ),

      // ─── M: Modals ───
      CatalogScreenItem(
        code: 'M01/M02',
        title: 'تأكيد العدد (عدّ المندوب عند الباب)',
        category: 'النوافذ (M)',
        pngName: 'M01 M02 · تأكيد العدد.png',
        isModal: true,
        builder: (_) => CountConfirmScreen(onDone: pop),
      ),
      CatalogScreenItem(
        code: 'M03',
        title: 'الموافقة على تغيير السعر (قطعة إضافية)',
        category: 'النوافذ (M)',
        pngName: 'M03 · الموافقة على تغيير السعر.png',
        isModal: true,
        builder: (_) => PriceChangeScreen(onDone: pop),
      ),
      CatalogScreenItem(
        code: 'M04',
        title: 'تعذّر التسليم — تغيير الموعد',
        category: 'النوافذ (M)',
        pngName: 'M04 · تعذّر التسليم تغيير الموعد.png',
        isModal: true,
        builder: (_) => const RescheduleScreen(),
      ),
      CatalogScreenItem(
        code: 'M06',
        title: 'التقييم (كيف كانت الخدمة؟)',
        category: 'النوافذ (M)',
        pngName: 'M06 · التقييم.png',
        isModal: true,
        builder: (_) => const RatingScreen(),
      ),
      CatalogScreenItem(
        code: 'M09',
        title: 'إغلاق تدفق الطلب (حفظ كمسودة؟)',
        category: 'النوافذ (M)',
        pngName: 'M09 · إغلاق تدفق الطلب.png',
        isModal: true,
        builder: (_) => _ExitFlowSheetPreview(onDone: pop),
      ),
      CatalogScreenItem(
        code: 'M10',
        title: 'إضافة قطعة أخرى (اسم وخدمة وعدة)',
        category: 'النوافذ (M)',
        pngName: 'M10 · إضافة قطعة أخرى.png',
        isModal: true,
        builder: (_) => AddItemScreen(
          onAdd: (name, svc, qty) {
            pop();
            showKwToast(context, 'أضفنا $name');
          },
          onClose: pop,
        ),
      ),

      // ─── C2: Orders & Tracking ───
      CatalogScreenItem(
        code: 'C2 (الحالية)',
        title: 'طلباتي — الطلبات الحالية',
        category: 'التتبّع (C2)',
        pngName: 'C2 · طلباتي — الحالية.png',
        isModal: false,
        builder: (_) => _OrdersTabPreview(initialTab: 0, onClose: pop),
      ),
      CatalogScreenItem(
        code: 'C2 (السابقة)',
        title: 'طلباتي — السابقة (السجل والشهور)',
        category: 'التتبّع (C2)',
        pngName: 'C2 · طلباتي — السابقة (السجل).png',
        isModal: false,
        builder: (_) => _OrdersTabPreview(initialTab: 2, onClose: pop),
      ),
      CatalogScreenItem(
        code: 'C2 (فارغة)',
        title: 'طلباتي — حالات فارغة (تسجيل برقم الهاتف)',
        category: 'التتبّع (C2)',
        pngName: 'C2 · طلباتي — حالات فارغة.png',
        isModal: false,
        builder: (_) => _OrdersEmptyPreview(onClose: pop),
      ),
      CatalogScreenItem(
        code: 'C2.1 (تجهيز)',
        title: 'تفاصيل الطلب (قيد التجهيز)',
        category: 'التتبّع (C2)',
        pngName: 'C2.1 · تفاصيل الطلب (قيد التجهيز).png',
        isModal: false,
        builder: (_) => _OrderDetailPreview(onClose: pop),
      ),
      CatalogScreenItem(
        code: 'C2.1 (في الطريق)',
        title: 'في الطريق إليك (الدفع نقداً)',
        category: 'التتبّع (C2)',
        pngName: 'C2.1 · في الطريق إليك (الدفع نقداً).png',
        isModal: false,
        builder: (_) => DeliveryScreen(
          delivered: false,
          onRate: pop,
          onReport: () => _openReport(context),
          onRepeat: () => _openOrderFlow(context),
          onRecord: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const DeliveryRecordScreen()),
          ),
        ),
      ),
      CatalogScreenItem(
        code: 'C2.1 (تم التسليم)',
        title: 'تم التسليم (الدفع والتقييم والسجل)',
        category: 'التتبّع (C2)',
        pngName: 'C2.1 · تم التسليم.png',
        isModal: false,
        builder: (_) => DeliveryScreen(
          delivered: true,
          onRate: () => _openRating(context),
          onReport: () => _openReport(context),
          onRepeat: () => _openOrderFlow(context),
          onRecord: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const DeliveryRecordScreen()),
          ),
        ),
      ),
      CatalogScreenItem(
        code: 'C2.1b',
        title: 'تتبّع المندوب على الخريطة (مرحلة 2)',
        category: 'التتبّع (C2)',
        pngName: 'C2.1b · تتبّع المندوب على الخريطة (مرحلة 2).png',
        isModal: false,
        builder: (_) => const MapTrackingScreen(),
      ),
      CatalogScreenItem(
        code: 'C2.2',
        title: 'سجل التسليم والتوثيق والخط الزمني',
        category: 'التتبّع (C2)',
        pngName: 'C2.2 · سجل التسليم.png',
        isModal: false,
        builder: (_) => const DeliveryRecordScreen(),
      ),
      CatalogScreenItem(
        code: 'C2.3',
        title: 'مشكلة في الطلب (إرسال بلاغ)',
        category: 'التتبّع (C2)',
        pngName: 'C2.3 · مشكلة في الطلب.png',
        isModal: false,
        builder: (_) => ReportScreen(
          onSent: () {
            pop();
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ReportStatusScreen()),
            );
          },
        ),
      ),
      CatalogScreenItem(
        code: 'C2.3b',
        title: 'متابعة البلاغ (آخر تحديث)',
        category: 'التتبّع (C2)',
        pngName: 'C2.3b · متابعة البلاغ.png',
        isModal: false,
        builder: (_) => const ReportStatusScreen(),
      ),
      CatalogScreenItem(
        code: 'C2.4',
        title: 'موعدي الثابت (تخطي الأسابيع)',
        category: 'التتبّع (C2)',
        pngName: 'C2.4 · موعدي الثابت.png',
        isModal: false,
        builder: (_) => const RecurringScreen(),
      ),

      // ─── C3: Account ───
      CatalogScreenItem(
        code: 'C3',
        title: 'حسابي (الإعدادات والسياسات)',
        category: 'الحساب (C3)',
        pngName: 'C3 · حسابي.png',
        isModal: false,
        builder: (_) => AccountScreen(
          onHome: pop,
          onOrders: pop,
          onLogin: pop,
          onNotifications: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const NotificationSettingsScreen()),
          ),
        ),
      ),
      CatalogScreenItem(
        code: 'C3.6',
        title: 'الإشعارات والحساب (القنوات والأنواع)',
        category: 'الحساب (C3)',
        pngName: 'C3.6 · الإشعارات والحساب.png',
        isModal: false,
        builder: (_) => const NotificationSettingsScreen(),
      ),

      // ─── N: Notifications ───
      CatalogScreenItem(
        code: 'N01–N15',
        title: 'الإشعارات ورسائل واتساب (15 إشعاراً)',
        category: 'الإشعارات (N)',
        pngName: 'N01–N15 · الإشعارات ورسائل واتساب.png',
        isModal: false,
        builder: (_) => NotificationsScreen(
          onOpen: (id) => showKwToast(context, 'فتح الإشعار $id'),
        ),
      ),

      // ─── X: System / Errors ───
      CatalogScreenItem(
        code: 'X01',
        title: 'الرئيسية (تحميل هيكلي / Skeleton)',
        category: 'النظام (X)',
        pngName: 'X01 · الرئيسية (تحميل).png',
        isModal: false,
        builder: (_) => const LoadingHomeScreen(),
      ),
      CatalogScreenItem(
        code: 'X02',
        title: 'لا يوجد اتصال بالإنترنت (Offline)',
        category: 'النظام (X)',
        pngName: 'X02 · لا اتصال.png',
        isModal: false,
        builder: (_) => OfflineScreen(onRetry: pop),
      ),
      CatalogScreenItem(
        code: 'X03/X05',
        title: 'خطأ من جهتنا (Error State)',
        category: 'النظام (X)',
        pngName: 'X03 X05 · خطأ طلب غير موجود.png',
        isModal: false,
        builder: (_) => ErrorScreen(onRetry: pop, onOrders: pop),
      ),
    ];
  }

  void _openOrderFlow(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ItemsScreen(
          onClose: () => Navigator.of(context).maybePop(),
          onAddOther: () => _openAddItem(context),
          onNext: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => AddressScreen(
                  onBack: () => Navigator.of(context).maybePop(),
                  onClose: () => Navigator.of(context).maybePop(),
                  onNext: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ScheduleScreen(
                          onBack: () => Navigator.of(context).maybePop(),
                          onClose: () => Navigator.of(context).maybePop(),
                          onNext: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => ReviewScreen(
                                  onEditItems: () => Navigator.of(context).maybePop(),
                                  onEditAddress: () => Navigator.of(context).maybePop(),
                                  onEditSchedule: () => Navigator.of(context).maybePop(),
                                  onConfirm: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => OrderConfirmedScreen(
                                          onHome: () => Navigator.of(context).maybePop(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _openAddItem(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddItemScreen(
          onAdd: (name, svc, qty) {
            Navigator.of(context).maybePop();
            showKwToast(context, 'أضفنا $name');
          },
          onClose: () => Navigator.of(context).maybePop(),
        ),
      ),
    );
  }

  void _openCountConfirm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CountConfirmScreen(onDone: () => Navigator.of(context).maybePop()),
      ),
    );
  }

  void _openOrderDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OrderDetailScreen(
          onHelp: () => showKwToast(context, 'المساعدة'),
          onReport: () => _openReport(context),
          onReschedule: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const RescheduleScreen()),
          ),
          onRecord: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const DeliveryRecordScreen()),
          ),
          onPrice: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => PriceChangeScreen(onDone: () => Navigator.of(context).maybePop()),
            ),
          ),
        ),
      ),
    );
  }

  void _openReport(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReportScreen(
          onSent: () {
            Navigator.of(context).maybePop();
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ReportStatusScreen()),
            );
          },
        ),
      ),
    );
  }

  void _openRating(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const RatingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allItems = _getItems(context);
    final filtered = allItems.where((item) {
      final matchCat = _selectedCategory == 'الكل' || item.category == _selectedCategory;
      final matchQuery = _query.isEmpty ||
          item.code.toLowerCase().contains(_query.toLowerCase()) ||
          item.title.contains(_query) ||
          item.pngName.contains(_query);
      return matchCat && matchQuery;
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.88,
        decoration: const BoxDecoration(
          color: K.ground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(K.rLg)),
          boxShadow: K.shadowSheet,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            const SizedBox(height: K.s3),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: const BoxDecoration(color: K.hairline, borderRadius: K.rPill),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(K.s6, K.s4, K.s6, K.s2),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('فهرس كل الشاشات (${allItems.length} شاشة)', style: KT.t2),
                        const SizedBox(height: 2),
                        const Text(
                          'تصفّح واعرض أي صفحة من صفحات التصميم مباشرةً بنقرة واحدة.',
                          style: KT.cap,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: K.surface,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.close, size: 20, color: K.ink),
                    ),
                  ),
                ],
              ),
            ),
            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: K.s6, vertical: K.s2),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: K.surface,
                  borderRadius: BorderRadius.circular(K.rMd),
                  border: Border.all(color: K.hairline),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: K.s3),
                      child: Icon(Icons.search, size: 20, color: K.inkSubtle),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'ابحث باسم الشاشة أو رمزها (مثال: C1, F1.2, M03)...',
                          hintStyle: TextStyle(
                            fontFamily: 'Tajarib',
                            fontSize: 13,
                            color: K.inkSubtle,
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (val) => setState(() => _query = val.trim()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Category filter chips
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: K.s6),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final cat = categories[i];
                  final selected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? K.brand : K.surface,
                        borderRadius: K.rPill,
                        border: Border.all(
                          color: selected ? K.brand : K.hairline,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontFamily: 'Tajarib',
                          fontSize: 13,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected ? Colors.white : K.ink,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: K.s2),
            // List of screens
            Expanded(
              child: ListView.separated(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(K.s6, K.s2, K.s6, K.s8),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (ctx, i) {
                  final item = filtered[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).maybePop();
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: item.builder),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(K.s4),
                      decoration: BoxDecoration(
                        color: K.surface,
                        borderRadius: BorderRadius.circular(K.rMd),
                        border: Border.all(color: K.hairline),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: K.tintGreen,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.code,
                              style: const TextStyle(
                                fontFamily: 'Tajarib',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: K.brandText,
                              ),
                            ),
                          ),
                          const SizedBox(width: K.s3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontFamily: 'Tajarib',
                                    fontSize: 14,
                                    height: 22 / 14,
                                    fontWeight: FontWeight.w700,
                                    color: K.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.pngName,
                                  style: const TextStyle(
                                    fontFamily: 'Tajarib',
                                    fontSize: 11,
                                    color: K.inkSubtle,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (item.isModal)
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: K.tintGrey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'نافذة',
                                style: TextStyle(
                                  fontFamily: 'Tajarib',
                                  fontSize: 10,
                                  color: K.inkSubtle,
                                ),
                              ),
                            ),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: K.inkSubtle),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper preview for C1 active order state
class _HomeActiveOrderPreview extends StatelessWidget {
  const _HomeActiveOrderPreview({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      onOrder: () => showKwToast(context, 'فتح طلب جديد'),
      onPrices: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => PricesScreen(onOrder: () => showKwToast(context, 'طلب جديد')),
        ),
      ),
      onProtect: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ProtectScreen(onOrder: () => showKwToast(context, 'طلب جديد')),
        ),
      ),
      onOrders: onClose,
      onAccount: onClose,
      onRecurring: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const RecurringScreen()),
      ),
      onConfirmCount: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CountConfirmScreen(onDone: () => Navigator.of(context).maybePop()),
        ),
      ),
      onOrderDetail: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => OrderDetailScreen(
            onHelp: () {},
            onReport: () {},
            onReschedule: () {},
            onRecord: () {},
            onPrice: () {},
          ),
        ),
      ),
    );
  }
}

/// Helper preview for M09 Exit Flow Sheet
class _ExitFlowSheetPreview extends StatelessWidget {
  const _ExitFlowSheetPreview({required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: const BoxDecoration(
            color: K.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(K.rLg)),
            boxShadow: K.shadowSheet,
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: K.s6, vertical: K.s6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: const BoxDecoration(color: K.hairline, borderRadius: K.rPill),
                    ),
                  ),
                  const SizedBox(height: K.s5),
                  const Text('نحفظ طلبك كمسودة؟', style: KT.t2),
                  const SizedBox(height: K.s2),
                  const Text(
                    'تجد القطع والعنوان كما تركتها عند عودتك إلى «اطلب استلاماً».',
                    style: KT.p,
                  ),
                  const SizedBox(height: K.s6),
                  KwButton('احفظ واخرج', onPressed: onDone),
                  const SizedBox(height: K.s3),
                  KwButton(
                    'أكمل الطلب',
                    variant: KwBtnVariant.ghost,
                    onPressed: onDone,
                  ),
                  const SizedBox(height: K.s4),
                  GestureDetector(
                    onTap: onDone,
                    child: const Center(
                      child: Text(
                        'احذف المسودة',
                        style: TextStyle(
                          fontFamily: 'Tajarib',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: K.danger,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: K.s2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper preview for C2 Orders Tab
class _OrdersTabPreview extends StatefulWidget {
  const _OrdersTabPreview({required this.initialTab, required this.onClose});

  final int initialTab;
  final VoidCallback onClose;

  @override
  State<_OrdersTabPreview> createState() => _OrdersTabPreviewState();
}

class _OrdersTabPreviewState extends State<_OrdersTabPreview> {
  late int tab = widget.initialTab;

  @override
  Widget build(BuildContext context) {
    return OrdersScreen(
      onHome: widget.onClose,
      onAccount: widget.onClose,
      onOrderDetail: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => OrderDetailScreen(
              onHelp: () {},
              onReport: () {},
              onReschedule: () {},
              onRecord: () {},
              onPrice: () {},
            ),
          ),
        );
      },
      onPrice: () {},
      onCount: () {},
      onLogin: () {},
      onOrder: () {},
    );
  }
}

/// Helper preview for C2 Empty state
class _OrdersEmptyPreview extends StatelessWidget {
  const _OrdersEmptyPreview({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return KwScreen(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(K.s6, K.s10, K.s6, K.s2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(Icons.arrow_back_ios, size: 20, color: K.ink),
                ),
                const Text('طلباتي', style: KT.t1),
              ],
            ),
          ),
          Expanded(
            child: Padding(
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
                  KwButton('سجّل الدخول', block: false, onPressed: onClose),
                ],
              ),
            ),
          ),
          KwTabBar(index: 1, onTap: (_) => onClose()),
        ],
      ),
    );
  }
}

/// Helper preview for C2.1 in progress
class _OrderDetailPreview extends StatelessWidget {
  const _OrderDetailPreview({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return OrderDetailScreen(
      onHelp: () => showKwToast(context, 'المساعدة في هذا الطلب'),
      onReport: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ReportScreen(
            onSent: () {
              Navigator.of(context).maybePop();
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const ReportStatusScreen()),
              );
            },
          ),
        ),
      ),
      onReschedule: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const RescheduleScreen()),
      ),
      onRecord: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const DeliveryRecordScreen()),
      ),
      onPrice: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => PriceChangeScreen(onDone: () => Navigator.of(context).maybePop()),
        ),
      ),
    );
  }
}
