import 'package:flutter/material.dart';
import '../models/hero_character.dart';
import '../features/ar_mask/hero_mask_painter.dart';

class HeroCard extends StatelessWidget {
  final HeroCharacter hero;
  final bool isSelected;
  final bool isUnlocked;
  final VoidCallback onTap;
  final VoidCallback onUnlockWithAd;

  const HeroCard({
    super.key,
    required this.hero,
    required this.isSelected,
    required this.isUnlocked,
    required this.onTap,
    required this.onUnlockWithAd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : onUnlockWithAd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 170,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? hero.accentColor
                : (isUnlocked ? Colors.white24 : Colors.white10),
            width: isSelected ? 3.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: hero.accentColor.withOpacity(0.4),
                    blurRadius: 22,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mask preview
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: CustomPaint(
                      painter: HeroMaskPainter(
                        heroId: hero.id,
                        headX: 0.5,
                        headY: 0.5,
                        scale: 0.85,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hero.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: hero.accentColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hero.superpower,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // Lock Badge overlay
            if (!isUnlocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_rounded, color: Colors.amber, size: 36),
                      const SizedBox(height: 6),
                      Text(
                        'Unlock: ${hero.unlockScoreRequired} pts',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_circle_filled, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Watch Ad',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
