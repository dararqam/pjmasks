// lib/core/ads/cas_config.dart
// ─────────────────────────────────────────────────────────────────────────────
// CAS.AI (Clever Ads Solutions) Configuration
// All 25+ network adapters are managed via the CAS Gradle plugin (Android)
// and CAS.podspec (iOS). No per-network pub packages are required.
//
// Supported adapter networks (configured via cas.ai dashboard):
//   AppLovin · Meta Audience Network · Google AdMob · IronSource · Unity Ads
//   Mintegral · Pangle (TikTok) · Chartboost · InMobi · Vungle (Liftoff)
//   Ogury · Start.io · Bidease · Bigo Ads · Maticoo · Moloco · Monetrix
//   Fyber · HyprMX · PubMatic · Smaato · Yango Ads · Display.IO · Kidoz
//   SuperAwesome · BlueSea + 150+ programmatic DSPs via RTB
// ─────────────────────────────────────────────────────────────────────────────

/// Replace with your real CAS App ID from https://cas.ai dashboard
const String kCasAppId = '6830396196';

/// App Store ID used by CAS for iOS attribution
const String kCasIosAppId = '6830396196';

/// Use test mode during development — set false before submitting to stores
const bool kCasTestMode = true;

/// Ad unit types this app enables
/// CAS will fill from whichever networks have available demand
const List<String> kCasAdFormats = [
  'interstitial', // Full-screen between game sessions
  'rewarded',     // Rewarded video to unlock heroes or earn coins
  'banner',       // Optional: sticky banner on non-gameplay screens
  'appOpen',      // Cold-start app open ads
];
