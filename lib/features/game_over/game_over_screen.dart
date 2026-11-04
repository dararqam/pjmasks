import 'package:flutter/material.dart';
import '../../core/ads/cas_ad_service.dart';
import '../../core/audio/audio_service.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/cas_banner_ad_widget.dart';
import '../../widgets/pj_button.dart';
import '../../widgets/starfield_background.dart';
import '../menu/main_menu_screen.dart';

class GameOverScreen extends StatefulWidget {
  final String missionName;
  final int score;
  final VoidCallback onReplay;

  const GameOverScreen({
    super.key,
    required this.missionName,
    required this.score,
    required this.onReplay,
  });

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  late int _finalScore;
  bool _hasDoubled = false;

  @override
  void initState() {
    super.initState();
    _finalScore = widget.score;
    AudioService.instance.playVictory();
  }

  void _doubleScore() {
    CasAdService.instance.showRewarded(
      onRewarded: () {
        setState(() {
          _finalScore *= 2;
          _hasDoubled = true;
        });
        AudioService.instance.playVictory();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.green,
            content: Text('🎉 Score Doubled with Hero Power!'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final stars = _finalScore >= 80 ? 3 : (_finalScore >= 40 ? 2 : 1);

    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.missionName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                            color: AppColors.cyan,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'MISSION COMPLETE!',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: Colors.white,
                            shadows: [
                              Shadow(color: AppColors.cyan, blurRadius: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Stars
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                i < stars ? '★' : '☆',
                                style: const TextStyle(
                                  fontSize: 48,
                                  color: AppColors.yellow,
                                  shadows: [
                                    Shadow(color: AppColors.yellow, blurRadius: 18),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),

                        // Score Card
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.cyan.withOpacity(0.4)),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'SCORE',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: Colors.white60,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$_finalScore',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.yellow,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Double Score with Rewarded Ad Button
                        if (!_hasDoubled)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: PjButton(
                              text: '2X SCORE (WATCH AD)',
                              emoji: '🎁',
                              variant: PjButtonVariant.green,
                              onPressed: _doubleScore,
                            ),
                          ),

                        // Play Again & Menu
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 280),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              PjButton(
                                text: 'PLAY AGAIN',
                                emoji: '🔄',
                                variant: PjButtonVariant.blue,
                                onPressed: widget.onReplay,
                              ),
                              const SizedBox(height: 12),
                              PjButton(
                                text: 'MAIN MENU',
                                emoji: '🏠',
                                variant: PjButtonVariant.ghost,
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (_) => const MainMenuScreen(),
                                    ),
                                    (route) => false,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Banner Ad
              const CasBannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
