import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ads/cas_config.dart';

class RateAppService {
  RateAppService._();
  static final RateAppService instance = RateAppService._();

  static const String _keyHasRated = 'rate_has_rated';
  static const String _keyNeverAsk = 'rate_never_ask';
  static const String _keyLaunchCount = 'rate_launch_count';
  static const String _keyGamesPlayed = 'rate_games_played';

  int _gamesPlayed = 0;
  int get gamesPlayed => _gamesPlayed;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final launches = (prefs.getInt(_keyLaunchCount) ?? 0) + 1;
    await prefs.setInt(_keyLaunchCount, launches);
    _gamesPlayed = prefs.getInt(_keyGamesPlayed) ?? 0;
  }

  Future<void> recordGameFinished() async {
    final prefs = await SharedPreferences.getInstance();
    _gamesPlayed = (prefs.getInt(_keyGamesPlayed) ?? 0) + 1;
    await prefs.setInt(_keyGamesPlayed, _gamesPlayed);
  }

  Future<bool> shouldPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    final hasRated = prefs.getBool(_keyHasRated) ?? false;
    final neverAsk = prefs.getBool(_keyNeverAsk) ?? false;
    if (hasRated || neverAsk) return false;

    // Prompt after 2 or more games played
    return _gamesPlayed >= 2;
  }

  Future<void> markAsRated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasRated, true);
  }

  Future<void> neverAskAgain() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNeverAsk, true);
  }

  Future<void> remindLater() async {
    final prefs = await SharedPreferences.getInstance();
    // Reset games count to prompt again after 3 more games
    await prefs.setInt(_keyGamesPlayed, 0);
    _gamesPlayed = 0;
  }

  Future<void> openStoreReview() async {
    await markAsRated();

    Uri url;
    if (!kIsWeb && Platform.isIOS) {
      // iOS App Store review link
      url = Uri.parse('https://apps.apple.com/app/id6830396196?action=write-review');
    } else {
      // Android Google Play link
      url = Uri.parse('https://play.google.com/store/apps/details?id=com.pjmasks.pj_masks');
    }

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }
}
