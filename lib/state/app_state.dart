import 'package:flutter/foundation.dart';

import '../widgets/layout.dart' show fmtK;

/// Service catalogue — the pricing rules lifted from the prototype's
/// `F1-1-Items` and `C1-1-Prices` components.
enum Service { iron, wash, dry }

extension ServiceX on Service {
  String get id => switch (this) {
        Service.iron => 'iron',
        Service.wash => 'wash',
        Service.dry => 'dry',
      };

  String get label => switch (this) {
        Service.iron => 'كوي',
        Service.wash => 'غسيل وكوي',
        Service.dry => 'تنظيف جاف',
      };

  String get short => switch (this) {
        Service.iron => 'كوي',
        Service.wash => 'غسيل وكوي',
        Service.dry => 'تنظيف جاف',
      };

  double get k => switch (this) {
        Service.iron => 1.0,
        Service.wash => 1.5,
        Service.dry => 2.0,
      };
}

/// A garment in the catalogue.
class Garment {
  const Garment(this.id, this.name, this.price);

  final String id;
  final String name;
  final int price;

  /// Price for a given service, rounded to the nearest 250 IQD — as the
  /// prototype's `unit()` does.
  int unit(Service s) => (price * s.k / 250).round() * 250;
}

/// The static catalogue used by the order builder.
const kCatalog = <Garment>[
  Garment('shirt', 'قميص', 1000),
  Garment('pants', 'بنطرون', 1000),
  Garment('dish', 'دشداشة', 1500),
  Garment('suit', 'قاط', 3000),
  Garment('abaya', 'عباءة', 2000),
  Garment('tshirt', 'تيشيرت', 750),
];

/// Price-list screen categories — `C1-1-Prices`.
class PriceGroup {
  const PriceGroup(this.id, this.name, this.items);

  final String id;
  final String name;
  final List<(String, int)> items;
}

const kPriceGroups = <PriceGroup>[
  PriceGroup('shirts', 'قمصان وبلوزات', [('قميص', 1000), ('بلوزة', 1000), ('تيشيرت', 750)]),
  PriceGroup('pants', 'بناطير وتنانير', [('بنطرون', 1000), ('تنورة', 1000)]),
  PriceGroup('suits', 'قاطات وسترات', [('قاط', 3000), ('سترة', 2000)]),
  PriceGroup('robes', 'دشاديش وعباءات', [('دشداشة', 1500), ('عباءة', 2000)]),
  PriceGroup('dress', 'فساتين', [('فستان', 2500)]),
  PriceGroup('heavy', 'ملابس ثقيلة', [('معطف', 3000), ('كنزة صوف', 1500)]),
  PriceGroup('school', 'زي مدرسي وملابس أطفال', [('زي مدرسي', 1000), ('ملابس أطفال', 500)]),
  PriceGroup('head', 'أغطية الرأس', [('يشماغ', 750)]),
];

/// One line in the order — a garment, quantity, service and valuables flag.
class OrderLine {
  OrderLine({
    required this.garmentId,
    required this.qty,
    this.service = Service.iron,
    this.valuable = false,
  });

  final String garmentId;
  int qty;
  Service service;
  bool valuable;

  Garment get garment =>
      kCatalog.firstWhere((g) => g.id == garmentId, orElse: () => kCatalog.first);

  int get lineTotal => garment.unit(service) * qty;
}

class Address {
  const Address(this.id, this.name, this.area, this.note, {this.inRange = true});

  final String id;
  final String name;
  final String area;
  final String note;
  final bool inRange;
}

const kAddresses = <Address>[
  Address('home', 'البيت', 'المنصور · شارع 14، دار 22', 'أقرب نقطة: جامع المنصور'),
  Address('work', 'العمل', 'الكرادة · عمارة 5، الطابق 3', 'اسأل عن الاستعلامات',
      inRange: false),
];

class Area {
  const Area(this.id, this.name, {this.served = false});

  final String id;
  final String name;
  final bool served;
}

const kAreas = <Area>[
  Area('mansour', 'المنصور', served: true),
  Area('karrada', 'الكرادة'),
  Area('zayouna', 'زيونة'),
  Area('yarmouk', 'اليرموك'),
  Area('adhamiya', 'الأعظمية'),
];

class Slot {
  const Slot(this.t, this.sub, {this.full = false});

  final String t;
  final String sub;
  final bool full;
}

const kSlots = <Slot>[
  Slot('8–10 ص', 'صباحاً'),
  Slot('10–12 ص', 'ممتلئة', full: true),
  Slot('4–6 م', 'مساءً'),
  Slot('6–8 م', 'مساءً'),
];

class DayOption {
  const DayOption(this.short, this.full, this.n, this.ret, {this.off = false});

  final String short;
  final String full;
  final int n;
  final String ret;
  final bool off;
}

const kDays = <DayOption>[
  DayOption('خميس', 'الخميس', 8, 'السبت'),
  DayOption('جمعة', 'الجمعة', 9, 'الاثنين', off: true),
  DayOption('سبت', 'السبت', 10, 'الاثنين'),
  DayOption('أحد', 'الأحد', 11, 'الثلاثاء'),
  DayOption('اثنين', 'الاثنين', 12, 'الأربعاء'),
  DayOption('ثلاثاء', 'الثلاثاء', 13, 'الخميس'),
  DayOption('أربعاء', 'الأربعاء', 14, 'السبت'),
];

/// The six order stages shown on every tracker.
const kStages = ['طلبك مؤكد', 'استلمنا ملابسك', 'قيد التجهيز', 'جاهزة', 'في الطريق إليك', 'تم التسليم'];

/// Global app state. One `ChangeNotifier` keeps the prototype's linked
/// screens consistent (editing the review screen reflects back into the
/// order builder, approving an extra item moves the total, and so on).
class AppState extends ChangeNotifier {
  // -- auth --
  bool registered = true;
  String phone = '0770 123 4567';
  String firstName = 'حيدر';

  // -- service area --
  String areaId = 'mansour';

  // -- order builder --
  final List<OrderLine> lines = [
    OrderLine(garmentId: 'shirt', qty: 6),
    OrderLine(garmentId: 'pants', qty: 4),
    OrderLine(garmentId: 'dish', qty: 2, valuable: true),
  ];
  bool familyLoad = false;

  String addressId = 'home';
  String whoDelivers = 'me';
  bool callBefore = true;
  String courierNote = 'الباب الأخضر، الطابق الثاني';

  int dayIndex = 0;
  int slotIndex = 3;
  bool repeatWeekly = false;
  String? needBy;

  // -- order lifecycle --
  String orderCode = 'Q-0142';
  int stage = 0;
  bool sendFailed = false;
  bool slotTaken = false;

  // pickup confirmation
  int countedByYou = 12;
  int countedByCourier = 12;
  String sealNumber = 'S-58213';

  // price-change approval
  bool extraItemApproved = false;
  int extraAmount = 2000;

  // -- delivery --
  bool delivered = false;
  int rating = 0;
  final Set<String> ratingTags = {'ontime'};

  // -- reports --
  String reportType = 'damaged';
  final Set<String> reportItems = {'dish'};
  final List<String> reportPhotos = [];

  // -- recurring --
  bool recurringPaused = false;
  final Set<int> skippedWeeks = {1};

  // -- notification prefs --
  bool pushWa = true;
  bool pushApp = true;
  bool pushStages = true;
  bool pushWeekly = true;
  bool pushOffers = false;

  // -- misc --
  bool offline = false;
  bool loading = false;

  Address get address =>
      kAddresses.firstWhere((a) => a.id == addressId, orElse: () => kAddresses.first);

  DayOption get day => kDays[dayIndex];
  Slot get slot => kSlots[slotIndex];

  String get returnWhen => '${day.ret} ${slot.t}';

  int get total =>
      lines.fold(0, (s, l) => s + l.lineTotal) + (extraItemApproved ? extraAmount : 0);

  int get baseTotal => lines.fold(0, (s, l) => s + l.lineTotal);

  int get pieceCount => lines.fold(0, (s, l) => s + l.qty);

  bool get canContinue => pieceCount > 0 || familyLoad;

  OrderLine? lineOf(String garmentId) {
    for (final l in lines) {
      if (l.garmentId == garmentId) return l;
    }
    return null;
  }

  void changeQty(String garmentId, int delta) {
    final existing = lineOf(garmentId);
    if (existing != null) {
      final q = existing.qty + delta;
      if (q <= 0) {
        lines.removeWhere((l) => l.garmentId == garmentId);
      } else {
        existing.qty = q;
      }
    } else if (delta > 0) {
      lines.add(OrderLine(garmentId: garmentId, qty: 1));
    }
    notifyListeners();
  }

  void patchLine(String garmentId, {Service? service, bool? valuable}) {
    final l = lineOf(garmentId);
    if (l == null) return;
    if (service != null) l.service = service;
    if (valuable != null) l.valuable = valuable;
    notifyListeners();
  }

  void removeLine(String garmentId) {
    lines.removeWhere((l) => l.garmentId == garmentId);
    notifyListeners();
  }

  void addCustom(String garmentId, Service service, int qty) {
    lines.add(OrderLine(garmentId: garmentId, qty: qty, service: service));
    notifyListeners();
  }

  void selectAddress(String id) {
    addressId = id;
    notifyListeners();
  }

  void selectDay(int i) {
    if (kDays[i].off) return;
    dayIndex = i;
    notifyListeners();
  }

  void selectSlot(int i) {
    if (kSlots[i].full) return;
    slotIndex = i;
    notifyListeners();
  }

  void approveExtra(bool yes) {
    extraItemApproved = yes;
    notifyListeners();
  }

  /// Public mutation hook — call after changing fields directly.
  void touch() => notifyListeners();

  String get totalLabel => fmtK(total);
  String get baseTotalLabel => fmtK(baseTotal);
}
