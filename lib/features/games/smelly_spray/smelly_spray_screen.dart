import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/providers/game_state_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../game_over/game_over_screen.dart';

class SmellySprayScreen extends StatefulWidget {
  const SmellySprayScreen({super.key});

  @override
  State<SmellySprayScreen> createState() => _SmellySprayScreenState();
}

class _SmellySprayScreenState extends State<SmellySprayScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ticker;
  final List<_SprayCloud> _clouds = [];
  int _score = 0;
  int _lives = 3;
  int _level = 1;
  Timer? _spawnTimer;
  final Random _rand = Random();

  @override
  void initState() {
    super.initState();
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _ticker.addListener(_updateGame);
    _scheduleSpawn();
  }

  void _scheduleSpawn() {
    final delayMs = max(600, 2200 - _level * 200);
    _spawnTimer = Timer(Duration(milliseconds: delayMs), () {
      if (mounted && _lives > 0) {
        _spawnCloud();
        _scheduleSpawn();
      }
    });
  }

  void _spawnCloud() {
    final size = MediaQuery.of(context).size;
    final edge = _rand.nextInt(4);
    double x, y, vx, vy;
    final speed = 1.0 + _level * 0.3;

    if (edge == 0) {
      x = _rand.nextDouble() * size.width;
      y = -60;
      vx = (_rand.nextDouble() - 0.5) * speed;
      vy = speed;
    } else if (edge == 1) {
      x = size.width + 60;
      y = _rand.nextDouble() * size.height;
      vx = -speed;
      vy = (_rand.nextDouble() - 0.5) * speed;
    } else if (edge == 2) {
      x = _rand.nextDouble() * size.width;
      y = size.height + 60;
      vx = (_rand.nextDouble() - 0.5) * speed;
      vy = -speed;
    } else {
      x = -60;
      y = _rand.nextDouble() * size.height;
      vx = speed;
      vy = (_rand.nextDouble() - 0.5) * speed;
    }

    setState(() {
      _clouds.add(
        _SprayCloud(
          id: DateTime.now().microsecondsSinceEpoch,
          x: x,
          y: y,
          vx: vx,
          vy: vy,
          radius: 38 + _rand.nextDouble() * 22,
          hue: 70 + _rand.nextDouble() * 50,
        ),
      );
    });
  }

  void _updateGame() {
    if (!mounted || _lives <= 0) return;
    final size = MediaQuery.of(context).size;

    final toRemove = <int>[];
    for (final c in _clouds) {
      if (c.popping) {
        c.popProgress += 0.08;
        if (c.popProgress >= 1.0) toRemove.add(c.id);
      } else {
        c.x += c.vx;
        c.y += c.vy;
        c.wobble += 0.05;

        // Check escaped screen
        if (c.x < -100 || c.x > size.width + 100 || c.y < -100 || c.y > size.height + 100) {
          toRemove.add(c.id);
          _lives--;
          AudioService.instance.playDefeat();
          if (_lives <= 0) {
            _onGameOver();
            return;
          }
        }
      }
    }

    if (toRemove.isNotEmpty) {
      setState(() {
        _clouds.removeWhere((c) => toRemove.contains(c.id));
      });
    }
  }

  void _onTapCloud(TapDownDetails details) {
    final pos = details.localPosition;
    for (int i = _clouds.length - 1; i >= 0; i--) {
      final c = _clouds[i];
      if (c.popping) continue;
      final dist = (Offset(c.x, c.y) - pos).distance;
      if (dist <= c.radius * 1.2) {
        setState(() {
          c.popping = true;
          _score += 10;
          _level = min(10, (_score / 80).floor() + 1);
        });
        AudioService.instance.playSplat();
        break;
      }
    }
  }

  void _onGameOver() {
    _spawnTimer?.cancel();
    _ticker.stop();

    final gameState = GameStateProvider();
    gameState.submitScore(gameType: 'smelly', score: _score);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameOverScreen(
          missionName: 'Smelly Spray',
          score: _score,
          onReplay: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const SmellySprayScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
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
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A1128), Color(0xFF061040)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Interactive Gesture layer
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _onTapCloud,
            child: CustomPaint(
              size: Size.infinite,
              painter: _CloudPainter(_clouds),
            ),
          ),

          // HUD
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
                  Text(
                    '❤️' * _lives,
                    style: const TextStyle(fontSize: 22),
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

class _SprayCloud {
  final int id;
  double x;
  double y;
  final double vx;
  final double vy;
  final double radius;
  final double hue;
  double wobble = 0.0;
  bool popping = false;
  double popProgress = 0.0;

  _SprayCloud({
    required this.id,
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.hue,
  });
}

class _CloudPainter extends CustomPainter {
  final List<_SprayCloud> clouds;

  _CloudPainter(this.clouds);

  @override
  void paint(Canvas canvas, Size size) {
    for (final c in clouds) {
      final wobX = c.x + sin(c.wobble) * 6;
      final wobY = c.y + cos(c.wobble * 0.7) * 4;

      if (!c.popping) {
        final color = HSLColor.fromAHSL(0.9, c.hue, 0.75, 0.45).toColor();
        final paint = Paint()..color = color;

        canvas.drawCircle(Offset(wobX, wobY), c.radius, paint);
        canvas.drawCircle(Offset(wobX + c.radius * 0.5, wobY - c.radius * 0.3), c.radius * 0.6, paint);
        canvas.drawCircle(Offset(wobX - c.radius * 0.5, wobY - c.radius * 0.3), c.radius * 0.6, paint);

        // Skull icon
        final textPainter = TextPainter(
          text: TextSpan(
            text: '☠️',
            style: TextStyle(fontSize: c.radius * 0.8),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(canvas, Offset(wobX - textPainter.width / 2, wobY - textPainter.height / 2));
      } else {
        // Pop burst particles
        final prog = c.popProgress;
        final particlePaint = Paint()
          ..color = Colors.amber.withOpacity((1.0 - prog).clamp(0.0, 1.0));

        for (int i = 0; i < 8; i++) {
          final angle = (i / 8) * 2 * pi;
          final dist = prog * c.radius * 2.2;
          canvas.drawCircle(
            Offset(c.x + cos(angle) * dist, c.y + sin(angle) * dist),
            c.radius * 0.2 * (1.0 - prog),
            particlePaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CloudPainter oldDelegate) => true;
}
