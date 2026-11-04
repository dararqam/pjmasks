import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/hero_character.dart';
import '../ads/cas_ad_service.dart';
import '../rate/rate_app_service.dart';

class GameStateProvider extends ChangeNotifier {
  HeroId _selectedHero = HeroId.catboy;
  final Set<HeroId> _unlockedHeroes = {HeroId.catboy};
  int _smellyScore = 0;
  int _pullScore = 0;
  int _shootScore = 0;
  int _totalScore = 0;

  HeroId get selectedHero => _selectedHero;
  Set<HeroId> get unlockedHeroes => _unlockedHeroes;
  int get smellyScore => _smellyScore;
  int get pullScore => _pullScore;
  int get shootScore => _shootScore;
  int get totalScore => _totalScore;

  HeroCharacter get currentHeroCharacter => HeroCharacter.fromId(_selectedHero);

  GameStateProvider() {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final heroIndex = prefs.getInt('selected_hero') ?? 0;
    _selectedHero = HeroId.values[heroIndex.clamp(0, HeroId.values.length - 1)];

    final unlockedList = prefs.getStringList('unlocked_heroes') ?? ['catboy'];
    _unlockedHeroes.clear();
    for (final idStr in unlockedList) {
      if (idStr == 'catboy') _unlockedHeroes.add(HeroId.catboy);
      if (idStr == 'owlette') _unlockedHeroes.add(HeroId.owlette);
      if (idStr == 'gekko') _unlockedHeroes.add(HeroId.gekko);
    }

    _smellyScore = prefs.getInt('smelly_score') ?? 0;
    _pullScore = prefs.getInt('pull_score') ?? 0;
    _shootScore = prefs.getInt('shoot_score') ?? 0;
    _totalScore = _smellyScore + _pullScore + _shootScore;

    notifyListeners();
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_hero', _selectedHero.index);
    await prefs.setStringList(
      'unlocked_heroes',
      _unlockedHeroes.map((h) => h.name).toList(),
    );
    await prefs.setInt('smelly_score', _smellyScore);
    await prefs.setInt('pull_score', _pullScore);
    await prefs.setInt('shoot_score', _shootScore);
  }

  void selectHero(HeroId hero) {
    if (_unlockedHeroes.contains(hero)) {
      _selectedHero = hero;
      _saveState();
      notifyListeners();
    }
  }

  bool isHeroUnlocked(HeroId hero) => _unlockedHeroes.contains(hero);

  void unlockHeroWithReward(HeroId hero) {
    _unlockedHeroes.add(hero);
    _selectedHero = hero;
    _saveState();
    notifyListeners();
  }

  /// Called when a mini-game finishes
  void submitScore({required String gameType, required int score}) {
    if (gameType == 'smelly') {
      if (score > _smellyScore) _smellyScore = score;
    } else if (gameType == 'pull') {
      if (score > _pullScore) _pullScore = score;
    } else if (gameType == 'shoot') {
      if (score > _shootScore) _shootScore = score;
    }

    _totalScore = _smellyScore + _pullScore + _shootScore;

    // Check automatic unlocks
    if (!_unlockedHeroes.contains(HeroId.owlette) && _totalScore >= 50) {
      _unlockedHeroes.add(HeroId.owlette);
    }
    if (!_unlockedHeroes.contains(HeroId.gekko) && _totalScore >= 100) {
      _unlockedHeroes.add(HeroId.gekko);
    }

    _saveState();
    notifyListeners();

    // Track game completion for ratings prompt
    RateAppService.instance.recordGameFinished();

    // Show CAS.AI Interstitial ad on game completion
    CasAdService.instance.showInterstitial();
  }
}
