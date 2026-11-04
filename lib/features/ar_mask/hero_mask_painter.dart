import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/hero_character.dart';

class HeroMaskPainter extends CustomPainter {
  final HeroId heroId;
  final double headX; // 0..1
  final double headY; // 0..1
  final double scale;
  final double tilt;

  HeroMaskPainter({
    required this.heroId,
    this.headX = 0.5,
    this.headY = 0.45,
    this.scale = 1.0,
    this.tilt = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = headX * size.width;
    final centerY = headY * size.height;
    final maskSize = min(size.width, size.height) * 0.55 * scale;
    final s = maskSize / 200.0;

    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(tilt);

    switch (heroId) {
      case HeroId.catboy:
        _drawCatboyMask(canvas, s);
        break;
      case HeroId.owlette:
        _drawOwletteMask(canvas, s);
        break;
      case HeroId.gekko:
        _drawGekkoMask(canvas, s);
        break;
    }

    canvas.restore();
  }

  void _drawCatboyMask(Canvas canvas, double s) {
    final bluePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0052CC), Color(0xFF002699), Color(0xFF00144D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(-100 * s, -140 * s, 200 * s, 200 * s));

    final cyanStroke = Paint()
      ..color = const Color(0xFF00D4FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5 * s;

    final cyanFill = Paint()..color = const Color(0xFF00F0FF);

    // Left Ear
    final leftEar = Path()
      ..moveTo(-75 * s, -30 * s)
      ..quadraticBezierTo(-95 * s, -85 * s, -80 * s, -135 * s)
      ..quadraticBezierTo(-45 * s, -100 * s, -30 * s, -55 * s)
      ..close();
    canvas.drawPath(leftEar, bluePaint);
    canvas.drawPath(leftEar, cyanStroke);

    // Left Ear Inner Lightning
    final leftEarInner = Path()
      ..moveTo(-70 * s, -45 * s)
      ..lineTo(-76 * s, -115 * s)
      ..lineTo(-48 * s, -70 * s)
      ..close();
    canvas.drawPath(leftEarInner, cyanFill);

    // Right Ear
    final rightEar = Path()
      ..moveTo(75 * s, -30 * s)
      ..quadraticBezierTo(95 * s, -85 * s, 80 * s, -135 * s)
      ..quadraticBezierTo(45 * s, -100 * s, 30 * s, -55 * s)
      ..close();
    canvas.drawPath(rightEar, bluePaint);
    canvas.drawPath(rightEar, cyanStroke);

    // Right Ear Inner Lightning
    final rightEarInner = Path()
      ..moveTo(70 * s, -45 * s)
      ..lineTo(76 * s, -115 * s)
      ..lineTo(48 * s, -70 * s)
      ..close();
    canvas.drawPath(rightEarInner, cyanFill);

    // Main Face Mask Shell
    final shell = Path()
      ..moveTo(-95 * s, -20 * s)
      ..quadraticBezierTo(0, -65 * s, 95 * s, -20 * s)
      ..quadraticBezierTo(105 * s, 25 * s, 75 * s, 55 * s)
      ..quadraticBezierTo(35 * s, 48 * s, 0, 70 * s)
      ..quadraticBezierTo(-35 * s, 48 * s, -75 * s, 55 * s)
      ..quadraticBezierTo(-105 * s, 25 * s, -95 * s, -20 * s)
      ..close();
    canvas.drawPath(shell, bluePaint);
    canvas.drawPath(shell, cyanStroke);

    // Whiskers Left
    for (final yOff in [-10, 10, 30]) {
      final p = Path()
        ..moveTo(-90 * s, yOff * s)
        ..lineTo(-65 * s, (yOff + 5) * s)
        ..lineTo(-88 * s, (yOff + 10) * s)
        ..close();
      canvas.drawPath(p, cyanFill);
    }
    // Whiskers Right
    for (final yOff in [-10, 10, 30]) {
      final p = Path()
        ..moveTo(90 * s, yOff * s)
        ..lineTo(65 * s, (yOff + 5) * s)
        ..lineTo(88 * s, (yOff + 10) * s)
        ..close();
      canvas.drawPath(p, cyanFill);
    }

    // Forehead Amulet
    canvas.drawCircle(Offset(0, -25 * s), 16 * s, cyanFill);
    canvas.drawCircle(
      Offset(0, -25 * s),
      16 * s,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * s,
    );

    // Glowing Eyes
    _drawEye(canvas, -45 * s, 5 * s, s, const Color(0xFF00F0FF), false);
    _drawEye(canvas, 45 * s, 5 * s, s, const Color(0xFF00F0FF), true);
  }

  void _drawOwletteMask(Canvas canvas, double s) {
    final redPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFF1A53), Color(0xFFCC0033), Color(0xFF800020)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(-100 * s, -140 * s, 200 * s, 200 * s));

    final pinkStroke = Paint()
      ..color = const Color(0xFFFF99B3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * s;

    // Feather Crest Center
    final crest = Path()
      ..moveTo(-25 * s, -40 * s)
      ..quadraticBezierTo(-15 * s, -110 * s, 0, -135 * s)
      ..quadraticBezierTo(15 * s, -110 * s, 25 * s, -40 * s)
      ..close();
    canvas.drawPath(crest, redPaint);
    canvas.drawPath(crest, pinkStroke);

    // Winged Mask Shell
    final shell = Path()
      ..moveTo(-110 * s, -15 * s)
      ..quadraticBezierTo(-60 * s, -50 * s, 0, -35 * s)
      ..quadraticBezierTo(60 * s, -50 * s, 110 * s, -15 * s)
      ..quadraticBezierTo(125 * s, 25 * s, 85 * s, 60 * s)
      ..quadraticBezierTo(35 * s, 50 * s, 0, 75 * s)
      ..quadraticBezierTo(-35 * s, 50 * s, -85 * s, 60 * s)
      ..quadraticBezierTo(-125 * s, 25 * s, -110 * s, -15 * s)
      ..close();
    canvas.drawPath(shell, redPaint);
    canvas.drawPath(shell, pinkStroke);

    // Beak
    final beak = Path()
      ..moveTo(-12 * s, 42 * s)
      ..lineTo(0, 68 * s)
      ..lineTo(12 * s, 42 * s)
      ..close();
    canvas.drawPath(beak, Paint()..color = const Color(0xFFFFCC00));

    // Forehead Amulet
    canvas.drawCircle(Offset(0, -15 * s), 16 * s, Paint()..color = const Color(0xFFFFCC00));

    // Glowing Owl Eyes
    _drawEye(canvas, -46 * s, 10 * s, s, const Color(0xFFFFB300), false);
    _drawEye(canvas, 46 * s, 10 * s, s, const Color(0xFFFFB300), true);
  }

  void _drawGekkoMask(Canvas canvas, double s) {
    final greenPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF00B33C), Color(0xFF00802B), Color(0xFF004D1A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(-100 * s, -140 * s, 200 * s, 200 * s));

    final limeStroke = Paint()
      ..color = const Color(0xFF66FF99)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * s;

    // Triple Lizard Crest Fins
    for (final xOff in [-35.0, 0.0, 35.0]) {
      final height = xOff == 0.0 ? -125.0 : -100.0;
      final fin = Path()
        ..moveTo((xOff - 18) * s, -40 * s)
        ..lineTo(xOff * s, height * s)
        ..lineTo((xOff + 18) * s, -40 * s)
        ..close();
      canvas.drawPath(fin, greenPaint);
      canvas.drawPath(fin, limeStroke);
    }

    // Mask Shell
    final shell = Path()
      ..moveTo(-90 * s, -25 * s)
      ..quadraticBezierTo(0, -55 * s, 90 * s, -25 * s)
      ..lineTo(95 * s, 25 * s)
      ..quadraticBezierTo(80 * s, 60 * s, 45 * s, 65 * s)
      ..quadraticBezierTo(20 * s, 50 * s, 0, 68 * s)
      ..quadraticBezierTo(-20 * s, 50 * s, -45 * s, 65 * s)
      ..quadraticBezierTo(-80 * s, 60 * s, -95 * s, 25 * s)
      ..close();
    canvas.drawPath(shell, greenPaint);
    canvas.drawPath(shell, limeStroke);

    // Cheek Scales
    final scalePaint = Paint()..color = const Color(0xFF66FF99);
    for (final ox in [-75.0, 75.0]) {
      canvas.drawCircle(Offset(ox * s, 0), 8 * s, scalePaint);
      canvas.drawCircle(Offset((ox + 10) * s, 16 * s, ), 7 * s, scalePaint);
    }

    // Forehead Amulet
    canvas.drawCircle(Offset(0, -20 * s), 16 * s, scalePaint);

    // Glowing Eyes
    _drawEye(canvas, -45 * s, 8 * s, s, const Color(0xFF00FF66), false);
    _drawEye(canvas, 45 * s, 8 * s, s, const Color(0xFF00FF66), true);
  }

  void _drawEye(Canvas canvas, double x, double y, double s, Color glowColor, bool flip) {
    canvas.save();
    canvas.translate(x, y);
    if (flip) canvas.scale(-1, 1);

    final eyePath = Path()
      ..moveTo(-35 * s, -12 * s)
      ..quadraticBezierTo(0, -25 * s, 35 * s, 2 * s)
      ..quadraticBezierTo(5 * s, 18 * s, -35 * s, -12 * s)
      ..close();

    // Eye glow fill
    canvas.drawPath(
      eyePath,
      Paint()..color = glowColor.withOpacity(0.4),
    );

    // Eye outline
    canvas.drawPath(
      eyePath,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * s,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant HeroMaskPainter oldDelegate) {
    return oldDelegate.heroId != heroId ||
        oldDelegate.headX != headX ||
        oldDelegate.headY != headY ||
        oldDelegate.scale != scale ||
        oldDelegate.tilt != tilt;
  }
}
