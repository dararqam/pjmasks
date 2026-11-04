import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/providers/game_state_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../game_over/game_over_screen.dart';

class PullBattleScreen extends StatefulWidget {
  const PullBattleScreen({super.key});

  @override
  State<PullBattleScreen> createState() => _PullBattleScreenState();
}

class _PullBattleScreenState extends State<PullBattleScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ticker;
  double _ropePos = 0.5; // 0.0 (enemy wins) .. 1.0 (player wins)
  double _playerPower = 0.0;
  double _enemyPower = 0.3;
  int _secondsLeft = 30;
  int _score = 0;
  int _frameCount = 0;

  @override
  void initState() {
    super.initState();
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _ticker.addListener(_updatePhysics);
  }

  void _onPullTap() {
    setState(() {
      _playerPower = (_playerPower + 0.16).clamp(0.0, 1.0);
    });
    AudioService.instance.playSlingshot();
  }

  void _updatePhysics() {
    _frameCount++;
    if (_frameCount % 60 == 0 && _secondsLeft > 0) {
      setState(() {
        _secondsLeft--;
      });
      if (_secondsLeft <= 0) {
        _endGame(_ropePos >= 0.5);
        return;
      }
    }

    final enemyRamp = 0.25 + ((30 - _secondsLeft) / 30.0) * 0.45;
    _enemyPower = enemyRamp + sin(_frameCount * 0.05) * 0.08;

    final net = _playerPower - _enemyPower;
    _ropePos = (_ropePos + net * 0.0035).clamp(0.0, 1.0);

    // Decay power
    _playerPower *= 0.88;

    if (_ropePos >= 1.0) {
      _endGame(true);
    } else if (_ropePos <= 0.0) {
      _endGame(false);
    }

    setState(() {});
  }

  void _endGame(bool won) {
    _ticker.stop();
    _score = won ? (100 + _secondsLeft * 4) : (_ropePos * 60).round();

    final gameState = GameStateProvider();
    gameState.submitScore(gameType: 'pull', score: _score);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameOverScreen(
          missionName: "Luna's Pull Battle",
          score: _score,
          onReplay: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const PullBattleScreen()),
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
          // Background Night City Skyline
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A0428), Color(0xFF150A50), Color(0xFF06021A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Tug-of-war custom painter
          CustomPaint(
            size: Size.infinite,
            painter: _PullBattlePainter(
              ropePos: _ropePos,
              frameCount: _frameCount,
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
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '⏱️ $_secondsLeft s',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: _secondsLeft <= 5 ? Colors.redAccent : AppColors.yellow,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          // Bottom Tap-to-Pull Button
          Positioned(
            bottom: 36,
            left: 36,
            right: 36,
            child: GestureDetector(
              onTapDown: (_) => _onPullTap(),
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00D4FF), Color(0xFF0052CC)],
                  ),
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyan.withOpacity(0.5),
                      blurRadius: 24,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '⚡ TAP RAPIDLY TO PULL! ⚡',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PullBattlePainter extends CustomPainter {
  final double ropePos;
  final int frameCount;

  _PullBattlePainter({required this.ropePos, required this.frameCount});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final groundY = h * 0.62;

    // Ground Line
    canvas.drawLine(
      Offset(0, groundY),
      Offset(w, groundY),
      Paint()
        ..color = const Color(0xFF6644CC)
        ..strokeWidth = 3,
    );

    final midX = ropePos * w;

    // Draw Luna Girl on Left
    final enemyX = max(60.0, midX - 110.0);
    _drawCharacter(canvas, enemyX, groundY, isHero: false);

    // Draw Catboy Hero on Right
    final heroX = min(w - 60.0, midX + 110.0);
    _drawCharacter(canvas, heroX, groundY, isHero: true);

    // Draw Energy Rope
    final ropePaint = Paint()
      ..color = const Color(0xFFFF9900)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    final ropePath = Path();
    ropePath.moveTo(enemyX + 30, groundY - 30);
    ropePath.quadraticBezierTo(
      midX,
      groundY - 10 + sin(frameCount * 0.1) * 8,
      heroX - 30,
      groundY - 30,
    );
    canvas.drawPath(ropePath, ropePaint);

    // Center Ribbon Marker
    canvas.drawCircle(
      Offset(midX, groundY - 18),
      10,
      Paint()..color = Colors.red,
    );
  }

  void _drawCharacter(Canvas canvas, double x, double groundY, {required bool isHero}) {
    final headColor = isHero ? const Color(0xFF0041CC) : const Color(0xFF8800CC);
    final bodyColor = isHero ? const Color(0xFF002699) : const Color(0xFF550088);

    // Body
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, groundY - 45), width: 34, height: 50),
      Paint()..color = bodyColor,
    );

    // Head
    canvas.drawCircle(
      Offset(x, groundY - 80),
      22,
      Paint()..color = headColor,
    );

    // Eyes
    final eyePaint = Paint()..color = isHero ? const Color(0xFF00F0FF) : Colors.amber;
    canvas.drawCircle(Offset(x - 6, groundY - 82), 4, eyePaint);
    canvas.drawCircle(Offset(x + 6, groundY - 82), 4, eyePaint);
  }

  @override
  bool shouldRepaint(covariant _PullBattlePainter oldDelegate) => true;
}
