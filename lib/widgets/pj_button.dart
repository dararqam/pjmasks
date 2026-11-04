import 'package:flutter/material.dart';
import '../core/audio/audio_service.dart';

enum PjButtonVariant { blue, hero, yellow, green, ghost }

class PjButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final PjButtonVariant variant;
  final IconData? icon;
  final String? emoji;

  const PjButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = PjButtonVariant.blue,
    this.icon,
    this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors;
    Color textColor = Colors.white;
    Color glowColor;

    switch (variant) {
      case PjButtonVariant.blue:
        gradientColors = const [Color(0xFF0080FF), Color(0xFF0044CC)];
        glowColor = const Color(0xFF0066FF).withOpacity(0.4);
        break;
      case PjButtonVariant.hero:
        gradientColors = const [Color(0xFFFF1A53), Color(0xFF880022)];
        glowColor = const Color(0xFFFF1A53).withOpacity(0.4);
        break;
      case PjButtonVariant.yellow:
        gradientColors = const [Color(0xFFFFDD00), Color(0xFFCC8800)];
        textColor = Colors.black;
        glowColor = const Color(0xFFFFCC00).withOpacity(0.4);
        break;
      case PjButtonVariant.green:
        gradientColors = const [Color(0xFF00CC44), Color(0xFF006622)];
        glowColor = const Color(0xFF00CC44).withOpacity(0.4);
        break;
      case PjButtonVariant.ghost:
        gradientColors = [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)];
        glowColor = Colors.transparent;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: glowColor,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            AudioService.instance.playClick();
            onPressed();
          },
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              border: variant == PjButtonVariant.ghost
                  ? Border.all(color: Colors.white24, width: 2)
                  : Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (emoji != null) ...[
                  Text(emoji!, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                ] else if (icon != null) ...[
                  Icon(icon, color: textColor, size: 22),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
