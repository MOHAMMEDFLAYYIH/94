import 'package:flutter/material.dart';

import '../main.dart';
import '../state/app_state.dart';
import '../theme/icons.dart';
import '../theme/tokens.dart';
import '../widgets/chrome.dart';
import '../widgets/controls.dart';
import '../widgets/layout.dart';

/// F1.1 · القطع والخدمات.
class ItemsScreen extends StatelessWidget {
  const ItemsScreen({
    super.key,
    required this.onNext,
    required this.onClose,
    this.onAddOther,
  });

  final VoidCallback onNext;
  final VoidCallback onClose;
  final VoidCallback? onAddOther;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return KwScreen(
      child: Column(
        children: [
          KwStepHeader(
            step: 1,
            total: 4,
            title: 'ماذا نستلم؟',
            onClose: onClose,
          ),
          KwBody(
            gap: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const KwSearch(hint: 'ابحث عن قطعة (بدلة، ثوب، نفنوف…)'),
                const KwGroupLabel('الأكثر طلباً'),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: K.s2,
                  crossAxisSpacing: K.s2,
                  childAspectRatio: 0.62,
                  children: [
                    for (final g in kCatalog) _QuickTile(g, app),
                  ],
                ),
                const KwGroupLabel('تصفّح الفئات'),
                Wrap(
                  spacing: K.s2,
                  runSpacing: K.s2,
                  children: [
                    for (final c in kPriceGroups)
                      KwChip(c.name, small: true),
                  ],
                ),
                KwGroupLabel('ملابسك المختارة · ${app.pieceCount} قطعة'),
                if (app.lines.isEmpty)
                  const KwCard(
                    padding: EdgeInsets.all(K.s4),
                    child: Center(
                      child: Text(
                        'لم تضف أي قطعة بعد. اضغط + على القطعة لإضافتها.',
                        textAlign: TextAlign.center,
                        style: KT.p,
                      ),
                    ),
                  ),
                for (final l in List<OrderLine>.from(app.lines)) _LineCard(l, app),
                // family load
                Container(
                  padding: const EdgeInsets.all(K.s4),
                  decoration: BoxDecoration(
                    color: K.surface,
                    borderRadius: BorderRadius.circular(K.rMd),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: K.s2,
                              runSpacing: 4,
                              children: [
                                Text('لا أعرف العدد بالضبط', style: KT.strong),
                                KwBadge('تجريبي', tone: KwBadgeTone.neutral),
                              ],
                            ),
                            SizedBox(height: 2),
                            Text(
                              'حمل عائلي — يُعدّ عند الاستلام ونؤكّده معك.',
                              style: KT.cap,
                            ),
                          ],
                        ),
                      ),
                      KwToggle(
                        value: app.familyLoad,
                        label: 'حمل عائلي',
                        onChanged: (v) {
                          app.familyLoad = v;
                          app.touch();
                        },
                      ),
                    ],
                  ),
                ),
                if (onAddOther != null)
                  KwButton(
                    'أضف قطعة أخرى',
                    icon: 'plus',
                    variant: KwBtnVariant.ghost,
                    md: true,
                    onPressed: onAddOther,
                  ),
              ],
            ),
          ),
          KwFooter(
            sum: KwSum('المبلغ المتوقّع', app.totalLabel, amount: 'د.ع'),
            children: [
              KwButton(
                app.canContinue ? 'التالي' : 'أضف قطعة واحدة على الأقل',
                onPressed: app.canContinue ? onNext : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile(this.g, this.app);

  final Garment g;
  final AppState app;

  @override
  Widget build(BuildContext context) {
    final line = app.lineOf(g.id);
    final on = line != null;
    return Semantics(
      button: true,
      selected: on,
      label: '${g.name}، ${fmtK(g.price)} دينار',
      child: GestureDetector(
        onTap: () => app.changeQty(g.id, on ? -1 : 1),
        child: Container(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
          decoration: BoxDecoration(
            color: on ? K.tintGreen : K.surface,
            borderRadius: BorderRadius.circular(K.rMd),
            border: Border.all(color: on ? K.action : K.hairline, width: on ? 2 : 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              KwIcon(_iconFor(g.id), size: 30, color: K.brandSoft),
              const SizedBox(height: K.s1),
              Text(
                g.name,
                style: const TextStyle(
                    fontFamily: 'Tajarib', fontSize: 14, height: 22 / 14, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text('${fmtK(g.price)} د.ع', style: KT.cap),
              const Spacer(),
              KwStepper(
                small: true,
                value: line?.qty ?? 0,
                decLabel: 'أنقص ${g.name}',
                incLabel: 'أضف ${g.name}',
                onDec: () => app.changeQty(g.id, -1),
                onInc: () => app.changeQty(g.id, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LineCard extends StatelessWidget {
  const _LineCard(this.line, this.app);

  final OrderLine line;
  final AppState app;

  @override
  Widget build(BuildContext context) {
    final g = line.garment;
    return KwCard(
      padding: const EdgeInsets.all(K.s4),
      gap: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              KwLead(_iconFor(g.id), size: 44, color: K.brandSoft),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(g.name, style: KT.strong),
                    Text('${fmtK(line.lineTotal)} د.ع', style: KT.cap),
                  ],
                ),
              ),
              KwStepper(
                value: line.qty,
                onDec: () => app.changeQty(g.id, -1),
                onInc: () => app.changeQty(g.id, 1),
              ),
            ],
          ),
          Wrap(
            spacing: K.s2,
            runSpacing: K.s2,
            children: [
              for (final s in Service.values)
                KwChip(
                  s.label,
                  small: true,
                  selected: line.service == s,
                  onTap: () => app.patchLine(g.id, service: s),
                ),
            ],
          ),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'قطعة غالية',
                      style: TextStyle(
                          fontFamily: 'Tajarib', fontSize: 14, height: 22 / 14, fontWeight: FontWeight.w500),
                    ),
                    Text('سنصوّرها عند الاستلام.', style: KT.cap),
                  ],
                ),
              ),
              KwToggle(
                value: line.valuable,
                label: 'قطعة غالية',
                onChanged: (v) => app.patchLine(g.id, valuable: v),
              ),
              KwTextButton(
                'حذف',
                dense: true,
                color: K.danger,
                onTap: () => app.removeLine(g.id),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _iconFor(String id) => switch (id) {
      'shirt' || 'tshirt' => 'shirt',
      'pants' => 'hanger',
      'dish' => 'sparkle',
      'suit' => 'iron',
      'abaya' => 'hanger',
      _ => 'shirt',
    };

/// M10 · إضافة قطعة أخرى.
class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key, required this.onAdd, required this.onClose});

  final void Function(String name, Service service, int qty) onAdd;
  final VoidCallback onClose;

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final name = TextEditingController();
  Service service = Service.iron;
  int qty = 1;

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final guess = kCatalog
        .where((g) => name.text.isNotEmpty && g.name.contains(name.text.trim()))
        .toList();

    return KwScreen(
      child: Column(
        children: [
          KwStepHeader(
            step: 1,
            total: 4,
            title: 'أضف قطعة أخرى',
            onClose: widget.onClose,
          ),
          KwBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KwField(
                  label: 'اسم القطعة',
                  controller: name,
                  hint: 'بدلة، ثوب، جاكيت…',
                  onChanged: (_) => setState(() {}),
                ),
                if (guess.isNotEmpty) ...[
                  const SizedBox(height: K.s2),
                  Wrap(
                    spacing: K.s2,
                    children: [
                      for (final g in guess)
                        KwChip(g.name,
                            small: true,
                            onTap: () => setState(() => name.text = g.name)),
                    ],
                  ),
                ],
                const SizedBox(height: K.s5),
                const Text('الخدمة', style: KT.cap),
                const SizedBox(height: K.s2),
                Wrap(
                  spacing: K.s2,
                  runSpacing: K.s2,
                  children: [
                    for (final s in Service.values)
                      KwChip(s.label, selected: service == s, onTap: () => setState(() => service = s)),
                  ],
                ),
                const SizedBox(height: K.s5),
                const Text('العدد', style: KT.cap),
                const SizedBox(height: K.s2),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: KwStepper(
                    value: qty,
                    onDec: () => setState(() => qty = qty > 1 ? qty - 1 : 1),
                    onInc: () => setState(() => qty++),
                  ),
                ),
                const SizedBox(height: K.s5),
                const Text(
                  'نؤكّد سعرها معك قبل الاستلام.',
                  style: KT.cap,
                ),
              ],
            ),
          ),
          KwFooter(
            children: [
              KwButton(
                'أضف',
                onPressed: name.text.trim().isEmpty
                    ? null
                    : () => widget.onAdd(name.text.trim(), service, qty),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// F1.2 · العنوان.
class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key, required this.onNext, required this.onBack, required this.onClose});

  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onClose;

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late final TextEditingController note;

  @override
  void initState() {
    super.initState();
    note = TextEditingController(text: AppScope.read(context).courierNote);
    note.addListener(() {
      AppScope.read(context).courierNote = note.text;
      AppScope.read(context).touch();
    });
  }

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final addr = app.address;

    return KwScreen(
      child: Column(
        children: [
          KwStepHeader(
              step: 2, total: 4, title: 'من أين نستلم؟', onBack: widget.onBack, onClose: widget.onClose),
          KwBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const KwGroupLabel('عناويني'),
                for (final a in kAddresses) ...[
                  KwSelect(
                    selected: a.id == app.addressId,
                    column: true,
                    onTap: () => app.selectAddress(a.id),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(a.name,
                                  style: KT.strong.copyWith(fontWeight: FontWeight.w700)),
                              Text(a.area, style: KT.p),
                              Text(a.note, style: KT.cap),
                            ],
                          ),
                        ),
                        const KwIcon('pin', size: 20, color: K.brand),
                      ],
                    ),
                  ),
                  const SizedBox(height: K.s2),
                ],
                if (!addr.inRange)
                  const KwBanner(
                    icon: 'info',
                    tone: KwBannerTone.alert,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'هذا العنوان خارج منطقة الخدمة الآن.',
                          style: TextStyle(
                              fontFamily: 'Tajarib', fontSize: 15, height: 24 / 15, fontWeight: FontWeight.w500, color: K.danger),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'اختر عنواناً آخر، أو اترك رقمك ونبلغك عند وصولنا.',
                          style: KT.cap,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: K.s2),
                const KwButton('عنوان جديد', icon: 'plus', variant: KwBtnVariant.ghost, md: true),
                const SizedBox(height: K.s3),
                const KwGroupLabel('تعليمات الباب لهذا الطلب'),
                KwCard(
                  gap: K.s4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('من يسلّم الكيس؟', style: KT.strong),
                          const SizedBox(height: K.s2),
                          Wrap(
                            spacing: K.s2,
                            runSpacing: K.s2,
                            children: [
                              for (final w in const [
                                ('me', 'أنا'),
                                ('family', 'فرد من العائلة'),
                                ('guard', 'حارس العمارة'),
                              ])
                                KwChip(
                                  w.$2,
                                  selected: app.whoDelivers == w.$1,
                                  onTap: () {
                                    app.whoDelivers = w.$1;
                                    app.touch();
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('اتصل قبل الوصول', style: KT.strong),
                                Text('يتصل المندوب برقم محجوب.', style: KT.cap),
                              ],
                            ),
                          ),
                          KwToggle(
                            value: app.callBefore,
                            label: 'اتصل قبل الوصول',
                            onChanged: (v) {
                              app.callBefore = v;
                              app.touch();
                            },
                          ),
                        ],
                      ),
                      KwField(
                        label: 'ملاحظة للمندوب',
                        controller: note,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          KwFooter(
            sum: KwSum('المبلغ المتوقّع', app.totalLabel, amount: 'د.ع'),
            children: [
              KwButton('التالي', onPressed: addr.inRange ? widget.onNext : null),
            ],
          ),
        ],
      ),
    );
  }
}

/// F1.3 · الموعد.
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key, required this.onNext, required this.onBack, required this.onClose});

  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return KwScreen(
      child: Column(
        children: [
          KwStepHeader(step: 3, total: 4, title: 'متى نأتيك؟', onBack: onBack, onClose: onClose),
          KwBody(
            gap: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const KwGroupLabel('يوم الاستلام'),
                Row(
                  children: [
                    for (var i = 0; i < kDays.length; i++) ...[
                      Expanded(
                        child: KwSelect(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          radio: false,
                          enabled: !kDays[i].off,
                          selected: app.dayIndex == i,
                          onTap: () => app.selectDay(i),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(kDays[i].short, style: KT.label),
                              Text('${kDays[i].n}',
                                  style: KT.num.copyWith(fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                      if (i != kDays.length - 1) const SizedBox(width: 6),
                    ],
                  ],
                ),
                const KwGroupLabel('وقت الاستلام'),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: K.s2,
                  crossAxisSpacing: K.s2,
                  childAspectRatio: 2.1,
                  children: [
                    for (var i = 0; i < kSlots.length; i++)
                      KwSelect(
                        padding: const EdgeInsets.symmetric(horizontal: K.s3, vertical: 8),
                        radio: false,
                        enabled: !kSlots[i].full,
                        selected: app.slotIndex == i,
                        onTap: () => app.selectSlot(i),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(kSlots[i].t,
                                style: KT.strong.copyWith(fontWeight: FontWeight.w700)),
                            Text(kSlots[i].sub, style: KT.cap),
                          ],
                        ),
                      ),
                  ],
                ),
                KwBanner(
                  icon: 'truck',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('موعد الإرجاع المتوقّع', style: KT.cap),
                      Text('ترجع ملابسك ${app.returnWhen}',
                          style: KT.strong.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                KwCard(
                  gap: K.s2,
                  padding: const EdgeInsets.all(K.s4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                              child: Text('كرّر كل أسبوع',
                                  style: TextStyle(
                                      fontFamily: 'Tajarib',
                                      fontSize: 15,
                                      height: 24 / 15,
                                      fontWeight: FontWeight.w700))),
                          KwToggle(
                            value: app.repeatWeekly,
                            label: 'كرّر كل أسبوع',
                            onChanged: (v) {
                              app.repeatWeekly = v;
                              app.touch();
                            },
                          ),
                        ],
                      ),
                      Text(
                        'نأتيك كل ${app.day.full} ${app.slot.t}. تقدر تتخطّى أي أسبوع.',
                        style: KT.cap,
                      ),
                    ],
                  ),
                ),
                KwCard(
                  gap: K.s2,
                  padding: const EdgeInsets.all(K.s4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Row(
                        children: [
                          Expanded(
                              child: Text('أحتاجها قبل',
                                  style: TextStyle(
                                      fontFamily: 'Tajarib',
                                      fontSize: 15,
                                      height: 24 / 15,
                                      fontWeight: FontWeight.w700))),
                          KwBadge('اختياري', tone: KwBadgeTone.neutral),
                        ],
                      ),
                      const Text(
                        'إن كنت تحتاج قطعة لمناسبة، اختر التاريخ ونخبرك بأقرب موعد ممكن.',
                        style: KT.cap,
                      ),
                      KwChip('اختر تاريخاً', icon: 'clock', small: true, onTap: () {
                        app.needBy = 'السبت 10 أكتوبر';
                        app.touch();
                        showKwToast(context, 'سنخبرك بأقرب موعد ممكن');
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          KwFooter(
            sum: KwSum('المبلغ المتوقّع', app.totalLabel, amount: 'د.ع'),
            children: [KwButton('التالي', onPressed: onNext)],
          ),
        ],
      ),
    );
  }
}

/// F1.4 · المراجعة والتأكيد.
class ReviewScreen extends StatelessWidget {
  const ReviewScreen({
    super.key,
    required this.onConfirm,
    required this.onEditItems,
    required this.onEditAddress,
    required this.onEditSchedule,
  });

  final VoidCallback onConfirm;
  final VoidCallback onEditItems;
  final VoidCallback onEditAddress;
  final VoidCallback onEditSchedule;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return KwScreen(
      child: Column(
        children: [
          KwStepHeader(
            step: 4,
            total: 4,
            title: 'راجع طلبك',
            onBack: onEditSchedule,
            onClose: () => Navigator.of(context).maybePop(),
          ),
          KwBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // items
                KwCard(
                  gap: K.s2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'القطع · ${app.pieceCount} قطعة',
                              style: KT.t3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          KwTextButton('تعديل', dense: true, onTap: onEditItems),
                        ],
                      ),
                      for (final l in app.lines)
                        KwAmount(
                          '${l.garment.name} × ${l.qty} · ${l.service.short}',
                          fmtK(l.lineTotal),
                          badge: l.valuable ? const KwBadge('غالية', tone: KwBadgeTone.mint) : null,
                        ),
                    ],
                  ),
                ),
                // address
                KwCard(
                  gap: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'العنوان والباب',
                              style: KT.t3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          KwTextButton('تعديل', dense: true, onTap: onEditAddress),
                        ],
                      ),
                      Text(
                        '${app.address.name} · ${app.address.area}',
                        style: KT.strong,
                      ),
                      Text(
                        'يسلّم الكيس: ${_whoLabel(app.whoDelivers)}'
                        '${app.callBefore ? ' · اتصل قبل الوصول' : ''}'
                        '${app.courierNote.isNotEmpty ? ' · «${app.courierNote}»' : ''}',
                        style: KT.cap,
                      ),
                    ],
                  ),
                ),
                // schedule
                KwCard(
                  gap: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'الموعد',
                              style: KT.t3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          KwTextButton('تعديل', dense: true, onTap: onEditSchedule),
                        ],
                      ),
                      KwAmount('الاستلام', '${app.day.full} 8 أكتوبر · ${app.slot.t}'),
                      KwAmount('الإرجاع المتوقّع', '${app.day.ret} 10 أكتوبر · ${app.slot.t}'),
                    ],
                  ),
                ),
                // amount
                KwCard(
                  gap: K.s2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('المبلغ', style: KT.t3),
                      KwAmount('ثمن القطع', fmtK(app.baseTotal), strong: true),
                      const Divider(height: K.s3, color: K.hairline),
                      KwAmount('المبلغ المتوقّع', fmtK(app.total), strong: true),
                      const Text(
                        'لا يتغيّر المبلغ دون موافقتك. يُثبَّت بعد عدّ القطع عند الاستلام.',
                        style: KT.cap,
                      ),
                    ],
                  ),
                ),
                // how we pick up
                const KwCard(
                  gap: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('كيف نستلم', style: KT.t3),
                      _Bullet('نعدّ القطع أمامك عند الباب وتؤكّد العدد في التطبيق.', 'check'),
                      _Bullet('يصلك اسم المندوب وصورته قبل وصوله.', 'profile'),
                    ],
                  ),
                ),
                // payment
                Container(
                  padding: const EdgeInsets.all(K.s4),
                  decoration: BoxDecoration(
                    color: K.surface,
                    borderRadius: BorderRadius.circular(K.rMd),
                  ),
                  child: const Row(
                    children: [
                      KwLead('cash', size: 44, bg: K.tintGreen, color: K.brandText),
                      SizedBox(width: K.s3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('الدفع', style: KT.cap),
                            Text('نقداً عند التسليم',
                                style: TextStyle(
                                    fontFamily: 'Tajarib',
                                    fontSize: 15,
                                    height: 24 / 15,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Wrap(
                  spacing: K.s2,
                  children: [
                    KwTextButton('ضمان كويلي', dense: true),
                    KwTextButton('الإلغاء', dense: true),
                    KwTextButton('القطع غير المقبولة', dense: true),
                  ],
                ),
              ],
            ),
          ),
          KwFooter(
            sum: KwSum('المبلغ المتوقّع · نقداً', app.totalLabel, amount: 'د.ع'),
            children: [
              KwButton('أكّد الطلب', onPressed: onConfirm),
              if (!app.registered)
                const Text(
                  'نطلب رقم هاتفك في الخطوة التالية. طلبك محفوظ.',
                  textAlign: TextAlign.center,
                  style: KT.cap,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text, this.icon);

  final String text;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KwIcon(icon, size: 20, color: K.brand),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: KT.p)),
      ],
    );
  }
}

String _whoLabel(String id) => switch (id) {
      'me' => 'أنا',
      'family' => 'فرد من العائلة',
      'guard' => 'حارس العمارة',
      _ => 'أنا',
    };

/// F1.4 · فشل الإرسال / امتلأ الموعد.
class OrderFailureScreen extends StatelessWidget {
  const OrderFailureScreen({super.key, required this.mode, this.onRetry, this.onReschedule});

  final String mode;
  final VoidCallback? onRetry;
  final VoidCallback? onReschedule;

  @override
  Widget build(BuildContext context) {
    final sendFailed = mode == 'send';
    return KwScreen(
      child: Column(
        children: [
          KwStepHeader(
            step: 4,
            total: 4,
            title: 'راجع طلبك',
            onClose: () => Navigator.of(context).maybePop(),
          ),
          KwBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(sendFailed ? 'لم يصلنا طلبك' : 'امتلأ موعد الخميس 6–8 م',
                    style: KT.t2),
                const SizedBox(height: K.s2),
                Text(
                  sendFailed
                      ? 'انقطع الاتصال أثناء الإرسال. طلبك محفوظ كما هو، أعد المحاولة.'
                      : 'حُجز آخر مكان أثناء مراجعتك. اختر موعداً آخر، وتبقى قطعك وعنوانك كما هي.',
                  style: KT.p,
                ),
              ],
            ),
          ),
          KwFooter(
            children: [
              KwButton(sendFailed ? 'أعد المحاولة' : 'اختر موعداً آخر',
                  onPressed: sendFailed ? onRetry : onReschedule),
              KwButton(
                'تواصل مع كويلي',
                variant: KwBtnVariant.ghost,
                md: true,
                onPressed: () => showKwToast(context, 'فتح واتساب كويلي', icon: 'info'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
