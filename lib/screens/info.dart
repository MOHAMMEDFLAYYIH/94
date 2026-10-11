import 'package:flutter/material.dart';

import '../main.dart';
import '../state/app_state.dart';
import '../theme/icons.dart';
import '../theme/tokens.dart';
import '../widgets/chrome.dart';
import 'account.dart' show KwTabs;
import '../widgets/controls.dart';
import '../widgets/layout.dart';

/// C1.1 · الأسعار.
class PricesScreen extends StatefulWidget {
  const PricesScreen({super.key, required this.onOrder});

  final VoidCallback onOrder;

  @override
  State<PricesScreen> createState() => _PricesScreenState();
}

class _PricesScreenState extends State<PricesScreen> {
  Service svc = Service.iron;
  final open = <String>{'shirts', 'robes'};

  String fmtPrice(int base) => fmtK((base * svc.k / 250).round() * 250);

  static String _countLabel(int n) =>
      n > 2 ? '$n قطع' : (n == 2 ? 'قطعتان' : 'قطعة');

  @override
  Widget build(BuildContext context) {
    return KwScreen(
      child: Column(
        children: [
          KwTopBar(title: 'أسعار الكوي', onBack: () => Navigator.of(context).maybePop()),
          KwBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KwTabs(
                  index: Service.values.indexOf(svc),
                  labels: const ['كوي', 'غسيل وكوي', 'تنظيف جاف'],
                  onTap: (i) => setState(() => svc = Service.values[i]),
                ),
                const SizedBox(height: K.s3),
                for (final c in kPriceGroups) ...[
                  GestureDetector(
                    onTap: () => setState(() {
                      open.contains(c.id) ? open.remove(c.id) : open.add(c.id);
                    }),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: K.s4),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: K.hairline)),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text(c.name, style: KT.t3)),
                          Text(_countLabel(c.items.length), style: KT.cap),
                          const SizedBox(width: K.s2),
                          AnimatedRotation(
                            turns: open.contains(c.id) ? 0.25 : 0,
                            duration: const Duration(milliseconds: 160),
                            child: const Icon(Icons.chevron_left,
                                size: 20, color: K.inkSubtle),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (open.contains(c.id))
                    Padding(
                      padding: const EdgeInsets.only(bottom: K.s3),
                      child: KwCard(
                        padding: const EdgeInsets.all(K.s4),
                        gap: K.s2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final i in c.items) KwAmount(i.$1, fmtPrice(i.$2)),
                          ],
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
          KwFooter(
            children: [KwButton('اطلب استلاماً', onPressed: widget.onOrder)],
          ),
        ],
      ),
    );
  }
}

/// C1.1 · بحث بلا نتائج.
class NoResultsScreen extends StatelessWidget {
  const NoResultsScreen({super.key, required this.onAdd, required this.onOrder});

  final VoidCallback onAdd;
  final VoidCallback onOrder;

  @override
  Widget build(BuildContext context) {
    return KwScreen(
      child: Column(
        children: [
          KwTopBar(title: 'لم نجد هذه القطعة', onBack: () => Navigator.of(context).maybePop()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(K.s6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(color: K.surface, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const KwIcon('search', size: 40, color: K.brand),
                  ),
                  const SizedBox(height: K.s4),
                  const Text('لم نجد هذه القطعة', style: KT.t3),
                  const SizedBox(height: K.s2),
                  const Text(
                    'يمكنك إضافتها في طلبك ونؤكّد سعرها معك قبل الاستلام.',
                    textAlign: TextAlign.center,
                    style: KT.cap,
                  ),
                  const SizedBox(height: K.s6),
                  KwButton('أضفها قطعةً أخرى', block: false, onPressed: onAdd),
                  const SizedBox(height: K.s3),
                  const Text(
                    'جرّب اسماً آخر: بدلة، ثوب، جاكيت، شماغ…',
                    textAlign: TextAlign.center,
                    style: KT.cap,
                  ),
                ],
              ),
            ),
          ),
          KwFooter(children: [KwButton('التالي', onPressed: onOrder)]),
        ],
      ),
    );
  }
}

/// C1.2 · كيف نحمي ملابسك.
class ProtectScreen extends StatefulWidget {
  const ProtectScreen({super.key, required this.onOrder});

  final VoidCallback onOrder;

  @override
  State<ProtectScreen> createState() => _ProtectScreenState();
}

class _ProtectScreenState extends State<ProtectScreen> {
  int? openFaq;

  static const steps = [
    'نرسل لك اسم المندوب وصورته قبل وصوله.',
    'نعدّ القطع أمامك، أو نغلقها في كيس مختوم برقم.',
    'المحل يسجّل أي بقعة أو تمزّق موجود قبل العمل.',
    'نبلغك بأي أمر قبل أن تسأل.',
    'إن حدثت مشكلة، نحن نحلّها — لا تتعامل مع المحل أو المندوب.',
  ];

  static const faqs = [
    (
      'ماذا لو ضاعت قطعة؟',
      'بلّغنا من «مشكلة في الطلب». نراجع سجل التسليم ونقرّر بالدليل، ويشملك ضمان كويلي.'
    ),
    ('هل أعرف المحل؟', 'تتعامل مع كويلي فقط. نحن المسؤولون عن طلبك من الاستلام حتى التسليم.'),
    (
      'ماذا لو لم أكن في البيت؟',
      'اختر من يسلّم الكيس: أنت أو فرد من العائلة أو حارس العمارة. وإن لم نجد أحداً، تختار موعداً جديداً.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return KwScreen(
      child: Column(
        children: [
          KwTopBar(title: 'كيف نحمي ملابسك', onBack: () => Navigator.of(context).maybePop()),
          KwBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(K.s6),
                  decoration: const BoxDecoration(
                    color: K.tintGrey,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(K.rXl),
                      bottomRight: Radius.circular(K.rXl),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('من بابك إلى بابك، وجهة واحدة مسؤولة', style: KT.t1),
                      const SizedBox(height: K.s4),
                      for (var i = 0; i < steps.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: K.s3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                    color: K.surface, shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: Text('${i + 1}',
                                    style: const TextStyle(
                                        fontFamily: 'Tajarib',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: K.brandText)),
                              ),
                              const SizedBox(width: K.s3),
                              Expanded(
                                child: Text(steps[i],
                                    style: KT.p.copyWith(color: K.brandText)),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: K.s5),
                const Text('ما ستراه في سجل التسليم', style: KT.t3),
                const SizedBox(height: K.s2),
                const KwCard(
                  gap: K.s2,
                  padding: EdgeInsets.all(K.s4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KwAmount('العدد المعدود', '12 قطعة'),
                      KwAmount('رقم الختم', 'S-58213'),
                      KwAmount('صورة الكيس', 'موثّق'),
                      KwAmount('قطعة غالية', 'مصوّرة'),
                      KwAmount('ملاحظة المحل', 'قبل الكوي'),
                    ],
                  ),
                ),
                const SizedBox(height: K.s5),
                const Text('الخصوصية', style: KT.t3),
                const SizedBox(height: K.s2),
                const _Privacy('كيس معتم بلا شعار', 'bag'),
                const _Privacy('ملابس كل زبون تُعالج منفصلة', 'check'),
                const _Privacy('الصور يراها أنت وفريق كويلي فقط', 'shield'),
                const SizedBox(height: K.s5),
                const Text('ضمان كويلي', style: KT.t3),
                const SizedBox(height: K.s2),
                const Text(
                  'نتحمّل الفقد والتلف، ونقرّر بالدليل الموثّق.',
                  style: KT.p,
                ),
                const SizedBox(height: K.s5),
                const Text('أسئلة شائعة', style: KT.t3),
                const SizedBox(height: K.s2),
                for (var i = 0; i < faqs.length; i++) ...[
                  GestureDetector(
                    onTap: () => setState(() => openFaq = openFaq == i ? null : i),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: K.s4),
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: K.hairline))),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(faqs[i].$1,
                                  style: KT.strong.copyWith(fontWeight: FontWeight.w700))),
                          AnimatedRotation(
                            turns: openFaq == i ? 0.25 : 0,
                            duration: const Duration(milliseconds: 160),
                            child: const Icon(Icons.chevron_left,
                                size: 20, color: K.inkSubtle),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (openFaq == i)
                    Padding(
                      padding: const EdgeInsets.only(top: K.s2, bottom: K.s3),
                      child: Text(faqs[i].$2, style: KT.p),
                    ),
                ],
              ],
            ),
          ),
          KwFooter(children: [KwButton('اطلب استلاماً', onPressed: widget.onOrder)]),
        ],
      ),
    );
  }
}

class _Privacy extends StatelessWidget {
  const _Privacy(this.text, this.icon);

  final String text;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: K.s3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KwIcon(icon, size: 20, color: K.brand),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: KT.p)),
        ],
      ),
    );
  }
}

/// X01 · الرئيسية (تحميل).
class LoadingHomeScreen extends StatelessWidget {
  const LoadingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KwScreen(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(K.s6, K.s10, K.s6, K.s2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                KwWordmark(height: 28),
                KwSkeleton(width: 90, height: 16),
              ],
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(K.s6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KwSkeleton(width: 140, height: 16),
                  SizedBox(height: K.s2),
                  KwSkeleton(width: 220, height: 32, radius: K.rMd),
                  SizedBox(height: K.s6),
                  Row(
                    children: [
                      Expanded(child: KwSkeleton(height: 148, radius: K.rMd)),
                      SizedBox(width: K.s3),
                      Expanded(child: KwSkeleton(height: 148, radius: K.rMd)),
                    ],
                  ),
                  SizedBox(height: K.s3),
                  Row(
                    children: [
                      Expanded(child: KwSkeleton(height: 112, radius: K.rMd)),
                      SizedBox(width: 10),
                      Expanded(child: KwSkeleton(height: 112, radius: K.rMd)),
                      SizedBox(width: 10),
                      Expanded(child: KwSkeleton(height: 112, radius: K.rMd)),
                    ],
                  ),
                  SizedBox(height: K.s6),
                  KwSkeleton(height: 20),
                  SizedBox(height: K.s3),
                  KwSkeleton(height: 90, radius: K.rMd),
                ],
              ),
            ),
          ),
          KwTabBar(index: 0, onTap: (_) {}),
        ],
      ),
    );
  }
}

/// X02 · لا يوجد اتصال.
class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return KwScreen(
      child: Column(
        children: [
          const KwTopBar(title: 'لا يوجد اتصال', showBack: false),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(K.s6, K.s4, K.s6, K.s8),
              children: [
                const Text('تعرض آخر بيانات محفوظة · 7:42 م', style: KT.cap),
                const SizedBox(height: K.s4),
                KwButton('أعد المحاولة', md: true, block: false, onPressed: onRetry),
                const SizedBox(height: K.s5),
                const Text('مساء الخير، حيدر', style: KT.cap),
                const SizedBox(height: K.s2),
                const Text('Q-0142', style: KT.t2),
                const SizedBox(height: K.s2),
                const Text('جاهزة قبل السبت 10 أكتوبر', style: KT.p),
                const SizedBox(height: K.s5),
                const KwButton('اطلب استلاماً', onPressed: null),
                const SizedBox(height: K.s3),
                const Text(
                  'تحتاج اتصالاً لإرسال طلب جديد. الصور التي تلتقطها تُحفظ وتُرسل عند عودة الاتصال.',
                  style: KT.cap,
                ),
              ],
            ),
          ),
          KwTabBar(index: 0, onTap: (_) {}),
        ],
      ),
    );
  }
}

/// X03/X05 · خطأ / طلب غير موجود.
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, this.mode = 'error', required this.onRetry, required this.onOrders});

  final String mode;
  final VoidCallback onRetry;
  final VoidCallback onOrders;

  @override
  Widget build(BuildContext context) {
    final notFound = mode == 'notfound';

    return KwScreen(
      child: Column(
        children: [
          KwTopBar(title: notFound ? 'لم نجد هذا الطلب' : 'حدث خطأ من جهتنا', showBack: false),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(K.s6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(color: K.surface, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: KwIcon(notFound ? 'search' : 'info',
                        size: 40, color: notFound ? K.brand : K.danger),
                  ),
                  const SizedBox(height: K.s4),
                  Text(
                    notFound ? 'لم نجد هذا الطلب' : 'حدث خطأ من جهتنا',
                    textAlign: TextAlign.center,
                    style: KT.t3,
                  ),
                  const SizedBox(height: K.s2),
                  Text(
                    notFound
                        ? 'ربما الرابط قديم أو الطلب على رقم آخر. تجد كل طلباتك في «طلباتي».'
                        : 'ليس بسببك. طلباتك وبياناتك محفوظة. أعد المحاولة بعد قليل.',
                    textAlign: TextAlign.center,
                    style: KT.cap,
                  ),
                  const SizedBox(height: K.s6),
                  if (notFound)
                    KwButton('طلباتي', block: false, onPressed: onOrders)
                  else ...[
                    KwButton('أعد المحاولة', block: false, onPressed: onRetry),
                    const SizedBox(height: K.s3),
                    KwButton('واتساب كويلي', variant: KwBtnVariant.ghost, md: true, block: false, onPressed: onRetry),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// F1.5 · نؤكّد طلبك.
class OrderConfirmedScreen extends StatelessWidget {
  const OrderConfirmedScreen({super.key, required this.onHome});

  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return KwScreen(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(K.s6, K.s10, K.s6, K.s8),
              children: [
                const Center(child: KwWordmark(height: 36)),
                const SizedBox(height: K.s5),
                const Center(child: Text('نؤكّد طلبك', style: KT.t1)),
                const SizedBox(height: K.s5),
                KwCard(
                  gap: K.s2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('رمز الطلب', style: KT.cap),
                      const Ltr('Q-0142', style: TextStyle(
                          fontFamily: 'Tajarib',
                          fontSize: 26,
                          height: 38 / 26,
                          fontWeight: FontWeight.w700)),
                      const SizedBox(height: K.s2),
                      Text(
                        'الاستلام ${app.day.full} ${app.slot.t} · المبلغ المتوقّع',
                        style: KT.p,
                      ),
                      Text('${fmtK(app.total)} د.ع نقداً', style: KT.t2),
                    ],
                  ),
                ),
                const SizedBox(height: K.s5),
                const Text('ماذا يحدث الآن', style: KT.t3),
                const SizedBox(height: K.s3),
                for (final t in [
                  'نرسل لك اسم المندوب وصورته.',
                  'يستلم ويعدّ القطع معك.',
                  'نبلغك بكل مرحلة على واتساب.',
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: K.s3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const KwIcon('check', size: 20, color: K.brand),
                        const SizedBox(width: 10),
                        Expanded(child: Text(t, style: KT.p)),
                      ],
                    ),
                  ),
                const SizedBox(height: K.s3),
                KwCard(
                  gap: K.s2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        children: [
                          Expanded(
                              child: Text('اجعلها كل أسبوع',
                                  style: TextStyle(
                                      fontFamily: 'Tajarib',
                                      fontSize: 15,
                                      height: 24 / 15,
                                      fontWeight: FontWeight.w700))),
                          KwBadge('نشط', tone: KwBadgeTone.green),
                        ],
                      ),
                      Text(
                        'نأتيك كل ${app.day.full} ${app.slot.t}. تقدر تتخطّى أي أسبوع.',
                        style: KT.cap,
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: KwButton('فعّل', md: true, block: false, onPressed: () {
                          showKwToast(context, 'فعّلنا الموعد الثابت');
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: K.s5),
                KwButton('تفاصيل الطلب', variant: KwBtnVariant.ghost, md: true, onPressed: onHome),
              ],
            ),
          ),
          KwTabBar(index: 0, onTap: (_) => onHome()),
        ],
      ),
    );
  }
}
