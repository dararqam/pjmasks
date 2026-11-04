import 'package:flutter/material.dart';
import '../../core/audio/audio_service.dart';
import '../../core/providers/game_state_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/cas_banner_ad_widget.dart';
import '../../widgets/parent_gate_dialog.dart';
import '../../widgets/pj_button.dart';
import '../../widgets/rate_app_dialog.dart';
import '../../widgets/starfield_background.dart';
import '../ar_mask/ar_mask_screen.dart';
import '../game_select/game_select_screen.dart';
import '../hero_select/hero_select_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final GameStateProvider _gameState = GameStateProvider();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RateAppDialog.checkAndShow(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        AudioService.instance.isMuted
                            ? Icons.volume_off
                            : Icons.volume_up,
                        color: Colors.white70,
                        size: 28,
                      ),
                      onPressed: () {
                        setState(() {
                          AudioService.instance.toggleMute();
                        });
                      },
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.star_rate_rounded, color: AppColors.yellow, size: 30),
                          tooltip: 'Rate App',
                          onPressed: () => RateAppDialog.show(context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white70, size: 28),
                          onPressed: () {
                            ParentGateDialog.show(
                              context,
                              onVerified: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Settings Verified')),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Hero Logo & Title
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // App Icon
                        Hero(
                          tag: 'hero-app-icon',
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.cyan.withOpacity(0.5),
                                  blurRadius: 28,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/app_icon.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'PJ MASKS',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                            color: AppColors.cyan,
                            shadows: [
                              Shadow(color: AppColors.cyan, blurRadius: 24),
                            ],
                          ),
                        ),
                        const Text(
                          'TIME TO BE A HERO',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 6,
                            color: AppColors.yellow,
                            shadows: [
                              Shadow(color: AppColors.yellow, blurRadius: 16),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Action Buttons
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              PjButton(
                                text: 'PLAY MINI-GAMES',
                                emoji: '🎮',
                                variant: PjButtonVariant.blue,
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const GameSelectScreen(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 14),
                              PjButton(
                                text: 'AR HERO MASK',
                                emoji: '📷',
                                variant: PjButtonVariant.hero,
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const ArMaskScreen(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 14),
                              PjButton(
                                text: 'CHOOSE HERO',
                                emoji: '⭐',
                                variant: PjButtonVariant.yellow,
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const HeroSelectScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),

                        // Total Score Display
                        AnimatedBuilder(
                          animation: _gameState,
                          builder: (context, _) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.cyan.withOpacity(0.3)),
                              ),
                              child: Text(
                                'TOTAL SCORE: ${_gameState.totalScore}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2,
                                  color: AppColors.cyan,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom CAS.AI Banner Ad
              const CasBannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
