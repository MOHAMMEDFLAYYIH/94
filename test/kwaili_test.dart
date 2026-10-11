import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kwaili/state/app_state.dart';
import 'package:kwaili/theme/icons.dart';
import 'package:kwaili/theme/svg_path.dart';
import 'package:kwaili/theme/tokens.dart';
import 'package:kwaili/widgets/controls.dart';
import 'package:kwaili/widgets/layout.dart';

void main() {
  group('pricing rules', () {
    test('service multiplier rounds to the nearest 250 IQD', () {
      const shirt = Garment('shirt', 'قميص', 1000);
      expect(shirt.unit(Service.iron), 1000);
      expect(shirt.unit(Service.wash), 1500);
      expect(shirt.unit(Service.dry), 2000);

      // 750 * 1.5 = 1125 -> 1125/250 = 4.5 -> rounds to 5 -> 1250
      const tshirt = Garment('tshirt', 'تيشيرت', 750);
      expect(tshirt.unit(Service.iron), 750);
      expect(tshirt.unit(Service.wash), 1250);
      expect(tshirt.unit(Service.dry), 1500);
    });

    test('fmtK groups thousands with latin separators', () {
      expect(fmtK(0), '0');
      expect(fmtK(750), '750');
      expect(fmtK(13000), '13,000');
      expect(fmtK(1500000), '1,500,000');
    });

    test('normalizeDigits folds arabic-indic numerals', () {
      expect(normalizeDigits('٠٧٧٠ ١٢٣ ٤٥٦٧'), '07701234567');
      expect(normalizeDigits('۰۷۷۰'), '0770');
      expect(normalizeDigits('07 70'), '0770');
    });
  });

  group('AppState', () {
    test('seeded order totals match the prototype (13,000 IQD)', () {
      final s = AppState();
      expect(s.pieceCount, 12);
      expect(s.baseTotal, 13000);
      expect(s.total, 13000);
    });

    test('changing a service repricing the line and the total', () {
      final s = AppState();
      s.patchLine('shirt', service: Service.wash);
      // 6 shirts * 1500 instead of * 1000
      expect(s.baseTotal, 16000);
    });

    test('decrementing to zero removes the line', () {
      final s = AppState();
      s.changeQty('suit', 1);
      expect(s.lineOf('suit'), isNotNull);
      s.changeQty('suit', -1);
      expect(s.lineOf('suit'), isNull);
    });

    test('approving the extra item adds 2,000 to the total', () {
      final s = AppState();
      expect(s.total, 13000);
      s.approveExtra(true);
      expect(s.total, 15000);
      s.approveExtra(false);
      expect(s.total, 13000);
    });

    test('friday is not selectable, thursday is the default', () {
      final s = AppState();
      expect(s.day.full, 'الخميس');
      s.selectDay(1); // الجمعة — off
      expect(s.dayIndex, 0);
      s.selectDay(2);
      expect(s.day.full, 'السبت');
    });

    test('the full 10–12 slot cannot be picked', () {
      final s = AppState();
      expect(s.slot.t, '6–8 م');
      s.selectSlot(1); // ممتلئة
      expect(s.slotIndex, 3);
    });

    test('out-of-range address blocks continuing', () {
      final s = AppState();
      expect(s.address.inRange, isTrue);
      s.selectAddress('work');
      expect(s.address.inRange, isFalse);
    });

    test('canContinue honours the family-load escape hatch', () {
      final s = AppState();
      s.lines.clear();
      expect(s.canContinue, isFalse);
      s.familyLoad = true;
      expect(s.canContinue, isTrue);
    });
  });

  group('icons', () {
    test('every declared path is valid SVG', () {
      for (final name in KwIcons.names) {
        expect(KwIcons.pathOf(name), isNotNull, reason: '$name is missing a path');
        expect(() => parseKwPath(KwIcons.pathOf(name)!), returnsNormally,
            reason: '$name failed to parse');
      }
    });

    test('the icon set covers the glyphs screens reference', () {
      const required = [
        'home', 'basket', 'iron', 'receipt', 'profile', 'shirt', 'hanger',
        'truck', 'clock', 'check', 'pin', 'bell', 'plus', 'close',
        'chevron-left', 'chevron-right', 'sparkle', 'search', 'minus',
        'info', 'cash', 'star', 'camera', 'whatsapp', 'phone', 'shield',
        'bag', 'help', 'logout', 'trash', 'image', 'pause', 'alert', 'edit',
      ];
      for (final r in required) {
        expect(KwIcons.pathOf(r), isNotNull, reason: 'missing icon: $r');
      }
    });
  });

  group('tokens', () {
    test('brand palette matches the design system', () {
      expect(K.brand, const Color(0xFF0DC189));
      expect(K.action, const Color(0xFF098760));
      expect(K.brandText, const Color(0xFF08704F));
      expect(K.tintGreen, const Color(0xFFABFFCD));
      expect(K.ground, const Color(0xFFEFEFEF));
      expect(K.danger, const Color(0xFFC62F2F));
    });
  });

  group('widgets', () {
    testWidgets('KwButton disables when onPressed is null', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: KwButton('التالي')),
      ));
      final btn = tester.widget<KwButton>(find.byType(KwButton));
      expect(btn.onPressed, isNull);
      expect(find.text('التالي'), findsOneWidget);
    });

    testWidgets('KwToggle flips its value', (tester) async {
      var value = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, set) => KwToggle(
              value: value,
              onChanged: (v) => set(() => value = v),
            ),
          ),
        ),
      ));
      await tester.tap(find.byType(KwToggle));
      await tester.pumpAndSettle();
      expect(value, isTrue);
    });

    testWidgets('KwStepper reports increments and decrements', (tester) async {
      var up = 0, down = 0;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: KwStepper(
            value: 3,
            onInc: () => up++,
            onDec: () => down++,
          ),
        ),
      ));
      expect(find.text('3'), findsOneWidget);

      final buttons = find.descendant(
        of: find.byType(KwStepper),
        matching: find.byType(KwIcon),
      );
      expect(buttons, findsNWidgets(2));

      await tester.tap(buttons.first); // minus
      await tester.pump();
      expect(down, 1);
      expect(up, 0);

      await tester.tap(buttons.last); // plus
      await tester.pump();
      expect(up, 1);
    });

    testWidgets('Ltr isolates numbers inside RTL copy', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Ltr('13,000'),
          ),
        ),
      ));
      expect(find.text('13,000'), findsOneWidget);
      final dir = tester.widget<Directionality>(find.byType(Directionality).last);
      expect(dir.textDirection, TextDirection.ltr);
    });
  });
}
