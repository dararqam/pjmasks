import 'package:flutter/material.dart';
import '../../core/ads/cas_ad_service.dart';
import '../../core/audio/audio_service.dart';
import '../../core/providers/game_state_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/hero_character.dart';
import '../../widgets/hero_card.dart';
import '../../widgets/starfield_background.dart';

class HeroSelectScreen extends StatefulWidget {
  const HeroSelectScreen({super.key});

  @override
  State<HeroSelectScreen> createState() => _HeroSelectScreenState();
}

class _HeroSelectScreenState extends State<HeroSelectScreen> {
  final GameStateProvider _gameState = GameStateProvider();

  void _onUnlockWithAd(HeroCharacter hero) {
    CasAdService.instance.showRewarded(
      onRewarded: () {
        _gameState.unlockHeroWithReward(hero.id);
        AudioService.instance.playVictory();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: hero.primaryColor,
            content: Text(
              '🎉 ${hero.name} Unlocked! Time to be a hero!',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CHOOSE YOUR HERO',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: AppColors.yellow,
                          ),
                        ),
                        Text(
                          'Score 50 pts for Owlette · 100 pts for Gekko',
                          style: TextStyle(fontSize: 12, color: Colors.white60),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Hero Cards List
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AnimatedBuilder(
                      animation: _gameState,
                      builder: (context, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: HeroCharacter.all.map((hero) {
                            final isSelected = _gameState.selectedHero == hero.id;
                            final isUnlocked = _gameState.isHeroUnlocked(hero.id);

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: HeroCard(
                                hero: hero,
                                isSelected: isSelected,
                                isUnlocked: isUnlocked,
                                onTap: () {
                                  _gameState.selectHero(hero.id);
                                  AudioService.instance.playHeroSelect(hero.name);
                                },
                                onUnlockWithAd: () => _onUnlockWithAd(hero),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
