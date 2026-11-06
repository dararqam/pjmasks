// lib/core/ads/cas_ad_service.dart
import 'dart:async';
import 'package:clever_ads_solutions/clever_ads_solutions.dart';
import 'package:flutter/foundation.dart';
import 'cas_config.dart';

/// Singleton service that manages the CAS.AI mediation SDK lifecycle:
///   • Initialization with all demand adapters (AdMob, Meta, AppLovin, Unity, IronSource, Mintegral, etc.)
///   • Interstitial ads (between mini-game sessions)
///   • Rewarded video ads (to unlock heroes or double points)
///   • Banner ads (persistent on menus)
class CasAdService {
  CasAdService._();
  static final CasAdService instance = CasAdService._();

  bool _isInitialised = false;
  bool get isInitialised => _isInitialised;

  CASInterstitial? _interstitial;
  CASRewarded? _rewarded;
  CASBanner? _banner;

  bool _interstitialLoaded = false;
  bool _rewardedLoaded = false;

  void Function()? onRewardEarned;
  void Function()? onInterstitialDismissed;

  /// Initialize the CAS.AI SDK
  Future<void> initialise() async {
    if (_isInitialised) return;

    try {
      // Child-directed strictly compliant configuration:
      // - Audience.children ensures COPPA compliance and disables personalized tracking
      // - showConsentFormIfRequired set to false to prevent tracking/consent prompts
      final status = await CASMobileAds.initialize(
        casId: kCasAppId,
        forceTestAds: kCasTestMode,
        targetAudience: Audience.children,
        showConsentFormIfRequired: false,
      );

      debugPrint('[CAS.AI] Initialized successfully: error=${status.error}, country=${status.countryCode}');
      _isInitialised = true;

      _initInterstitial();
      _initRewarded();
      _initBanner();
    } catch (e) {
      debugPrint('[CAS.AI] Initialization error: $e');
    }
  }

  void _initInterstitial() {
    _interstitial = CASInterstitial.createAndLoad(
      autoReload: true,
      onAdLoaded: (AdInstance ad) {
        _interstitialLoaded = true;
        debugPrint('[CAS.AI] Interstitial ad loaded');
      },
      onAdFailedToLoad: (AdInstance ad, AdError error) {
        _interstitialLoaded = false;
        debugPrint('[CAS.AI] Interstitial failed to load: ${error.message}');
      },
      onAdDismissed: (AdScreenInstance screenAd) {
        _interstitialLoaded = false;
        onInterstitialDismissed?.call();
        onInterstitialDismissed = null;
      },
    );
  }

  void _initRewarded() {
    _rewarded = CASRewarded.createAndLoad(
      autoReload: true,
      extraFillByInterstitialAd: true,
      onAdLoaded: (AdInstance ad) {
        _rewardedLoaded = true;
        debugPrint('[CAS.AI] Rewarded ad loaded');
      },
      onAdFailedToLoad: (AdInstance ad, AdError error) {
        _rewardedLoaded = false;
        debugPrint('[CAS.AI] Rewarded failed to load: ${error.message}');
      },
      onUserEarnedReward: (AdScreenInstance screenAd) {
        debugPrint('[CAS.AI] User earned reward!');
        onRewardEarned?.call();
        onRewardEarned = null;
      },
      onAdDismissed: (AdScreenInstance screenAd) {
        _rewardedLoaded = false;
      },
    );
  }

  void _initBanner() {
    _banner = CASBanner.createAndLoad(
      size: AdSize.banner,
      autoReload: true,
      onAdLoaded: (AdViewInstance ad) {
        debugPrint('[CAS.AI] Banner ad loaded');
      },
      onAdFailedToLoad: (AdInstance ad, AdError error) {
        debugPrint('[CAS.AI] Banner failed to load: ${error.message}');
      },
    );
  }

  /// Show an interstitial ad if available
  Future<void> showInterstitial({void Function()? onClosed}) async {
    if (_interstitial == null || !_interstitialLoaded) {
      debugPrint('[CAS.AI] Interstitial not ready — continuing directly');
      onClosed?.call();
      return;
    }
    onInterstitialDismissed = onClosed;
    await _interstitial!.show();
  }

  /// Show a rewarded video ad
  Future<void> showRewarded({required void Function() onRewarded}) async {
    if (_rewarded == null || !_rewardedLoaded) {
      debugPrint('[CAS.AI] Rewarded ad not ready');
      return;
    }
    onRewardEarned = onRewarded;
    await _rewarded!.show();
  }

  bool get isRewardedReady => _rewardedLoaded;

  /// Returns the banner instance for the banner widget
  CASBanner? get banner => _banner;
}
