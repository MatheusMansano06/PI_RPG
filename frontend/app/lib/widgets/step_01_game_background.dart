import 'package:flutter/material.dart';

// Fundo usado em varias telas.
// A ideia e simples: coloca uma imagem ocupando a tela e depois joga uma sombra por cima,
// porque sem essa sombra os textos brancos ficam dificeis de ler.
class GameBackground extends StatelessWidget {
  const GameBackground({
    super.key,
    required this.child,
    this.imagePath = 'assets/images/backgrounds/login_campus.png',
    this.fallbackImagePath = 'assets/images/backgrounds/login_campus.png',
  });

  // Widget que a tela coloca por cima do fundo.
  final Widget child;

  // Imagem principal da tela.
  final String imagePath;

  // Imagem reserva caso a principal nao carregue.
  final String fallbackImagePath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: const Color(0xFF06142D)),
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) {
            return Image.asset(
              fallbackImagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            );
          },
        ),

        // Camada escura para deixar a leitura melhor.
        Container(color: Colors.black.withValues(alpha: 0.58)),
        child,
      ],
    );
  }
}
