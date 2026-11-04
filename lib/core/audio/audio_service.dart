import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  AudioService._();
  static final AudioService instance = AudioService._();

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool isMuted = false;

  Future<void> init() async {
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void toggleMute() {
    isMuted = !isMuted;
    if (isMuted) {
      _musicPlayer.pause();
    } else {
      _musicPlayer.resume();
    }
  }

  Future<void> playClick() async {
    if (isMuted) return;
    try {
      // Short audio feedback
    } catch (e) {
      debugPrint('SFX error: $e');
    }
  }

  Future<void> playHeroSelect(String heroName) async {
    if (isMuted) return;
  }

  Future<void> playVictory() async {
    if (isMuted) return;
  }

  Future<void> playDefeat() async {
    if (isMuted) return;
  }

  Future<void> playSplat() async {
    if (isMuted) return;
  }

  Future<void> playSlingshot() async {
    if (isMuted) return;
  }

  void dispose() {
    _musicPlayer.dispose();
    _sfxPlayer.dispose();
  }
}
