import 'package:flutter/material.dart';

import '../services/step_05_audio_manager.dart';

// Criamos 3 tipos de botao para nao precisar fazer um widget novo em cada tela.
// Primary fica para a acao principal, secondary para voltar/rotas e subtle para acoes menores.
enum GameButtonVariant { primary, secondary, subtle }

class GameButton extends StatelessWidget {
  const GameButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.variant = GameButtonVariant.primary,
    this.compact = false,
  });

  // Texto que aparece no botao.
  final String label;

  // Icone que aparece antes do texto.
  final IconData icon;

  // Funcao que vem da tela onde o botao foi chamado.
  // Exemplo: na tela do mapa ela abre a fase, na tela final ela volta para o mapa.
  final VoidCallback? onPressed;

  final GameButtonVariant variant;

  // Usamos compact quando a tela esta pequena, principalmente no celular.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final backgroundColor = _backgroundColor(enabled);
    final borderColor = _borderColor(enabled);
    final height = compact ? 46.0 : 54.0;

    return SizedBox(
      height: height,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: enabled
              ? () {
                  // Toca o som do clique antes de executar a funcao da tela.
                  AudioManager().playClick();
                  onPressed?.call();
                }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: compact ? 18 : 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 13 : 15,
                      fontWeight: FontWeight.bold,
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

  Color _backgroundColor(bool enabled) {
    if (!enabled) {
      return const Color(0xFF64748B);
    }

    if (variant == GameButtonVariant.primary) {
      return const Color(0xFF2563EB);
    }

    if (variant == GameButtonVariant.secondary) {
      return const Color(0xFF0F766E);
    }

    return const Color(0xFF172554);
  }

  Color _borderColor(bool enabled) {
    if (!enabled) {
      return const Color(0xFF94A3B8);
    }

    if (variant == GameButtonVariant.primary) {
      return const Color(0xFFF5C542);
    }

    return const Color(0xFF7DD3FC);
  }
}
