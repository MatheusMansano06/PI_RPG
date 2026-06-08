import 'package:flutter/material.dart';

// Titulo usado nas telas principais.
// Recebe um texto pequeno em cima, um titulo grande e, se precisar, uma descricao.
class GameSectionTitle extends StatelessWidget {
  const GameSectionTitle({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.icon = Icons.auto_stories,
    this.compact = false,
    this.textAlign = TextAlign.center,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool compact;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final alignCenter = textAlign == TextAlign.center;

    return Column(
      crossAxisAlignment: alignCenter
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // O icone ajuda a mostrar visualmente qual parte do jogo esta aberta.
        Icon(icon, color: const Color(0xFFF5C542), size: compact ? 34 : 42),
        SizedBox(height: compact ? 8 : 10),
        Text(
          eyebrow,
          textAlign: textAlign,
          style: const TextStyle(
            color: Color(0xFFBAE6FD),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: textAlign,
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 25 : 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: compact ? 8 : 10),
          Text(
            subtitle!,
            textAlign: textAlign,
            style: const TextStyle(
              color: Color(0xFFCBD5E1),
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
        const SizedBox(height: 12),
        // Linha simples so para separar o titulo do resto da tela.
        Container(height: 1, color: const Color(0xFF38BDF8)),
      ],
    );
  }
}
