import 'package:flutter/material.dart';

class GameBackground extends StatelessWidget {
  const GameBackground({
    super.key,
    required this.child,
    this.imagePath = 'assets/images/backgrounds/login_campus.png',
    this.fallbackImagePath = 'assets/images/backgrounds/login_campus.png',
  });

  final Widget child;
  final String imagePath;
  final String fallbackImagePath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF06142D), Color(0xFF0B2451), Color(0xFF111827)],
            ),
          ),
        ),
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) {
            if (imagePath == fallbackImagePath) {
              return const SizedBox.shrink();
            }
            return Image.asset(
              fallbackImagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            );
          },
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.55),
                const Color(0xFF06142D).withValues(alpha: 0.78),
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.12),
              radius: 0.82,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.18),
                Colors.black.withValues(alpha: 0.62),
              ],
              stops: const [0, 0.66, 1],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.52,
              colors: [
                const Color(0xFF38BDF8).withValues(alpha: 0.12),
                Colors.transparent,
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
