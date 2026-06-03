import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class CinematicCloudLayer extends StatefulWidget {
  const CinematicCloudLayer({super.key, this.opacity = 0.32, this.speed = 1});

  final double opacity;
  final double speed;

  @override
  State<CinematicCloudLayer> createState() => _CinematicCloudLayerState();
}

class _CinematicCloudLayerState extends State<CinematicCloudLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (14000 / widget.speed).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return IgnorePointer(
          child: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                _CloudBlob(
                  xFactor: _loop(0.08 + t * 0.18),
                  yFactor: 0.18,
                  radius: 140,
                  color: const Color(
                    0xFFDBF4FF,
                  ).withValues(alpha: widget.opacity),
                ),
                _CloudBlob(
                  xFactor: _loop(0.70 - t * 0.12),
                  yFactor: 0.30,
                  radius: 120,
                  color: const Color(
                    0xFFF8FCFF,
                  ).withValues(alpha: widget.opacity * 0.9),
                ),
                _CloudBlob(
                  xFactor: _loop(0.36 + t * 0.14),
                  yFactor: 0.64,
                  radius: 170,
                  color: const Color(
                    0xFFDDEEFF,
                  ).withValues(alpha: widget.opacity * 0.8),
                ),
                _CloudBlob(
                  xFactor: _loop(0.90 - t * 0.10),
                  yFactor: 0.78,
                  radius: 130,
                  color: const Color(
                    0xFFFFFFFF,
                  ).withValues(alpha: widget.opacity * 0.7),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _loop(double v) {
    final frac = v - v.floorToDouble();
    return frac;
  }
}

class _CloudBlob extends StatelessWidget {
  const _CloudBlob({
    required this.xFactor,
    required this.yFactor,
    required this.radius,
    required this.color,
  });

  final double xFactor;
  final double yFactor;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(xFactor * 2 - 1, yFactor * 2 - 1),
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 34, sigmaY: 34),
        child: Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color,
                color.withValues(alpha: color.a * 0.54),
                color.withValues(alpha: 0),
              ],
              stops: const [0, 0.55, 1],
              transform: const GradientRotation(math.pi / 5),
            ),
          ),
        ),
      ),
    );
  }
}
