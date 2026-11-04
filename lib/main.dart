import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/ads/cas_ad_service.dart';
import 'core/audio/audio_service.dart';
import 'core/rate/rate_app_service.dart';
import 'core/theme/app_theme.dart';
import 'features/intro/intro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize CAS.AI Mobile Ads Mediation with all adapters
  await CasAdService.instance.initialise();

  // Initialize Audio Engine
  await AudioService.instance.init();

  // Initialize Rate App tracking
  await RateAppService.instance.init();

  // Set system UI style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.night,
    ),
  );

  runApp(const PJMasksApp());
}

class PJMasksApp extends StatelessWidget {
  const PJMasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PJ Masks: Time To Be A Hero VR',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const IntroScreen(),
    );
  }
}
