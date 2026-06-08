import 'package:flutter/material.dart';

// Camada simples de "nuvens" usada na splash e no login.
// Antes tinha animacao e blur; deixamos parado para ficar mais facil de entender.
class CinematicCloudLayer extends StatelessWidget {
  const CinematicCloudLayer({super.key, this.opacity = 0.32, this.speed = 1});

  final double opacity;

  // Mantemos speed porque as telas antigas ja mandam esse valor.
  // Agora ele nao muda nada, mas evita quebrar chamadas.
  final double speed;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          _CloudCircle(left: 20, top: 70, size: 180, opacity: opacity),
          _CloudCircle(right: 30, top: 140, size: 150, opacity: opacity * 0.8),
          _CloudCircle(left: 80, bottom: 90, size: 220, opacity: opacity * 0.7),
          _CloudCircle(
            right: 70,
            bottom: 60,
            size: 160,
            opacity: opacity * 0.6,
          ),
        ],
      ),
    );
  }
}

class _CloudCircle extends StatelessWidget {
  const _CloudCircle({
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.size,
    required this.opacity,
  });

  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: opacity),
        ),
      ),
    );
  }
}
