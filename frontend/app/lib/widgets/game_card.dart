import 'dart:ui';

import 'package:flutter/material.dart';

class GameGlassCard extends StatelessWidget {
  const GameGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 38,
            offset: const Offset(0, 22),
          ),
          BoxShadow(
            color: const Color(0xFF38BDF8).withValues(alpha: 0.18),
            blurRadius: 28,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: const Color(0xFFF5C542).withValues(alpha: 0.08),
            blurRadius: 18,
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF07111F).withValues(alpha: 0.9),
                  const Color(0xFF0B1F3A).withValues(alpha: 0.75),
                  const Color(0xFF020617).withValues(alpha: 0.86),
                ],
              ),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: const Color(0xFFF5C542).withValues(alpha: 0.56),
                width: 1.2,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.055),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(padding: padding, child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
