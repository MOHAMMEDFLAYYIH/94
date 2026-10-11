import 'dart:async';

import 'package:flutter/material.dart';

import '../main.dart';
import '../state/app_state.dart';
import '../theme/icons.dart';
import '../theme/tokens.dart';
import '../widgets/chrome.dart';
import '../widgets/controls.dart';
import '../widgets/layout.dart';

/// C2.1 · تفاصيل الطلب. `variant` selects the three prototype states.
class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({
    super.key,
    required this.onHelp,
    required this.onReschedule,
    required this.onPrice,
    required this.onRecord,
    required this.onReport,
    this.variant = OrderDetailVariant.needsReply,
  });

  final VoidCallback onHelp;
  final VoidCallback onReschedule;
  final VoidCallback onPrice;
  final VoidCallback onRecord;
  final VoidCallback onReport;
  final OrderDetailVariant variant;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return KwScreen(
      child: Column(
        children: [
          KwTopBar(
            title: 'Q-0142',
            onBack: () => Navigator.of(context).maybePop(),
            action: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                KwIconButton('help', tooltip: 'مساعدة', onTap: onHelp),
                const SizedBox(width: K.s2),
              ],
            ),
          ),
          KwBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const KwTracker(stages: kStages, strongNow: 1),
                const SizedBox(height: K.s2),
                const Text('آخر تحديث: اليوم 11:20 ص', style: KT.cap),
                if (variant == OrderDetailVariant.delay) ...[
                  const SizedBox(height: K.s4),
                  const KwBanner(
                    icon: 'clock',
                    tone: KwBannerTone.mint,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'تأخّر طلبك — الموعد الجديد الأحد 6–8 م',
                          style: TextStyle(
                              fontFamily: 'Tajarib', fontSize: 15, height: 24 / 15, fontWeight: FontWeight.w700),
                        ),
                        Text('لا تحتاج فعل شيء.', style: KT.cap),
                      ],
                    ),
                  ),
                  const SizedBox(height: K.s3),
                  const KwCard(
                    gap: K.s2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('ماذا حدث:', style: KT.strong),
                        Text('قميص واحد يحتاج كوياً ثانياً.', style: KT.p),
                        SizedBox(height: K.s2),
                        Text('ماذا نفعل:', style: KT.strong),
                        Text('نعيد كيّه بلا مقابل، والموعد لم يتغيّر.', style: KT.p),
                        SizedBox(height: K.s2),
                        Text('هل عليك شيء:', style: KT.strong),
                        Text('لا.', style: KT.p),
                      ],
                    ),
                  ),
                ] else if (variant == OrderDetailVariant.followUp) ...[
                  const SizedBox(height: K.s4),
                  KwCard(
                    outlined: true,
                    gap: K.s2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: KT.strong,
                            children: [
                              const TextSpan(text: 'وجد المحل قطعة إضافية: عباءة بـ '),
                              TextSpan(
                                text: fmtK(app.extraAmount),
                                style: KT.green(KT.strong),
                              ),
                              const TextSpan(text: ' د.ع'),
                            ],
                          ),
                        ),
                        const Text('لن نعالجها قبل موافقتك.', style: KT.cap),
                        const SizedBox(height: K.s2),
                        KwButton('راجع وقرّر',
                            variant: KwBtnVariant.secondary, md: true, onPressed: onPrice),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: K.s5),
                const Text('من سيأتي', style: KT.t3),
                const SizedBox(height: K.s2),
                const Text(
                  'نرسل لك اسم مندوب التسليم وصورته قبل وصوله.',
                  style: KT.cap,
                ),
                const SizedBox(height: K.s5),
                const Text('القطع والمبلغ', style: KT.t3),
                const SizedBox(height: K.s2),
                _ItemsSummary(app: app),
                if (variant == OrderDetailVariant.followUp) ...[
                  const SizedBox(height: K.s4),
                  const Text('سجل التسليم', style: KT.t3),
                  const SizedBox(height: K.s2),
                  KwCard(
                    gap: K.s3,
                    onTap: onRecord,
                    padding: const EdgeInsets.all(K.s4),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            KwLead('image', size: 44),
                            SizedBox(width: K.s3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('صورة الكيس', style: KT.strong),
                                  Text('12 قطعة · أكّدتها أنت', style: KT.cap),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_left, size: 18, color: K.inkSubtle),
                          ],
                        ),
                        KwTextButton('عرض السجل كاملاً', dense: true),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: K.s4),
                KwCard(
                  gap: K.s2,
                  padding: const EdgeInsets.all(K.s4),
                  child: Row(
                    children: [
                      const KwLead('cash', size: 44, bg: K.tintGreen, color: K.brandText),
                      const SizedBox(width: K.s3),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('الدفع', style: KT.cap),
                            Text('نقداً عند التسليم', style: KT.strong),
                          ],
                        ),
                      ),
                      Text('${fmtK(app.total)} د.ع', style: KT.t2),
                    ],
                  ),
                ),
                const SizedBox(height: K.s5),
                const Text('المساعدة في هذا الطلب', style: KT.t3),
                const SizedBox(height: K.s2),
                KwRow(
                  leading: const KwLead('info', size: 44),
                  title: 'مشكلة في الطلب',
                  chevron: true,
                  onTap: onReport,
                ),
                KwRow(
                  leading: const KwLead('clock', size: 44),
                  title: 'تغيير موعد التسليم',
                  description: 'متاح مرة واحدة بعد أن تصبح جاهزة.',
                  chevron: true,
                  onTap: onReschedule,
                ),
                const KwRow(
                  leading: KwLead('whatsapp', size: 44),
                  title: 'تواصل مع كويلي',
                  description: 'واتساب برسالة فيها رمز طلبك.',
                  chevron: true,
                ),
                const SizedBox(height: K.s5),
                const Text('بلاغات هذا الطلب', style: KT.t3),
                const SizedBox(height: K.s2),
                const Text('لا بلاغات.', style: KT.cap),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum OrderDetailVariant { needsReply, delay, followUp }

class _ItemsSummary extends StatelessWidget {
  const _ItemsSummary({required this.app, this.delivered = false});

  final AppState app;
  final bool delivered;

  @override
  Widget build(BuildContext context) {
    return KwCard(
      gap: K.s2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final l in app.lines)
            KwAmount(
              '${l.garment.name} × ${l.qty} · ${l.service.short}'
              '${l.valuable ? ' · غالية' : ''}',
              fmtK(l.lineTotal),
            ),
          const Divider(height: K.s3, color: K.hairline),
          KwAmount('المبلغ النهائي · ${app.pieceCount} قطعة', fmtK(app.total), strong: true),
          const Text(
            'ثُبّت بعد العدّ. لا يتغيّر دون موافقتك.',
            style: KT.cap,
          ),
        ],
      ),
    );
  }
}

/// M01/M02 · تأكيد العدد.
class CountConfirmScreen extends StatefulWidget {
  const CountConfirmScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<CountConfirmScreen> createState() => _CountConfirmScreenState();
}

class _CountConfirmScreenState extends State<CountConfirmScreen> {
  final app = AppState();
  final note = TextEditingController();
  bool edited = false;
  int localCount = 12;

  @override
  void dispose() {
    note.dispose();
    app.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final match = state.countedByYou == state.countedByCourier && !edited;

    return KwScreen(
      child: Column(
        children: [
          KwTopBar(
            title: 'Q-0142',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          KwBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: K.tintGreen,
                      child: Text('ع',
                          style: TextStyle(
                              fontFamily: 'Tajarib', fontSize: 20, fontWeight: FontWeight.w700, color: K.brandText)),
                    ),
                    SizedBox(width: K.s3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('علي من كويلي عند بابك الآن', style: KT.strong),
                          Text('عدّ المندوب 12 قطعة', style: KT.cap),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: K.s4),
                const KwPhoto(label: 'صورة الكيس'),
                const SizedBox(height: K.s2),
                const Text('8:12 م', style: KT.cap),
                const SizedBox(height: K.s5),
                Row(
                  children: [
                    Expanded(
                      child: _CountBox(
                        label: 'العدد الذي أدخلته',
                        value: state.countedByYou,
                        highlight: false,
                      ),
                    ),
                    const SizedBox(width: K.s3),
                    Expanded(
                      child: _CountBox(
                        label: 'العدد المعدود',
                        value: state.countedByCourier,
                        highlight: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: K.s4),
                const KwGroupLabel('رقم الختم'),
                const Text('S-58213', style: KT.num),
                const SizedBox(height: K.s4),
                if (match)
                  const KwBanner(
                    icon: 'check',
                    tone: KwBannerTone.mint,
                    child: Text('العددان متطابقان.', style: KT.strong),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('العدد غير صحيح', style: KT.t3),
                      const SizedBox(height: K.s2),
                      const Text('كم قطعة سلّمت؟', style: KT.strong),
                      const SizedBox(height: K.s2),
                      KwStepper(
                        value: localCount,
                        onDec: () => setState(() {
                          localCount = localCount > 0 ? localCount - 1 : 0;
                          edited = true;
                        }),
                        onInc: () => setState(() {
                          localCount++;
                          edited = true;
                        }),
                      ),
                      const SizedBox(height: K.s2),
                      Text('عدد القطع: $localCount', style: KT.cap),
                      const SizedBox(height: K.s3),
                      KwField(label: 'ملاحظة', controller: note, maxLines: 2),
                      const SizedBox(height: K.s3),
                      const Text(
                        'لن يأخذ المندوب الكيس حتى نتفق. يتصل بك فريق كويلي الآن.',
                        style: KT.cap,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          KwFooter(
            children: [
              if (match)
                KwButton('العدد صحيح', onPressed: widget.onDone)
              else
                Row(
                  children: [
                    Expanded(
                      child: KwButton('رجوع', variant: KwBtnVariant.ghost, md: true, onPressed: () {
                        setState(() {
                          edited = false;
                          localCount = state.countedByYou;
                        });
                      }),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: KwButton('أرسل', md: true, onPressed: () {
                        state.countedByYou = localCount;
                        widget.onDone();
                      }),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountBox extends StatelessWidget {
  const _CountBox({required this.label, required this.value, required this.highlight});

  final String label;
  final int value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(K.s4),
      decoration: BoxDecoration(
        color: K.surface,
        borderRadius: BorderRadius.circular(K.rMd),
        border: Border.all(color: highlight ? K.action : K.hairline, width: highlight ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: KT.cap),
          const SizedBox(height: K.s1),
          Text('$value', style: KT.t2),
        ],
      ),
    );
  }
}

/// M03 · الموافقة على تغيير السعر.
class PriceChangeScreen extends StatelessWidget {
  const PriceChangeScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return KwScreen(
      child: Column(
        children: [
          KwTopBar(title: 'Q-0142', onBack: () => Navigator.of(context).maybePop()),
          KwBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                  text: TextSpan(
                    style: KT.t2,
                    children: [
                      const TextSpan(text: 'وجد المحل قطعة إضافية: عباءة بـ '),
                      TextSpan(
                          text: fmtK(app.extraAmount),
                          style: KT.green(KT.t2)),
                      const TextSpan(text: ' د.ع'),
                    ],
                  ),
                ),
                const SizedBox(height: K.s4),
                const KwPhoto(label: 'صورة القطعة'),
                const SizedBox(height: K.s2),
                const Text('من المحل', style: KT.cap),
                const SizedBox(height: K.s3),
                const Text(
                  'لم تكن في طلبك. وجدها المحل داخل الكيس عند فتحه.',
                  style: KT.p,
                ),
                const SizedBox(height: K.s5),
                KwCard(
                  gap: K.s2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KwAmount('المبلغ الحالي', fmtK(app.baseTotal), strong: true),
                      KwAmount('عباءة · كوي', '+${fmtK(app.extraAmount)}', strong: true),
                      const Divider(height: K.s3, color: K.hairline),
                      KwAmount('المبلغ الجديد', fmtK(app.total), strong: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
          KwFooter(
            children: [
              KwButton('أوافق', onPressed: () {
                app.approveExtra(true);
                onDone();
              }),
              KwButton(
                'لا، أعيدوها دون معالجة',
                variant: KwBtnVariant.ghost,
                md: true,
                onPressed: () {
                  app.approveExtra(false);
                  onDone();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// C2.1 · في الطريق إليك / تم التسليم.
class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({
    super.key,
    required this.delivered,
    required this.onRate,
    required this.onReport,
    required this.onRepeat,
    required this.onRecord,
  });

  final bool delivered;
  final VoidCallback onRate;
  final VoidCallback onReport;
  final VoidCallback onRepeat;
  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return KwScreen(
      child: Column(
        children: [
          KwTopBar(
            title: 'Q-0142',
            onBack: () => Navigator.of(context).maybePop(),
            action: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                KwIconButton('help', tooltip: 'مساعدة', onTap: onReport),
                const SizedBox(width: K.s2),
              ],
            ),
          ),
          KwBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KwTracker(stages: kStages, strongNow: delivered ? 5 : 4),
                const SizedBox(height: K.s4),
                if (!delivered) ...[
                  KwCard(
                    gap: K.s2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('جهّز المبلغ نقداً', style: KT.t3),
                        Text('${fmtK(app.total)} د.ع', style: KT.t2.copyWith(color: K.brandText)),
                        const Text(
                          'تدفعه للمندوب عند التسليم. يصلك إيصال في سجل التسليم.',
                          style: KT.cap,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: K.s4),
                  const Text('من سيأتي', style: KT.t3),
                  const SizedBox(height: K.s2),
                  const _CourierRow(),
                  const SizedBox(height: K.s4),
                  KwButton('تتبّع المندوب على الخريطة',
                      variant: KwBtnVariant.ghost, md: true,
                      onPressed: () => Navigator.of(context).pushNamed('/map')),
                ] else ...[
                  const Text('كيف كانت الخدمة؟', style: KT.t3),
                  const SizedBox(height: K.s2),
                  KwButton('قيّم الخدمة', md: true, onPressed: onRate),
                ],
                const SizedBox(height: K.s5),
                _ItemsSummary(app: app, delivered: delivered),
                const SizedBox(height: K.s5),
                const Text('المساعدة في هذا الطلب', style: KT.t3),
                KwRow(
                  leading: const KwLead('info', size: 44),
                  title: 'مشكلة في الطلب',
                  chevron: true,
                  onTap: onReport,
                ),
                if (delivered)
                  KwRow(
                    leading: const KwLead('bag', size: 44),
                    title: 'أعد هذا الطلب',
                    chevron: true,
                    onTap: onRepeat,
                  ),
                if (delivered) ...[
                  const SizedBox(height: K.s4),
                  KwCard(
                    gap: K.s2,
                    padding: const EdgeInsets.all(K.s4),
                    child: Row(
                      children: [
                        const KwLead('cash', size: 44, bg: K.tintGreen, color: K.brandText),
                        const SizedBox(width: K.s3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('الدفع', style: KT.cap),
                              Text('دُفع ${fmtK(app.total)} د.ع نقداً', style: KT.strong),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: K.s4),
                  KwCard(
                    gap: K.s2,
                    padding: const EdgeInsets.all(K.s4),
                    onTap: onRecord,
                    child: Row(
                      children: [
                        const KwLead('image', size: 44),
                        const SizedBox(width: K.s3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('سجل التسليم', style: KT.strong),
                              Text(
                                '${app.pieceCount + (app.extraItemApproved ? 1 : 0)} قطعة · سُلّمت إليك · رقم الختم S-58213',
                                style: KT.cap,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_left, size: 18, color: K.inkSubtle),
                      ],
                    ),
                  ),
                  const SizedBox(height: K.s5),
                  const Text('بلاغات هذا الطلب', style: KT.t3),
                  const SizedBox(height: K.s2),
                  Container(
                    padding: const EdgeInsets.all(K.s4),
                    decoration: BoxDecoration(
                      color: K.surface,
                      borderRadius: BorderRadius.circular(K.rMd),
                      border: Border.all(color: K.danger),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('قطعة تالفة · نراجع',
                                  style: TextStyle(
                                      fontFamily: 'Tajarib',
                                      fontSize: 15,
                                      height: 24 / 15,
                                      fontWeight: FontWeight.w500)),
                              Text('أُرسل السبت 9:40 م', style: KT.cap),
                            ],
                          ),
                        ),
                        KwIcon('clock', size: 20, color: K.danger),
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

class _CourierRow extends StatelessWidget {
  const _CourierRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(K.s4),
      decoration: BoxDecoration(
        color: K.surface,
        borderRadius: BorderRadius.circular(K.rMd),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: K.tintGreen,
            child: Text('ع',
                style: TextStyle(
                    fontFamily: 'Tajarib', fontSize: 20, fontWeight: FontWeight.w700, color: K.brandText)),
          ),
          SizedBox(width: K.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('علي · من كويلي · يصل 6–8 م', style: KT.strong),
                Text('سيارة بيضاء · بغداد · 12 أ 34567', style: KT.cap),
                Text('الاتصال برقم محجوب.', style: KT.cap),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// C2.1b · تتبّع المندوب على الخريطة.
class MapTrackingScreen extends StatefulWidget {
  const MapTrackingScreen({super.key, this.initial = MapPhase.delivery});

  final MapPhase initial;

  @override
  State<MapTrackingScreen> createState() => _MapTrackingScreenState();
}

class _MapTrackingScreenState extends State<MapTrackingScreen> {
  late MapPhase phase = widget.initial;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      if (phase == MapPhase.delivery) setState(() => phase = MapPhase.arrived);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final arrived = phase == MapPhase.arrived;

    final (chip, eyebrow, head, badge, payLabel) = switch (phase) {
      MapPhase.pickup => (
          'في طريقه للاستلام',
          'يصل المندوب لاستلام ملابسك خلال',
          '12 دقيقة',
          'طلبك مؤكد',
          'المبلغ المتوقّع · تدفعه عند التسليم'
        ),
      MapPhase.delivery => (
          'في الطريق إليك',
          'تصلك ملابسك خلال',
          '12 دقيقة',
          'في الطريق إليك',
          'جهّز المبلغ نقداً'
        ),
      MapPhase.arrived => (
          'المندوب عند بابك',
          'وصل الآن',
          'المندوب عند بابك',
          'في الطريق إليك',
          'ادفع للمندوب نقداً'
        ),
    };

    return KwScreen(
      child: Column(
        children: [
          KwTopBar(
            title: 'Q-0142',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 300,
                    child: CustomPaint(
                      painter: _MapPainter(arrived: arrived),
                      child: SizedBox.expand(
                        child: Padding(
                          padding: const EdgeInsets.all(K.s6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: KwBubble(chip)),
                                  if (!arrived) const KwBadge('خلال 12 دقيقة', tone: KwBadgeTone.green),
                                ],
                              ),
                              const Spacer(),
                              Text(eyebrow, style: KT.cap),
                              Text(head, style: KT.t1),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(K.s6, K.s4, K.s6, K.s8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _CourierRow(),
                        const SizedBox(height: K.s2),
                        const Text(
                          'عدّ القطع مع المندوب قبل أن يغادر. يصلك الإيصال في سجل التسليم.',
                          style: KT.cap,
                        ),
                        const SizedBox(height: K.s3),
                        KwCard(
                          gap: K.s2,
                          padding: const EdgeInsets.all(K.s4),
                          child: Row(
                            children: [
                              const KwLead('cash', size: 44, bg: K.tintGreen, color: K.brandText),
                              const SizedBox(width: K.s3),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(payLabel, style: KT.cap),
                                    Text('${fmtK(app.total)} د.ع',
                                        style: KT.strong.copyWith(fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: K.s2),
                        KwButton('تفاصيل الطلب', variant: KwBtnVariant.ghost, md: true, onPressed: () {
                          Navigator.of(context).maybePop();
                        }),
                        const Text(
                          'الاتصال برقم محجوب · الموقع يتحدّث كل بضع ثوانٍ',
                          textAlign: TextAlign.center,
                          style: KT.cap,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum MapPhase { pickup, delivery, arrived }

class _MapPainter extends CustomPainter {
  _MapPainter({required this.arrived});

  final bool arrived;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFE6EFE9));

    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final minor = Paint()
      ..color = const Color(0xFFF2F6F3)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var i = 1; i < 6; i++) {
      final y = size.height * i / 6;
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 24), i.isEven ? road : minor);
    }
    for (var i = 1; i < 5; i++) {
      final x = size.width * i / 5;
      canvas.drawLine(Offset(x, 0), Offset(x + 30, size.height), minor);
    }

    // blocks
    final block = Paint()..color = const Color(0xFFDCE9E1);
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 3; j++) {
        final x = size.width * (i * 0.25) + 12;
        final y = size.height * (j * 0.33) + 10;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, size.width * 0.16, size.height * 0.22),
            const Radius.circular(4),
          ),
          block,
        );
      }
    }

    final route = Paint()
      ..color = K.brand
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final start = Offset(size.width * 0.22, size.height * 0.78);
    final end = Offset(size.width * (arrived ? 0.72 : 0.52), size.height * (arrived ? 0.30 : 0.55));
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.72, end.dx, end.dy);
    canvas.drawPath(path, route);

    // courier pin
    canvas.drawCircle(end, 16, Paint()..color = K.brand.withValues(alpha: 0.18));
    canvas.drawCircle(end, 9, Paint()..color = K.brand);
    canvas.drawCircle(
      end,
      4,
      Paint()..color = Colors.white,
    );

    // home pin
    canvas.drawCircle(start, 12, Paint()..color = K.ink.withValues(alpha: 0.12));
    canvas.drawCircle(start, 7, Paint()..color = K.ink);
  }

  @override
  bool shouldRepaint(_MapPainter old) => old.arrived != arrived;
}

/// C2.2 · سجل التسليم.
class DeliveryRecordScreen extends StatelessWidget {
  const DeliveryRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final events = <({String title, String when, bool done})>[
      (title: 'استلمنا من بابك', when: 'الخميس 8 أكتوبر · 8:14 م', done: true),
      (title: 'وصل المحل', when: 'الخميس · 9:30 م', done: true),
      (title: 'جاهزة', when: 'السبت · 1:15 م', done: true),
      (title: 'خرجت للتسليم', when: 'السبت · 6:10 م', done: true),
      (title: 'سُلّمت إليك', when: 'السبت · 7:05 م', done: true),
      (title: 'دُفع ${fmtK(app.total)} د.ع', when: 'السبت · 7:06 م', done: true),
    ];

    return KwScreen(
      child: Column(
        children: [
          KwTopBar(
            title: 'سجل التسليم · Q-0142',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          KwBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('ملخص العدّ', style: KT.t3),
                const SizedBox(height: K.s2),
                KwCard(
                  gap: K.s2,
                  padding: const EdgeInsets.all(K.s4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KwAmount('العدد الذي أدخلته', '${app.countedByYou} قطعة'),
                      KwAmount('العدد المعدود', '${app.countedByCourier} قطعة'),
                      const KwAmount('طريقة العدّ', 'أمامك عند الباب'),
                      KwAmount('رقم الختم', app.sealNumber),
                      const Text('أكّده: أنت · الخميس 8:14 م', style: KT.cap),
                    ],
                  ),
                ),
                const SizedBox(height: K.s5),
                const Text('الصور', style: KT.t3),
                const SizedBox(height: K.s2),
                Wrap(
                  spacing: K.s2,
                  runSpacing: K.s2,
                  children: [
                    for (final p in const ['الكيس', 'دشداشة 1', 'دشداشة 2']) ...[
                      SizedBox(
                        width: 96,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const KwPhoto(),
                            const SizedBox(height: 4),
                            Text(p, style: KT.strong),
                            const Text('علي · 8:12 م', style: KT.cap),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: K.s2),
                const Text('اضغط الصورة لعرضها بملء الشاشة.', style: KT.cap),
                const SizedBox(height: K.s5),
                const Text('حالة القطع عند الاستلام', style: KT.t3),
                const SizedBox(height: K.s2),
                const KwCard(
                  gap: K.s2,
                  padding: EdgeInsets.all(K.s4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 72, child: KwPhoto(icon: 'alert')),
                      SizedBox(width: K.s3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('صورة البقعة', style: KT.strong),
                            Text('قميص أبيض: بقعة قديمة على الكمّ', style: KT.p),
                            Text('سجّلها المحل قبل الكوي · الجمعة 10:02 ص', style: KT.cap),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: K.s5),
                const Text('الخط الزمني', style: KT.t3),
                const SizedBox(height: K.s3),
                KwTimeline(items: events),
                const SizedBox(height: K.s3),
                const Text(
                  'تراه أنت وفريق كويلي. تُحذف الصور بعد 30 يوماً.',
                  style: KT.cap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// M06 · التقييم.
class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final note = TextEditingController();
  int r = 4;
  final Set<String> tags = {'ontime'};
  bool sent = false;

  static const tagList = [
    ('ontime', 'في الموعد'),
    ('great', 'كوي ممتاز'),
    ('late', 'تأخير'),
    ('item', 'مشكلة في قطعة'),
  ];

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final low = r > 0 && r <= 2;

    return KwScreen(
      child: Column(
        children: [
          KwTopBar(title: 'Q-0142', onBack: () => Navigator.of(context).maybePop()),
          Expanded(
            child: sent
                ? KwState(
                    icon: 'check',
                    title: 'وصل تقييمك',
                    body: 'شكراً، يساعدنا على تحسين الخدمة.',
                    cta: 'تم',
                    onCta: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(K.s6, K.s6, K.s6, K.s8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('كيف كانت الخدمة؟', style: KT.t1),
                          const SizedBox(height: K.s6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var n = 1; n <= 5; n++)
                                Semantics(
                                  button: true,
                                  label: '$n من 5',
                                  child: GestureDetector(
                                    onTap: () => setState(() => r = n),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: Icon(
                                        n <= r ? Icons.star : Icons.star_border,
                                        size: 52,
                                        color: n <= r ? K.brand : K.inkSubtle,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: K.s6),
                          Wrap(
                            spacing: K.s2,
                            runSpacing: K.s2,
                            children: [
                              for (final t in tagList)
                                KwChip(t.$2, selected: tags.contains(t.$1), onTap: () {
                                  setState(() => tags.contains(t.$1)
                                      ? tags.remove(t.$1)
                                      : tags.add(t.$1));
                                }),
                            ],
                          ),
                          if (low) ...[
                            const SizedBox(height: K.s5),
                            const KwBanner(
                              icon: 'info',
                              child: Text(
                                'نأسف لذلك. هل تريد الإبلاغ عن مشكلة؟ نتابعها مع المحل والمندوب.',
                                style: KT.p,
                              ),
                            ),
                          ],
                          const SizedBox(height: K.s5),
                          KwField(label: 'ملاحظة (اختياري)', controller: note, maxLines: 3),
                        ],
                      ),
                    ),
                  ),
          ),
          if (!sent)
            KwFooter(
              children: [KwButton('أرسل', onPressed: () => setState(() => sent = true))],
            ),
        ],
      ),
    );
  }
}
