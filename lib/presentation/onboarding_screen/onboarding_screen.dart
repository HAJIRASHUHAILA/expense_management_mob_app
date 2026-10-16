import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/onboarding_controller.dart';

// ───────────────────────── Colors ─────────────────────────
class OnboardingColors {
  static const teal = Color(0xFF429690);
  static const tealDark = Color(0xFF2C7A74);
  static const tealDeep = Color(0xFF1A3B34);
}

const glowTealShadow = [
  BoxShadow(
    color: Color(0x73429690), // rgba(66,150,144,0.45)
    blurRadius: 28,
    spreadRadius: -6,
    offset: Offset(0, 12),
  ),
];

// ───────────────────────── Onboarding Screen ─────────────────────────
class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(child: HeroVisualSection()),
            BottomContentSection(onGetStarted: controller.getStarted),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Hero Visual Section ─────────────────────────
class HeroVisualSection extends StatelessWidget {
  const HeroVisualSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -48,
            left: 0,
            right: 0,
            height: 490,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(70)),
                gradient: RadialGradient(
                  center: Alignment(0, -0.44),
                  radius: 1.03,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFEEF7F6),
                    Color(0xFFDFEFF0),
                  ],
                  stops: [0.0, 0.65, 1.0],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: CharacterIllustration(),
          ),
        ],
      ),
    );
  }
}

class CharacterIllustration extends StatelessWidget {
  const CharacterIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 340, maxHeight: 390),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 380),
          child: const AspectRatio(
            aspectRatio: 320 / 380,
            child: CustomPaint(painter: _CharacterPainter()),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Bottom Content Section ─────────────────────────
class BottomContentSection extends StatelessWidget {
  final VoidCallback onGetStarted;
  const BottomContentSection({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Spend Smarter\nSave More',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: OnboardingColors.tealDeep,
              letterSpacing: -0.75,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 32),
          GetStartedButton(onTap: onGetStarted),
        ],
      ),
    );
  }
}

class GetStartedButton extends StatelessWidget {
  final VoidCallback onTap;
  const GetStartedButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4FA49E), Color(0xFF358882)],
          ),
          boxShadow: glowTealShadow,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            splashColor: const Color(0x33000000),
            onTap: onTap,
            child: const Center(
              child: Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.45,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Illustration painter ─────────────────────────
// Paints in the SVG's original 320 x 380 coordinate space and scales to fit.
class _CharacterPainter extends CustomPainter {
  const _CharacterPainter();

  Paint _grad(Path p, List<Color> colors,
      {List<double>? stops,
        Alignment begin = Alignment.topLeft,
        Alignment end = Alignment.bottomRight}) {
    return Paint()
      ..shader = LinearGradient(
        begin: begin,
        end: end,
        colors: colors,
        stops: stops,
      ).createShader(p.getBounds());
  }

  Paint _stroke(Path p, List<Color> colors,
      {required double width, List<double>? stops}) {
    return _grad(p, colors, stops: stops)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
  }

  Paint _solid(Color c) => Paint()..color = c;

  Paint _line(Color c, double w) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = w
    ..strokeCap = StrokeCap.round;

  Paint _shadow(Color c, double sigma) => Paint()
    ..color = c
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, sigma);

  Path _slice(Offset a, Offset b) => Path()
    ..moveTo(255, 125)
    ..lineTo(a.dx, a.dy)
    ..arcToPoint(b, radius: const Radius.circular(27), clockwise: true)
    ..close();

  static const _skin = [Color(0xFFFFD6C0), Color(0xFFEAA684)];
  static const _shirt = [Color(0xFF4CA79F), Color(0xFF34847E), Color(0xFF235D58)];
  static const _shirtStops = [0.0, 0.5, 1.0];
  static const _pants = [Color(0xFF4B77BE), Color(0xFF284B87)];
  static const _shoe = [Color(0xFFFFFFFF), Color(0xFFCBD5E1)];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 320, size.height / 380);

    // Ground contact shadow
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(160, 355), width: 110, height: 20),
      _shadow(const Color(0x1F2C4E4B), 4),
    );

    // ── Floating coin (left) ──
    canvas.drawCircle(
        const Offset(68, 121), 23, _shadow(const Color(0x4D38BDF8), 8));
    final coinPath = Path()
      ..addOval(Rect.fromCircle(center: const Offset(68, 115), radius: 23));
    canvas.drawPath(
      coinPath,
      _grad(coinPath, const [
        Color(0xFF67E8F9),
        Color(0xFF06B6D4),
        Color(0xFF0891B2),
      ], stops: const [0, 0.5, 1]),
    );
    canvas.drawCircle(
      const Offset(68, 115),
      19,
      Paint()
        ..color = const Color(0xCCE0F2FE)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final tp = TextPainter(
      text: const TextSpan(
        text: '\$',
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final baseline = tp.computeDistanceToActualBaseline(TextBaseline.alphabetic);
    tp.paint(canvas, Offset(68 - tp.width / 2, 122 - baseline));
    canvas.save();
    canvas.translate(61, 103);
    canvas.rotate(-30 * 3.1415926535 / 180);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 14, height: 7),
      _solid(const Color(0x73FFFFFF)),
    );
    canvas.restore();

    // ── Floating pie chart (right) ──
    final s1 = _slice(const Offset(255, 98), const Offset(278, 116));
    final s2 = _slice(const Offset(278, 116), const Offset(262, 151));
    final s3 = _slice(const Offset(262, 151), const Offset(230, 137));
    final s4 = _slice(const Offset(230, 137), const Offset(255, 98));
    final pieAll = Path()
      ..addPath(s1, Offset.zero)
      ..addPath(s2, Offset.zero)
      ..addPath(s3, Offset.zero)
      ..addPath(s4, Offset.zero);
    canvas.drawPath(
        pieAll.shift(const Offset(0, 6)), _shadow(const Color(0x40F43F5E), 8));
    canvas.drawPath(s1, _solid(const Color(0xFFF43F5E)));
    canvas.drawPath(s2, _solid(const Color(0xFF0EA5E9)));
    canvas.drawPath(s3, _solid(const Color(0xFFF59E0B)));
    canvas.drawPath(s4, _solid(const Color(0xFF10B981)));
    canvas.drawCircle(
        const Offset(255, 125), 10, _solid(const Color(0xFFEEF7F6)));

    // ── Legs ──
    final leftLeg = Path()
      ..moveTo(148, 225)
      ..quadraticBezierTo(135, 255, 130, 280)
      ..quadraticBezierTo(126, 298, 142, 322);
    canvas.drawPath(leftLeg, _stroke(leftLeg, _pants, width: 24));

    final leftShoe = Path()
      ..moveTo(136, 322)
      ..cubicTo(136, 317, 150, 318, 156, 324)
      ..cubicTo(162, 330, 160, 338, 148, 338)
      ..cubicTo(136, 338, 136, 328, 136, 322)
      ..close();
    canvas.drawPath(
        leftShoe,
        _grad(leftShoe, _shoe,
            begin: Alignment.topCenter, end: Alignment.bottomCenter));
    final leftSole = Path()
      ..moveTo(138, 335)
      ..cubicTo(146, 335, 158, 335, 156, 341)
      ..cubicTo(146, 342, 136, 341, 138, 335)
      ..close();
    canvas.drawPath(leftSole, _solid(const Color(0xFF475569)));

    final rightLeg = Path()
      ..moveTo(172, 225)
      ..quadraticBezierTo(180, 260, 174, 290)
      ..quadraticBezierTo(170, 315, 166, 330);
    canvas.drawPath(rightLeg, _stroke(rightLeg, _pants, width: 24));

    final rightShoe = Path()
      ..moveTo(160, 328)
      ..cubicTo(160, 320, 178, 322, 182, 330)
      ..cubicTo(186, 338, 178, 346, 166, 346)
      ..cubicTo(158, 346, 160, 334, 160, 328)
      ..close();
    canvas.drawPath(
        rightShoe,
        _grad(rightShoe, _shoe,
            begin: Alignment.topCenter, end: Alignment.bottomCenter));
    final rightSole = Path()
      ..moveTo(162, 343)
      ..cubicTo(170, 343, 180, 343, 178, 348)
      ..cubicTo(170, 350, 162, 349, 162, 343)
      ..close();
    canvas.drawPath(rightSole, _solid(const Color(0xFF475569)));

    // ── Torso ──
    final torso = Path()
      ..moveTo(138, 158)
      ..quadraticBezierTo(160, 152, 182, 158)
      ..quadraticBezierTo(192, 190, 186, 230)
      ..quadraticBezierTo(160, 236, 134, 230)
      ..quadraticBezierTo(128, 190, 138, 158)
      ..close();
    canvas.drawPath(
        torso.shift(const Offset(0, 12)), _shadow(const Color(0x2E184E49), 10));
    canvas.drawPath(torso, _grad(torso, _shirt, stops: _shirtStops));

    // Collar
    final collar = Path()
      ..moveTo(152, 155)
      ..lineTo(160, 170)
      ..lineTo(168, 155);
    canvas.drawPath(collar, _line(const Color(0xFF235D58), 3));

    // ── Left arm & hand ──
    final lArm = Path()
      ..moveTo(138, 165)
      ..quadraticBezierTo(102, 160, 84, 142);
    canvas.drawPath(lArm, _stroke(lArm, _shirt, width: 18, stops: _shirtStops));
    final lForearm = Path()
      ..moveTo(84, 142)
      ..lineTo(72, 135);
    canvas.drawPath(lForearm, _stroke(lForearm, _skin, width: 14));
    canvas.drawCircle(
      const Offset(70, 132),
      7,
      _grad(
          Path()
            ..addOval(Rect.fromCircle(center: const Offset(70, 132), radius: 7)),
          _skin),
    );

    // ── Right arm & hand ──
    final rArm = Path()
      ..moveTo(182, 165)
      ..quadraticBezierTo(218, 160, 236, 142);
    canvas.drawPath(rArm, _stroke(rArm, _shirt, width: 18, stops: _shirtStops));
    final rForearm = Path()
      ..moveTo(236, 142)
      ..lineTo(248, 135);
    canvas.drawPath(rForearm, _stroke(rForearm, _skin, width: 14));
    canvas.drawCircle(
      const Offset(250, 132),
      7,
      _grad(
          Path()
            ..addOval(
                Rect.fromCircle(center: const Offset(250, 132), radius: 7)),
          _skin),
    );

    // ── Neck ──
    final neck = Path()
      ..addRRect(RRect.fromRectAndRadius(
        const Rect.fromLTWH(154, 138, 12, 18),
        const Radius.circular(6),
      ));
    canvas.drawPath(neck, _grad(neck, _skin));

    // ── Face ──
    final face = Path()
      ..addOval(Rect.fromCenter(
          center: const Offset(160, 116), width: 40, height: 48));
    canvas.drawPath(face, _grad(face, _skin));

    // ── Hair ──
    final hair = Path()
      ..moveTo(140, 110)
      ..cubicTo(138, 88, 152, 74, 168, 74)
      ..cubicTo(180, 74, 186, 84, 184, 96)
      ..cubicTo(188, 96, 190, 102, 188, 112)
      ..cubicTo(184, 105, 180, 102, 178, 102)
      ..cubicTo(172, 102, 170, 96, 160, 96)
      ..cubicTo(150, 96, 144, 104, 140, 110)
      ..close();
    canvas.drawPath(
        hair,
        _grad(hair, const [Color(0xFF733827), Color(0xFF4A1E13)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter));

    // ── Beard / stubble ──
    final beard = Path()
      ..moveTo(144, 116)
      ..cubicTo(144, 135, 154, 141, 160, 141)
      ..cubicTo(166, 141, 176, 135, 176, 116)
      ..cubicTo(176, 122, 170, 136, 160, 136)
      ..cubicTo(150, 136, 144, 122, 144, 116)
      ..close();
    canvas.drawPath(beard, _solid(const Color(0x995A2417)));

    // ── Eyes, brows, mouth ──
    canvas.drawCircle(
        const Offset(152, 112), 2.5, _solid(const Color(0xFF291209)));
    canvas.drawCircle(
        const Offset(168, 112), 2.5, _solid(const Color(0xFF291209)));

    final browL = Path()
      ..moveTo(149, 106)
      ..quadraticBezierTo(153, 104, 157, 106);
    final browR = Path()
      ..moveTo(163, 106)
      ..quadraticBezierTo(167, 104, 171, 106);
    canvas.drawPath(browL, _line(const Color(0xFF4A1E13), 1.8));
    canvas.drawPath(browR, _line(const Color(0xFF4A1E13), 1.8));

    final mouth = Path()
      ..moveTo(154, 124)
      ..quadraticBezierTo(160, 130, 166, 124);
    canvas.drawPath(mouth, _line(const Color(0xFF7A2216), 2.2));

    // ── Sparkles ──
    final sparkle1 = Path()
      ..moveTo(105, 80)
      ..lineTo(108, 86)
      ..lineTo(114, 88)
      ..lineTo(108, 90)
      ..lineTo(105, 96)
      ..lineTo(103, 90)
      ..lineTo(97, 88)
      ..lineTo(103, 86)
      ..close();
    canvas.drawPath(sparkle1, _solid(const Color(0x664CA79F)));

    final sparkle2 = Path()
      ..moveTo(220, 82)
      ..lineTo(222, 86)
      ..lineTo(226, 88)
      ..lineTo(222, 90)
      ..lineTo(220, 94)
      ..lineTo(218, 90)
      ..lineTo(214, 88)
      ..lineTo(218, 86)
      ..close();
    canvas.drawPath(sparkle2, _solid(const Color(0x8038BDF8)));

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}