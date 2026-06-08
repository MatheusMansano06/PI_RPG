import 'package:flutter/material.dart';

// Card padrao do jogo.
// Ele serve para colocar conteudo em cima dos fundos com imagem sem ficar ilegivel.
class GameGlassCard extends StatelessWidget {
  const GameGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  // Conteudo que a tela manda para dentro do card.
  final Widget child;

  // Cada tela pode escolher um espacamento diferente.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        // Usamos cor escura com transparencia para parecer painel de jogo.
        color: const Color(0xDD07111F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF5C542), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

// Mantivemos GameCard como apelido porque varias telas ja chamavam esse nome.
class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return GameGlassCard(padding: padding, child: child);
  }
}
