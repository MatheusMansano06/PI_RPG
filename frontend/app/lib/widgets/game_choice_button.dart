import 'package:flutter/material.dart';

enum GameChoiceState { idle, correct, wrong }

class GameChoiceButton extends StatelessWidget {
  const GameChoiceButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.state = GameChoiceState.idle,
    this.icon = Icons.chat_bubble_outline,
  });

  final String label;
  final VoidCallback? onPressed;
  final GameChoiceState state;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final color = switch (state) {
      GameChoiceState.correct => const Color(0xFF22C55E),
      GameChoiceState.wrong => const Color(0xFFEF4444),
      GameChoiceState.idle => const Color(0xFF38BDF8),
    };
    final stateIcon = switch (state) {
      GameChoiceState.correct => Icons.check_circle,
      GameChoiceState.wrong => Icons.cancel,
      GameChoiceState.idle => icon,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Container(
            constraints: const BoxConstraints(minHeight: 58),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withValues(
                  alpha: state == GameChoiceState.idle ? 0.36 : 0.78,
                ),
                width: state == GameChoiceState.idle ? 1 : 1.5,
              ),
              boxShadow: [
                if (state != GameChoiceState.idle)
                  BoxShadow(
                    color: color.withValues(alpha: 0.16),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
              ],
            ),
            child: Row(
              children: [
                Icon(stateIcon, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      height: 1.25,
                      fontWeight: FontWeight.w800,
                    ),
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
