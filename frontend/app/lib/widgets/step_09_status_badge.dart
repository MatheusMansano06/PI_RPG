import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

// Etiqueta pequena para mostrar status: sucesso, aviso, erro ou neutro.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.icon,
    required this.tone,
  });

  final String label;
  final IconData icon;
  final StatusBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    // Escolhemos a cor com if para ficar mais facil de entender.
    Color color = AppTheme.muted;
    if (tone == StatusBadgeTone.success) {
      color = AppTheme.success;
    }
    if (tone == StatusBadgeTone.warning) {
      color = AppTheme.accent;
    }
    if (tone == StatusBadgeTone.error) {
      color = AppTheme.danger;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

enum StatusBadgeTone { success, warning, error, neutral }
