import 'package:flutter/material.dart';
import '../core/audio/audio_service.dart';
import '../core/rate/rate_app_service.dart';
import '../core/theme/app_theme.dart';
import 'parent_gate_dialog.dart';
import 'pj_button.dart';

class RateAppDialog extends StatefulWidget {
  const RateAppDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const RateAppDialog(),
    );
  }

  /// Automatically shows the dialog if conditions in RateAppService are met
  static Future<void> checkAndShow(BuildContext context) async {
    final shouldShow = await RateAppService.instance.shouldPrompt();
    if (shouldShow && context.mounted) {
      show(context);
    }
  }

  @override
  State<RateAppDialog> createState() => _RateAppDialogState();
}

class _RateAppDialogState extends State<RateAppDialog> {
  int _selectedStars = 5;

  void _onRatePressed() {
    AudioService.instance.playVictory();
    Navigator.of(context).pop();

    if (_selectedStars >= 4) {
      // Require Parent Gate before taking children outside the app to store
      ParentGateDialog.show(
        context,
        onVerified: () {
          RateAppService.instance.openStoreReview();
        },
      );
    } else {
      RateAppService.instance.markAsRated();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.blue,
          content: Text('Thank you for your feedback! We will keep improving.'),
        ),
      );
    }
  }

  void _onLaterPressed() {
    RateAppService.instance.remindLater();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    String starLabel;
    switch (_selectedStars) {
      case 5:
        starLabel = 'Super Hero Power! ⚡';
        break;
      case 4:
        starLabel = 'Heroic Job! 🦸‍♂️';
        break;
      case 3:
        starLabel = 'Good Effort! 👍';
        break;
      default:
        starLabel = 'Needs More Training! 🎯';
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 380),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1E50),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.cyan.withOpacity(0.6), width: 3),
          boxShadow: [
            BoxShadow(
              color: AppColors.cyan.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mascot Icon Badge
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.yellow, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.yellow.withOpacity(0.4),
                    blurRadius: 18,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/app_icon.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 14),

            const Text(
              'ENJOYING THE MISSION?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: AppColors.yellow,
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              'Help Catboy, Owlette, and Gekko defeat the Night Villains by rating our game!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),

            // Star Rating Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starNum = index + 1;
                final isFilled = starNum <= _selectedStars;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStars = starNum;
                    });
                    AudioService.instance.playClick();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AnimatedScale(
                      scale: isFilled ? 1.15 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                        color: isFilled ? AppColors.yellow : Colors.white30,
                        size: 42,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),

            // Star Reaction Text
            Text(
              starLabel,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.cyan,
              ),
            ),
            const SizedBox(height: 22),

            // Buttons
            PjButton(
              text: _selectedStars >= 4 ? 'RATE ON STORE' : 'SUBMIT',
              emoji: _selectedStars >= 4 ? '⭐' : '💌',
              variant: PjButtonVariant.blue,
              onPressed: _onRatePressed,
            ),
            const SizedBox(height: 10),

            TextButton(
              onPressed: _onLaterPressed,
              child: const Text(
                'MAYBE LATER',
                style: TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
