import 'package:flutter/material.dart';

import '../main.dart';
import '../theme/icons.dart';
import '../theme/tokens.dart';
import '../widgets/chrome.dart';
import '../widgets/controls.dart';
import '../widgets/layout.dart';

/// Service tile — `.kw-service`.
class KwServiceCard extends StatelessWidget {
  const KwServiceCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.large = true,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final String icon;
  final bool large;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(minHeight: large ? 148 : 112),
          padding: EdgeInsets.all(large ? K.s5 : K.s4),
          decoration: BoxDecoration(
            color: K.surface,
            borderRadius: BorderRadius.circular(K.rMd),
            border: Border.all(color: K.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Tajarib',
                  fontSize: large ? 17 : 14,
                  height: (large ? 26 : 22) / (large ? 17 : 14),
                  fontWeight: FontWeight.w700,
                  color: K.ink,
                ),
              ),
              if (large && subtitle != null) Text(subtitle!, style: KT.cap),
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: KwIcon(icon, size: large ? 56 : 40, color: K.brandSoft),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// C1 · الرئيسية.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onOrder,
    required this.onPrices,
    required this.onProtect,
    required this.onOrders,
    required this.onAccount,
    required this.onRecurring,
    required this.onConfirmCount,
    required this.onOrderDetail,
  });

  final VoidCallback onOrder;
  final VoidCallback onPrices;
  final VoidCallback onProtect;
  final VoidCallback onOrders;
  final VoidCallback onAccount;
  final VoidCallback onRecurring;
  final VoidCallback onConfirmCount;
  final VoidCallback onOrderDetail;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final hasOrder = app.registered;

    return KwScreen(
      child: Column(
        children: [
          // ─── header ───────────────────────────────────────
          Container(
            color: K.surface,
            padding: const EdgeInsets.fromLTRB(K.s6, K.s10, K.s6, K.s4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // location tag — left
                GestureDetector(
                  onTap: onOrders,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const KwIcon('pin', size: 16, color: K.brand),
                      const SizedBox(width: 4),
                      Text(
                        app.areaId == 'mansour'
                            ? 'المنصور، بغداد'
                            : 'الكرادة، بغداد',
                        style: const TextStyle(
                          fontFamily: 'Tajarib',
                          fontSize: 13,
                          height: 20 / 13,
                          fontWeight: FontWeight.w500,
                          color: K.ink,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const KwIcon('chevron-left', size: 14, color: K.inkSubtle),
                    ],
                  ),
                ),
                // wordmark — right
                const KwWordmark(height: 28),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // greeting + title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(K.s6, K.s5, K.s6, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasOrder)
                          Text(
                            'مساء الخير، ${app.firstName}',
                            style: KT.cap,
                          ),
                        if (hasOrder) const SizedBox(height: K.s1),
                        const Text(
                          'ماذا نستلم منك؟',
                          style: TextStyle(
                            fontFamily: 'Tajarib',
                            fontSize: 30,
                            height: 42 / 30,
                            fontWeight: FontWeight.w800,
                            color: K.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'نستلم ملابسك من بابك ونرجعها مكوية',
                          style: KT.cap,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: K.s5),
                  // service grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: K.s6),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: KwServiceCard(
                                title: 'كوي',
                                subtitle: 'للقطع النظيفة',
                                icon: 'iron',
                                onTap: onOrder,
                              ),
                            ),
                            const SizedBox(width: K.s3),
                            Expanded(
                              child: KwServiceCard(
                                title: 'غسيل وكوي',
                                subtitle: 'نغسل ثم نكوي',
                                icon: 'washer',
                                onTap: onOrder,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: K.s3),
                        Row(
                          children: [
                            Expanded(
                              child: KwServiceCard(
                                title: 'تنظيف جاف',
                                icon: 'jacket',
                                large: false,
                                onTap: onOrder,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: KwServiceCard(
                                title: 'الأسعار',
                                icon: 'shirt',
                                large: false,
                                onTap: onPrices,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: KwServiceCard(
                                title: 'كيف نحمي ملابسك',
                                icon: 'truck',
                                large: false,
                                onTap: onProtect,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: K.s6),
                ],
              ),
            ),
          ),

          // pinned order sheet — content scrolls when it outgrows the screen
          Flexible(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(K.s6, K.s8, K.s6, K.s3),
                  decoration: const BoxDecoration(
                    color: K.surface,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(K.rLg)),
                    boxShadow: K.shadowSheet,
                  ),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasOrder) ...[
                          const SizedBox(height: K.s3),
                          const Text('طلبك الجاري', style: KT.t2),
                      const SizedBox(height: K.s3),
                      GestureDetector(
                        onTap: onOrderDetail,
                        child: Container(
                          padding: const EdgeInsets.all(K.s4),
                          decoration: BoxDecoration(
                            color: K.surface,
                            borderRadius: BorderRadius.circular(K.rMd),
                            border: Border.all(color: K.action, width: 2),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Ltr('Q-0142',
                                      style: TextStyle(
                                          fontFamily: 'Tajarib',
                                          fontSize: 16,
                                          height: 22 / 16,
                                          fontWeight: FontWeight.w700,
                                          color: K.ink)),
                                  KwBadge('يحتاج ردّك',
                                      tone: KwBadgeTone.danger),
                                ],
                              ),
                              SizedBox(height: K.s3),
                              KwMiniTracker(done: 1),
                              SizedBox(height: K.s3),
                              Text('أكّد العدد: 12 قطعة', style: KT.t3),
                              SizedBox(height: 2),
                              Text(
                                'عدّ المندوب علي ملابسك عند الباب. لن يأخذ الكيس حتى تؤكّد.',
                                style: KT.cap,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: K.s3),
                      KwButton(
                        'راجع العدد وأكّده',
                        variant: KwBtnVariant.secondary,
                        md: true,
                        onPressed: onConfirmCount,
                      ),
                      const SizedBox(height: K.s5),
                      const KwGroupLabel('بعد ذلك'),
                      const SizedBox(height: K.s1),
                      _AfterRow(
                        icon: 'clock',
                        bg: K.tintMint,
                        title: 'موعدك الثابت القادم',
                        subtitle: 'الخميس القادم · 6–8 مساءً',
                        action: 'إدارة',
                        onTap: onRecurring,
                      ),
                      _AfterRow(
                        icon: 'bag',
                        title: 'أعد آخر طلب',
                        subtitle: '10 قطع · كوي · ${fmtK(10000)} د.ع',
                        action: 'أعد الطلب',
                        onTap: onOrder,
                        taller: true,
                      ),
                      const SizedBox(height: K.s3),
                      const Text(
                        'أسعار الكوي. السعر الذي تراه هو ما تدفعه.',
                        textAlign: TextAlign.center,
                        style: KT.cap,
                      ),
                      const SizedBox(height: K.s3),
                    ] else ...[
                      const SizedBox(height: K.s2),
                      const Text(
                        'جهة واحدة مسؤولة من بابك إلى بابك',
                        textAlign: TextAlign.center,
                        style: KT.strong,
                      ),
                      const SizedBox(height: K.s2),
                      const Text(
                        'اختر الخدمة ثم القطع، ونحدّد معك موعد الاستلام.',
                        textAlign: TextAlign.center,
                        style: KT.cap,
                      ),
                      const SizedBox(height: K.s4),
                      const Text(
                        'أسعار الكوي. السعر الذي تراه هو ما تدفعه.',
                        textAlign: TextAlign.center,
                        style: KT.cap,
                      ),
                      const SizedBox(height: K.s4),
                    ],
                    KwButton(
                      'اطلب استلاماً',
                      icon: 'plus',
                      onPressed: onOrder,
                    ),
                    const SizedBox(height: K.s3),
                    const Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        KwTextButton('واتساب كويلي', dense: true),
                        KwTextButton('اتصل بنا', dense: true),
                      ],
                    ),
                    const SizedBox(height: K.s2),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -18,
              right: K.s6,
              child: KwBubble(
                hasOrder ? 'لديك طلب جارٍ' : 'الدفع نقداً عند التسليم',
                icon: hasOrder ? 'basket' : 'truck',
              ),
            ),
          ],
        ),
      ),

          KwTabBar(
            index: 0,
            badge: true,
            onTap: (i) => [onOrders, onAccount][i - 1](),
          ),
        ],
      ),
    );
  }
}

class _AfterRow extends StatelessWidget {
  const _AfterRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.action,
    required this.onTap,
    this.bg,
    this.taller = false,
  });

  final String icon;
  final String title;
  final String subtitle;
  final String action;
  final VoidCallback onTap;
  final Color? bg;
  final bool taller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: BoxConstraints(minHeight: taller ? 72 : 64),
        padding: const EdgeInsets.symmetric(vertical: K.s3),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: K.hairline)),
        ),
        child: Row(
          children: [
            KwLead(icon,
                size: taller ? 56 : 44,
                bg: bg,
                color: bg != null ? K.brandText : K.brand),
            const SizedBox(width: K.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: KT.cap),
                  Text(subtitle, style: KT.strong),
                ],
              ),
            ),
            KwButton(action,
                variant: KwBtnVariant.secondary,
                md: true,
                block: false,
                onPressed: onTap),
          ],
        ),
      ),
    );
  }
}
