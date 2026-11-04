import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'pj_button.dart';

class ParentGateDialog extends StatefulWidget {
  final VoidCallback onVerified;

  const ParentGateDialog({super.key, required this.onVerified});

  static Future<void> show(BuildContext context, {required VoidCallback onVerified}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ParentGateDialog(onVerified: onVerified),
    );
  }

  @override
  State<ParentGateDialog> createState() => _ParentGateDialogState();
}

class _ParentGateDialogState extends State<ParentGateDialog> {
  late int num1;
  late int num2;
  late int correctAnswer;
  final TextEditingController _controller = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    final rand = Random();
    num1 = rand.nextInt(8) + 4; // 4..11
    num2 = rand.nextInt(8) + 3; // 3..10
    correctAnswer = num1 + num2;
  }

  void _verify() {
    final entered = int.tryParse(_controller.text.trim());
    if (entered == correctAnswer) {
      Navigator.of(context).pop();
      widget.onVerified();
    } else {
      setState(() {
        errorMessage = 'Incorrect, please try again.';
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(28),
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1E50),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.cyan.withOpacity(0.5), width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '👨‍👩‍👧 Grown-Ups Area',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.cyan,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please solve the maths problem to continue:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Text(
              'What is $num1 + $num2 ?',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: AppColors.yellow,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              autofocus: true,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black38,
                hintText: 'Answer',
                hintStyle: const TextStyle(color: Colors.white30, fontSize: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.cyan),
                ),
              ),
              onSubmitted: (_) => _verify(),
            ),
            if (errorMessage.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                errorMessage,
                style: const TextStyle(color: AppColors.red, fontSize: 13),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: PjButton(
                    text: 'Cancel',
                    variant: PjButtonVariant.ghost,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PjButton(
                    text: 'Verify',
                    variant: PjButtonVariant.blue,
                    onPressed: _verify,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
