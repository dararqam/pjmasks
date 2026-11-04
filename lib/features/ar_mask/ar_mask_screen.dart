import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../core/audio/audio_service.dart';
import '../../models/hero_character.dart';
import '../photo_studio/photo_studio_screen.dart';
import 'hero_mask_painter.dart';

class ArMaskScreen extends StatefulWidget {
  const ArMaskScreen({super.key});

  @override
  State<ArMaskScreen> createState() => _ArMaskScreenState();
}

class _ArMaskScreenState extends State<ArMaskScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  bool _hasCamera = false;
  HeroId _currentHero = HeroId.catboy;

  // Head tracking coordinates (normalized 0..1)
  double _headX = 0.5;
  double _headY = 0.45;
  double _tilt = 0.0;

  late final AnimationController _animController;
  bool _showFlash = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _hasCamera = true;
        });
      }
    } catch (e) {
      debugPrint('Camera init error (using interactive demo mode): $e');
    }
  }

  void _takePhoto() {
    AudioService.instance.playVictory();

    // Trigger visual shutter flash
    setState(() {
      _showFlash = true;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _showFlash = false;
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PhotoStudioScreen(
              heroId: _currentHero,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Stream or Simulation Background
          if (_hasCamera && _cameraController != null && _cameraController!.value.isInitialized)
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi), // Mirror front camera
              child: CameraPreview(_cameraController!),
            )
          else
            // Simulation Studio Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0A1638), Color(0xFF132863), Color(0xFF050C20)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: AnimatedBuilder(
                animation: _animController,
                builder: (context, _) {
                  // Natural subtle head floating
                  final floatingX = 0.5 + sin(_animController.value * 2 * pi) * 0.04;
                  final floatingY = 0.45 + cos(_animController.value * 2 * pi) * 0.02;

                  return CustomPaint(
                    size: Size.infinite,
                    painter: HeroMaskPainter(
                      heroId: _currentHero,
                      headX: _headX != 0.5 ? _headX : floatingX,
                      headY: _headY != 0.45 ? _headY : floatingY,
                      tilt: _tilt,
                      scale: 1.0,
                    ),
                  );
                },
              ),
            ),

          // Interactive gesture layer for touch/drag positioning
          GestureDetector(
            onPanUpdate: (details) {
              final size = MediaQuery.of(context).size;
              setState(() {
                _headX = (details.localPosition.dx / size.width).clamp(0.1, 0.9);
                _headY = (details.localPosition.dy / size.height).clamp(0.1, 0.9);
              });
            },
            child: Container(color: Colors.transparent),
          ),

          // Hero Mask Overlay (when camera active)
          if (_hasCamera)
            CustomPaint(
              size: Size.infinite,
              painter: HeroMaskPainter(
                heroId: _currentHero,
                headX: _headX,
                headY: _headY,
                tilt: _tilt,
                scale: 1.0,
              ),
            ),

          // Camera Flash Animation
          if (_showFlash)
            AnimatedOpacity(
              opacity: _showFlash ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: Container(color: Colors.white),
            ),

          // Top Back Button
          Positioned(
            top: 48,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),

          // Bottom AR Controls HUD
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Hero Selector Strip
                  Row(
                    children: HeroId.values.map((hId) {
                      final hero = HeroCharacter.fromId(hId);
                      final isSelected = _currentHero == hId;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentHero = hId;
                          });
                          AudioService.instance.playHeroSelect(hero.name);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black54,
                            border: Border.all(
                              color: isSelected ? hero.accentColor : Colors.white24,
                              width: isSelected ? 3.5 : 1.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: hero.accentColor.withOpacity(0.6),
                                      blurRadius: 16,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(hero.emoji, style: const TextStyle(fontSize: 24)),
                        ),
                      );
                    }).toList(),
                  ),

                  // Shutter Button
                  GestureDetector(
                    onTap: _takePhoto,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.white70, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.4),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.camera_alt, color: Color(0xFF050E28), size: 34),
                      ),
                    ),
                  ),

                  // Placeholder / Switcher
                  const SizedBox(width: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
