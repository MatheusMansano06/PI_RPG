import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

// Marcador visual do jogador no mapa.
// Ficou simples: um circulo azul com icone de aluno.
class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primary,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 4),
          Container(
            width: 28,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0x66000000),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
      ),
    );
  }
}
