import 'dart:async';
import 'package:flutter/material.dart';

import '../main.dart';
import '../state/app_state.dart';
import '../theme/icons.dart';
import '../theme/tokens.dart';
import '../widgets/chrome.dart';
import '../widgets/controls.dart';
import '../widgets/layout.dart';

/// S00 · شاشة البداية.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _c.forward();
    _timer = Timer(const Duration(milliseconds: 2000), () {
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: K.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: K.screenWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                FadeTransition(
                  opacity: _c,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                      CurvedAnimation(parent: _c, curve: Curves.easeOut),
                    ),
                    child: const KwWordmark(height: 52),
                  ),
                ),
                const SizedBox(height: K.s5),
                FadeTransition(
                  opacity: _c,
                  child: const Text(
                    'نستلم ملابسك من بابك ونرجعها مكوية',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Tajarib',
                      fontSize: 15,
                      height: 24 / 15,
                      fontWeight: FontWeight.w400,
                      color: K.ink,
                    ),
                  ),
                ),
                const Spacer(flex: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// S01 · هل نخدم حيّك؟
class AreaScreen extends StatefulWidget {
  const AreaScreen({super.key, required this.onNext, required this.onWaitlist});

  final VoidCallback onNext;
  final VoidCallback onWaitlist;

  @override
  State<AreaScreen> createState() => _AreaScreenState();
}

class _AreaScreenState extends State<AreaScreen> {
  final _search = TextEditingController();
  String _q = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final picked = kAreas.firstWhere((a) => a.id == app.areaId, orElse: () => kAreas.first);
    final filtered = kAreas.where((a) => _q.isEmpty || a.name.contains(_q)).toList();

    return KwScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // header row: logo right, empty left
          const Padding(
            padding: EdgeInsets.fromLTRB(K.s6, K.s10, K.s6, K.s2),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: KwWordmark(height: 28),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: K.s6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('نبدأ بحيّ واحد في بغداد', style: KT.t1),
                SizedBox(height: K.s2),
                Text('اختر حيّك لنعرف إن كنا نصلك.', style: KT.p),
              ],
            ),
          ),
          const SizedBox(height: K.s4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: K.s6),
            child: Column(
              children: [
                // "حدّد موقعي" button
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: K.surface,
                    borderRadius: BorderRadius.circular(K.rMd),
                    border: Border.all(color: K.action, width: 1.5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      KwIcon('pin', size: 18, color: K.brandText),
                      SizedBox(width: K.s2),
                      Text('حدّد موقعي',
                          style: TextStyle(
                            fontFamily: 'Tajarib',
                            fontSize: 15,
                            height: 24 / 15,
                            fontWeight: FontWeight.w700,
                            color: K.brandText,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: K.s3),
                // search
                KwSearch(
                  hint: 'ابحث عن حيّك',
                  controller: _search,
                  onChanged: (v) => setState(() => _q = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: K.s3),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: K.s6),
              child: Column(
                children: [
                  for (final a in filtered) ...[
                    KwSelect(
                      selected: a.id == app.areaId,
                      onTap: () {
                        app.areaId = a.id;
                        app.touch();
                      },
                      child: Row(
                        children: [
                          Expanded(child: Text(a.name, style: KT.strong)),
                          if (a.served)
                            const KwBadge('نخدمه الآن', tone: KwBadgeTone.green)
                          else
                            const KwIcon('clock', size: 18, color: K.inkSubtle),
                        ],
                      ),
                    ),
                    const SizedBox(height: K.s2),
                  ],
                ],
              ),
            ),
          ),
          KwFooter(
            children: [
              KwButton(
                'متابعة',
                onPressed: () => picked.served ? widget.onNext() : widget.onWaitlist(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// S01b · لم نصل حيّك بعد.
class WaitlistScreen extends StatefulWidget {
  const WaitlistScreen({super.key, required this.onPrices, required this.onRegistered});

  final VoidCallback onPrices;
  final VoidCallback onRegistered;

  @override
  State<WaitlistScreen> createState() => _WaitlistScreenState();
}

class _WaitlistScreenState extends State<WaitlistScreen> {
  final phone = TextEditingController();
  bool sent = false;

  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KwScreen(
      child: Column(
        children: [
          KwTopBar(
            title: '',
            showBack: true,
            onBack: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(K.s6, K.s5, K.s6, K.s8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: K.s6),
                    Center(
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: K.tintGreen,
                          borderRadius: BorderRadius.circular(K.rLg),
                        ),
                        alignment: Alignment.center,
                        child: const KwIcon('truck', size: 52, color: K.brand),
                      ),
                    ),
                    const SizedBox(height: K.s6),
                    const Center(child: Text('لم نصل حيّك بعد', style: KT.t1)),
                    const SizedBox(height: K.s2),
                    const Center(
                      child: Text(
                        'اترك رقمك ونبلغك عند وصولنا إلى الكرادة.',
                        style: KT.p,
                      ),
                    ),
                    const SizedBox(height: K.s8),
                    KwField(
                      label: 'رقم الهاتف',
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      hint: '07XXXXXXXXX',
                    ),
                    const SizedBox(height: K.s4),
                    if (sent)
                      const KwBanner(
                        icon: 'check',
                        tone: KwBannerTone.mint,
                        child: Text('سجّلنا رقمك. نبلغك عند وصولنا.', style: KT.strong),
                      ),
                  ],
                ),
              ),
            ),
          ),
          KwFooter(
            children: [
              KwButton(
                sent ? 'تم التسجيل' : 'أبلغوني',
                onPressed: sent
                    ? null
                    : () {
                        setState(() => sent = true);
                        Future.delayed(const Duration(milliseconds: 900), widget.onRegistered);
                      },
              ),
              const SizedBox(height: K.s2),
              GestureDetector(
                onTap: widget.onPrices,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: K.s2),
                  child: Center(
                    child: Text(
                      'تصفّح الأسعار',
                      style: TextStyle(
                        fontFamily: 'Tajarib',
                        fontSize: 15,
                        height: 24 / 15,
                        fontWeight: FontWeight.w700,
                        color: K.brandText,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// S02 · رقم الهاتف.
class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key, required this.onNext, this.fromReview = false});

  final VoidCallback onNext;
  final bool fromReview;

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final phone = TextEditingController(text: '0770 123 4567');
  bool tried = false;

  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  bool get _valid => RegExp(r'^07\d{9}$').hasMatch(normalizeDigits(phone.text));

  @override
  Widget build(BuildContext context) {
    return KwScreen(
      child: Column(
        children: [
          KwTopBar(
            title: '',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(K.s6, K.s5, K.s6, K.s8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('أدخل رقمك لنكمل طلبك', style: KT.t1),
                    const SizedBox(height: K.s3),
                    const KwBanner(
                      icon: 'check',
                      tone: KwBannerTone.mint,
                      child: Text('طلبك محفوظ، لن تفقد شيئاً.', style: KT.p),
                    ),
                    const SizedBox(height: K.s6),
                    KwField(
                      label: 'رقم الهاتف',
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      hint: '07XXXXXXXXX',
                      error: tried && !_valid
                          ? 'الرقم غير صحيح. يبدأ بـ 07 ويتكوّن من 11 رقماً.'
                          : null,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: K.s2),
                    const Text('نقبل الأرقام العربية والإنجليزية.', style: KT.cap),
                  ],
                ),
              ),
            ),
          ),
          KwFooter(
            children: [
              KwButton(
                'أرسل الرمز',
                onPressed: () {
                  if (!_valid && normalizeDigits(phone.text).length < 10) {
                    setState(() => tried = true);
                    return;
                  }
                  AppScope.read(context).phone = phone.text;
                  widget.onNext();
                },
              ),
              const SizedBox(height: K.s2),
              const Text(
                'بالمتابعة توافق على الشروط وسياسة الخصوصية.',
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

/// S03 · رمز التحقق.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _digits = List.generate(
    6,
    (i) => TextEditingController(text: ['7', '2', '9', '1', '8', '4'][i]),
  );
  final name = TextEditingController(text: 'حيدر');
  bool wrong = false;
  bool sent = false;
  int countdown = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (countdown > 0) {
        setState(() => countdown--);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _digits) {
      c.dispose();
    }
    name.dispose();
    super.dispose();
  }

  String get _code => _digits.map((c) => c.text).join();
  bool get _ok => _code.length == 6 && !wrong;

  @override
  Widget build(BuildContext context) {
    return KwScreen(
      child: Column(
        children: [
          KwTopBar(title: '', onBack: () => Navigator.of(context).maybePop()),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(K.s6, K.s5, K.s6, K.s8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('أدخل رمز التحقق', style: KT.t1),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'أرسلنا رمزاً إلى ${AppScope.of(context).phone.isEmpty ? "0770 123 4567" : AppScope.of(context).phone} · ',
                          style: KT.p,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).maybePop(),
                          child: const Text(
                            'تغيير الرقم',
                            style: TextStyle(
                              fontFamily: 'Tajarib',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: K.brandText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: K.s6),
                    // 6 individual OTP digit boxes
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        children: [
                          for (int i = 0; i < 6; i++) ...[
                            if (i > 0) const SizedBox(width: 6),
                            Expanded(
                              child: Container(
                                height: 56,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: K.surface,
                                  borderRadius: BorderRadius.circular(K.rMd),
                                  border: Border.all(
                                    color: wrong ? K.danger : K.hairline,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  _digits[i].text,
                                  style: const TextStyle(
                                    fontFamily: 'Tajarib',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: K.ink,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (wrong) ...[
                      const SizedBox(height: K.s2),
                      const Text(
                        'الرمز غير صحيح. تحقّق منه وأعد المحاولة.',
                        style: TextStyle(
                          fontFamily: 'Tajarib',
                          fontSize: 13,
                          color: K.danger,
                        ),
                      ),
                    ],
                    const SizedBox(height: K.s4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              countdown > 0
                                  ? 'أعد الإرسال بعد 0:${countdown.toString().padLeft(2, '0')}'
                                  : '',
                              style: KT.cap,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        KwTextButton(
                          'أعد الإرسال',
                          dense: true,
                          color: countdown > 0 ? K.inkMuted : K.brandText,
                          onTap: countdown > 0
                              ? null
                              : () {
                                  setState(() {
                                    sent = true;
                                    countdown = 45;
                                  });
                                  showKwToast(context, 'أعدنا إرسال الرمز');
                                },
                        ),
                      ],
                    ),
                    const SizedBox(height: K.s4),
                    // Send via WhatsApp outline button
                    GestureDetector(
                      onTap: () => showKwToast(context, 'أرسلنا الرمز عبر واتساب'),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: K.surface,
                          borderRadius: K.rPill,
                          border: Border.all(color: K.action, width: 1.5),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            KwIcon('whatsapp', size: 20, color: K.brandText),
                            SizedBox(width: K.s2),
                            Text(
                              'أرسله عبر واتساب',
                              style: TextStyle(
                                fontFamily: 'Tajarib',
                                fontSize: 15,
                                height: 24 / 15,
                                fontWeight: FontWeight.w700,
                                color: K.brandText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: K.s6),
                    const Divider(color: K.hairline, height: 1),
                    const SizedBox(height: K.s6),
                    KwField(
                      label: 'اسمك الأول',
                      controller: name,
                      hint: 'حيدر',
                    ),
                    const SizedBox(height: K.s2),
                    const Text('نناديك به في التطبيق. نطلبه مرة واحدة فقط.', style: KT.cap),
                  ],
                ),
              ),
            ),
          ),
          KwFooter(
            children: [
              KwButton(
                'تحقّق وأكمل الطلب',
                onPressed: () {
                  if (!_ok) {
                    setState(() => wrong = true);
                    return;
                  }
                  if (name.text.trim().isNotEmpty) {
                    AppScope.read(context).firstName = name.text.trim();
                  }
                  widget.onNext();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
