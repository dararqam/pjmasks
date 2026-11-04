import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/cas_banner_ad_widget.dart';
import '../../widgets/starfield_background.dart';
import '../games/pull_battle/pull_battle_screen.dart';
import '../games/romeo_shoot/romeo_shoot_screen.dart';
import '../games/smelly_spray/smelly_spray_screen.dart';

class GameSelectScreen extends StatelessWidget {
  const GameSelectScreen({super.key});

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
                          'CHOOSE A MISSION',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: AppColors.yellow,
                          ),
                        ),
                        Text(
                          'Defeat the Night Villains and Save the Day!',
                          style: TextStyle(fontSize: 12, color: Colors.white60),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Game Cards List
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _gameCard(
                          context,
                          title: 'SMELLY SPRAY',
                          description: "Clean up Romeo's stinky green clouds before they spread!",
                          emoji: '☠️',
                          accentColor: const Color(0xFF00CC44),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SmellySprayScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _gameCard(
                          context,
                          title: "LUNA'S PULL",
                          description: 'Out-pull Luna Girl in a high-powered moonbeam tug-of-war!',
                          emoji: '🌙',
                          accentColor: const Color(0xFF9933FF),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PullBattleScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _gameCard(
                          context,
                          title: "ROMEO'S ROBOTS",
                          description: 'Slingshot hero projectiles to blast flying villain drones!',
                          emoji: '🤖',
                          accentColor: const Color(0xFFFF3300),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RomeoShootScreen(),
                              ),
                            );
                          },
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

  Widget _gameCard(
    BuildContext context, {
    required String title,
    required String description,
    required String emoji,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withOpacity(0.6), width: 2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.2),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: accentColor.withOpacity(0.4)),
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 34)),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: accentColor,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.play_circle_fill, color: Colors.white70, size: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
