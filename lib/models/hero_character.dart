import 'package:flutter/material.dart';

enum HeroId { catboy, owlette, gekko }

class HeroCharacter {
  final HeroId id;
  final String name;
  final String superpower;
  final String emoji;
  final Color primaryColor;
  final Color accentColor;
  final int unlockScoreRequired;

  const HeroCharacter({
    required this.id,
    required this.name,
    required this.superpower,
    required this.emoji,
    required this.primaryColor,
    required this.accentColor,
    required this.unlockScoreRequired,
  });

  static const List<HeroCharacter> all = [
    HeroCharacter(
      id: HeroId.catboy,
      name: 'Catboy',
      superpower: 'Super Cat Speed!',
      emoji: '🐱',
      primaryColor: Color(0xFF0041CC),
      accentColor: Color(0xFF00F0FF),
      unlockScoreRequired: 0, // Unlocked by default
    ),
    HeroCharacter(
      id: HeroId.owlette,
      name: 'Owlette',
      superpower: 'Super Owl Wings!',
      emoji: '🦉',
      primaryColor: Color(0xFFCC0033),
      accentColor: Color(0xFFFFCC00),
      unlockScoreRequired: 50,
    ),
    HeroCharacter(
      id: HeroId.gekko,
      name: 'Gekko',
      superpower: 'Super Gekko Muscles!',
      emoji: '🦎',
      primaryColor: Color(0xFF00802B),
      accentColor: Color(0xFF66FF99),
      unlockScoreRequired: 100,
    ),
  ];

  static HeroCharacter fromId(HeroId id) {
    return all.firstWhere((h) => h.id == id, orElse: () => all.first);
  }
}
