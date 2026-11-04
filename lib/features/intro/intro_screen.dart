import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../menu/main_menu_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    try {
      _controller = VideoPlayerController.asset('assets/videos/intro.mp4');
      _controller!.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller!.play();
        }
      }).catchError((e) {
        debugPrint('Video player error: $e');
      });
      _controller!.addListener(() {
        if (_controller != null &&
            _controller!.value.position >= _controller!.value.duration) {
          _proceedToMenu();
        }
      });
    } catch (e) {
      debugPrint('Video init exception: $e');
    }
  }

  void _proceedToMenu() {
    if (!mounted) return;
    _controller?.pause();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainMenuScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_isInitialized && _controller != null)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.cyan),
            ),
          // Skip Button
          Positioned(
            bottom: 30,
            right: 24,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black54,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.white30),
                ),
              ),
              onPressed: _proceedToMenu,
              icon: const Icon(Icons.skip_next, size: 22),
              label: const Text(
                'SKIP',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
