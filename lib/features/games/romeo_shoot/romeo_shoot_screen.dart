import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/providers/game_state_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../game_over/game_over_screen.dart';

class RomeoShootScreen extends StatefulWidget {
  const RomeoShootScreen({super.key});

  @override
  State<RomeoShootScreen> createState() => _RomeoShootScreenState();
}

class _RomeoShootScreenState extends State<RomeoShootScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ticker;
  final List<_TargetDrone> _targets = [];
  final List<_Projectile> _projectiles = [];
  final Random _rand = Random();

  int _score = 0;
  int _ammo = 10;

  Offset _slingshotRest = Offset.zero;
  Offset _pullPos = Offset.zero;
  bool _isPulling = false;

  @override
  void initState() {
    super.initState();
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _ticker.addListener(_updatePhysics);
  }

  void _updatePhysics() {
    final size = MediaQuery.of(context).size;
    if (_slingshotRest == Offset.zero) {
      _slingshotRest = Offset(size.width * 0.18, size.height * 0.70);
      _pullPos = _slingshotRest;
    }

    // Spawn drones occasionally
    if (_targets.length < 3 && _rand.nextDouble() < 0.03) {
      _targets.add(
        _TargetDrone(
          id: DateTime.now().microsecondsSinceEpoch,
          x: size.width + 40,
          y: size.height * (0.15 + _rand.nextDouble() * 0.4),
          vx: -(1.5 + _rand.nextDouble() * 1.5),
        ),
      );
    }

    // Update Targets
    for (final t in _targets) {
      t.x += t.vx;
    }
    _targets.removeWhere((t) => t.x < -80 || !t.alive);

    // Update Projectiles
    for (final p in _projectiles) {
      p.vy += 0.35; // gravity
      p.x += p.vx;
      p.y += p.vy;

      // Check hit with targets
      for (final t in _targets) {
        if (!t.alive) continue;
        final dist = (Offset(p.x, p.y) - Offset(t.x, t.y)).distance;
        if (dist <= 38) {
          t.alive = false;
          p.alive = false;
          _score += 20;
          AudioService.instance.playSplat();
          break;
        }
      }
    }
    _projectiles.removeWhere((p) => !p.alive || p.y > size.height + 50);

    // Game over check
    if (_ammo <= 0 && _projectiles.isEmpty) {
      _endGame();
      return;
    }

    setState(() {});
  }

  void _onPanStart(DragStartDetails details) {
    if (_ammo <= 0) return;
    final dist = (details.localPosition - _slingshotRest).distance;
    if (dist <= 60) {
      _isPulling = true;
      _pullPos = details.localPosition;
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isPulling) return;
    final diff = details.localPosition - _slingshotRest;
    final dist = diff.distance;
    const maxPull = 90.0;
    if (dist > maxPull) {
      _pullPos = _slingshotRest + (diff / dist) * maxPull;
    } else {
      _pullPos = details.localPosition;
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_isPulling) return;
    _isPulling = false;

    final diff = _slingshotRest - _pullPos;
    final dist = diff.distance;
    if (dist >= 15 && _ammo > 0) {
      final power = (dist / 90.0).clamp(0.0, 1.0);
      final speed = 12.0 + power * 14.0;
      final dir = diff / dist;

      _projectiles.add(
        _Projectile(
          x: _pullPos.dx,
          y: _pullPos.dy,
          vx: dir.dx * speed,
          vy: dir.dy * speed,
        ),
      );

      _ammo--;
      AudioService.instance.playSlingshot();
    }

    _pullPos = _slingshotRest;
  }

  void _endGame() {
    _ticker.stop();
    final gameState = GameStateProvider();
    gameState.submitScore(gameType: 'shoot', score: _score);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameOverScreen(
          missionName: "Romeo's Robots",
          score: _score,
          onReplay: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const RomeoShootScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background City Skyline
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF080C25), Color(0xFF111A5A), Color(0xFF1A2660)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Custom Paint Slingshot & Entities
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: CustomPaint(
              size: Size.infinite,
              painter: _RomeoShootPainter(
                slingshotRest: _slingshotRest,
                pullPos: _pullPos,
                isPulling: _isPulling,
                targets: _targets,
                projectiles: _projectiles,
              ),
            ),
          ),

          // HUD Top
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'SCORE: $_score',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.yellow,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'AMMO: $_ammo',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.cyan,
                      ),
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

class _TargetDrone {
  final int id;
  double x;
  double y;
  final double vx;
  bool alive = true;

  _TargetDrone({required this.id, required this.x, required this.y, required this.vx});
}

class _Projectile {
  double x;
  double y;
  double vx;
  double vy;
  bool alive = true;

  _Projectile({required this.x, required this.y, required this.vx, required this.vy});
}

class _RomeoShootPainter extends CustomPainter {
  final Offset slingshotRest;
  final Offset pullPos;
  final bool isPulling;
  final List<_TargetDrone> targets;
  final List<_Projectile> projectiles;

  _RomeoShootPainter({
    required this.slingshotRest,
    required this.pullPos,
    required this.isPulling,
    required this.targets,
    required this.projectiles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw Targets (Romeo flying robot drones)
    for (final t in targets) {
      // Robot Body
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(t.x, t.y), width: 44, height: 44),
          const Radius.circular(8),
        ),
        Paint()..color = const Color(0xFF888888),
      );
      // Robot Red Eye
      canvas.drawCircle(Offset(t.x, t.y - 4), 10, Paint()..color = Colors.red);
      // Propeller
      canvas.drawOval(
        Rect.fromCenter(center: Offset(t.x, t.y - 26), width: 36, height: 8),
        Paint()..color = Colors.white70,
      );
    }

    // Draw Projectiles
    for (final p in projectiles) {
      canvas.drawCircle(
        Offset(p.x, p.y),
        14,
        Paint()..color = const Color(0xFF0066FF),
      );
      canvas.drawCircle(
        Offset(p.x - 3, p.y - 3),
        5,
        Paint()..color = const Color(0xFF88DDFF),
      );
    }

    // Draw Slingshot Fork
    if (slingshotRest != Offset.zero) {
      final forkPaint = Paint()
        ..color = const Color(0xFF8B5E3C)
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round;

      // Base stick
      canvas.drawLine(
        Offset(slingshotRest.dx, slingshotRest.dy + 45),
        Offset(slingshotRest.dx, slingshotRest.dy),
        forkPaint,
      );
      // Left prong
      canvas.drawLine(
        Offset(slingshotRest.dx, slingshotRest.dy),
        Offset(slingshotRest.dx - 24, slingshotRest.dy - 35),
        forkPaint,
      );
      // Right prong
      canvas.drawLine(
        Offset(slingshotRest.dx, slingshotRest.dy),
        Offset(slingshotRest.dx + 24, slingshotRest.dy - 35),
        forkPaint,
      );

      // Elastic Bands
      final bandPaint = Paint()
        ..color = const Color(0xFFCC8800)
        ..strokeWidth = 4;

      canvas.drawLine(Offset(slingshotRest.dx - 24, slingshotRest.dy - 35), pullPos, bandPaint);
      canvas.drawLine(Offset(slingshotRest.dx + 24, slingshotRest.dy - 35), pullPos, bandPaint);

      // Ball in pouch
      canvas.drawCircle(pullPos, 12, Paint()..color = const Color(0xFF0066FF));
    }
  }

  @override
  bool shouldRepaint(covariant _RomeoShootPainter oldDelegate) => true;
}
