import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class StarfieldBackground extends StatefulWidget {
  final Widget child;
  const StarfieldBackground({super.key, required this.child});

  @override
  State<StarfieldBackground> createState() => _StarfieldBackgroundState();
}

class _StarfieldBackgroundState extends State<StarfieldBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Star> _stars = List.generate(45, (i) => _Star.random());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Deep space gradient
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, -0.4),
              radius: 1.2,
              colors: [
                Color(0xFF0F2B66),
                Color(0xFF0A1840),
                AppColors.night,
              ],
            ),
          ),
        ),
        // Animated Stars
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              size: Size.infinite,
              painter: _StarPainter(_stars, _controller.value),
            );
          },
        ),
        // Child content
        widget.child,
      ],
    );
  }
}

class _Star {
  final double x;
  final double y;
  final double radius;
  final double phase;

  _Star({required this.x, required this.y, required this.radius, required this.phase});

  factory _Star.random() {
    final rand = Random();
    return _Star(
      x: rand.nextDouble(),
      y: rand.nextDouble(),
      radius: 1.0 + rand.nextDouble() * 2.2,
      phase: rand.nextDouble() * 2 * pi,
    );
  }
}

class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final double animValue;

  _StarPainter(this.stars, this.animValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (final star in stars) {
      final opacity = (0.3 + 0.7 * sin(animValue * 2 * pi + star.phase)).clamp(0.0, 1.0);
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) => true;
}
