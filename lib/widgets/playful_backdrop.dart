import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PlayfulBackdrop extends StatelessWidget {
  const PlayfulBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.blush,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _SoftScenePainter())),
          child,
        ],
      ),
    );
  }
}

class _SoftScenePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pink = Paint()..color = AppColors.cloudPink.withValues(alpha: 0.45);
    final sky = Paint()..color = AppColors.softSky.withValues(alpha: 0.4);
    final butter = Paint()..color = AppColors.butter.withValues(alpha: 0.35);
    final lilac = Paint()..color = AppColors.lilacWash.withValues(alpha: 0.5);

    _blob(canvas, Offset(size.width * 0.9, -20), 120, pink);
    _blob(canvas, Offset(-30, size.height * 0.18), 100, sky);
    _blob(canvas, Offset(size.width * 0.2, size.height * 0.92), 140, butter);
    _blob(canvas, Offset(size.width * 0.95, size.height * 0.55), 80, lilac);

    // Soft wavy ground line
    final wave = Path()
      ..moveTo(0, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.68,
        size.width * 0.5,
        size.height * 0.74,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.8,
        size.width,
        size.height * 0.7,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      wave,
      Paint()..color = AppColors.cloudPink.withValues(alpha: 0.18),
    );
  }

  void _blob(Canvas canvas, Offset c, double r, Paint paint) {
    canvas.drawOval(
      Rect.fromCenter(center: c, width: r * 1.3, height: r),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Friendly handmade sprout mascot (original, not from mockups).
class SproutBuddy extends StatelessWidget {
  const SproutBuddy({super.key, this.size = 140});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _SproutPainter()),
    );
  }
}

class _SproutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pot = Paint()..color = const Color(0xFFFFB4A2);
    final potRim = Paint()..color = const Color(0xFFFF9B85);
    final soil = Paint()..color = const Color(0xFFC4A484);
    final leaf = Paint()..color = AppColors.softMoss;
    final leafDark = Paint()..color = AppColors.mossDeep;
    final cheek = Paint()..color = AppColors.cloudPink;
    final eye = Paint()..color = AppColors.ink;

    final cx = size.width / 2;
    final potTop = size.height * 0.55;

    // Pot
    final potPath = Path()
      ..moveTo(size.width * 0.22, potTop)
      ..lineTo(size.width * 0.78, potTop)
      ..lineTo(size.width * 0.7, size.height * 0.92)
      ..quadraticBezierTo(
        cx,
        size.height * 0.98,
        size.width * 0.3,
        size.height * 0.92,
      )
      ..close();
    canvas.drawPath(potPath, pot);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.18, potTop - 8, size.width * 0.64, 16),
        const Radius.circular(8),
      ),
      potRim,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, potTop + 4),
        width: size.width * 0.5,
        height: 14,
      ),
      soil,
    );

    // Stem
    final stem = Paint()
      ..color = AppColors.mossDeep
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx, potTop), Offset(cx, size.height * 0.28), stem);

    // Leaves
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - 22, size.height * 0.32),
        width: 36,
        height: 22,
      ),
      leaf,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx + 24, size.height * 0.28),
        width: 38,
        height: 24,
      ),
      leafDark,
    );

    // Face on pot
    canvas.drawCircle(Offset(cx - 12, potTop + 28), 3.2, eye);
    canvas.drawCircle(Offset(cx + 12, potTop + 28), 3.2, eye);
    canvas.drawCircle(Offset(cx - 18, potTop + 34), 5, cheek);
    canvas.drawCircle(Offset(cx + 18, potTop + 34), 5, cheek);
    final smile = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, potTop + 34), width: 18, height: 14),
      0.15 * math.pi,
      0.7 * math.pi,
      false,
      smile,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
