import 'package:flutter/material.dart';

enum GameButtonVariant { primary, secondary, subtle }

class GameButton extends StatefulWidget {
  const GameButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.variant = GameButtonVariant.primary,
    this.compact = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final GameButtonVariant variant;
  final bool compact;

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final isPrimary = widget.variant == GameButtonVariant.primary;
    final isSubtle = widget.variant == GameButtonVariant.subtle;
    final active = enabled && (_hovered || _pressed);
    final height = widget.compact
        ? isSubtle
              ? 42.0
              : 48.0
        : isSubtle
        ? 46.0
        : 56.0;

    final gradient = switch (widget.variant) {
      GameButtonVariant.primary => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: active
            ? const [Color(0xFF1D4ED8), Color(0xFF2563EB), Color(0xFFD4A51C)]
            : const [Color(0xFF2563EB), Color(0xFF1D4ED8), Color(0xFF0F3EA8)],
      ),
      GameButtonVariant.secondary => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: active
            ? const [Color(0xFF172554), Color(0xFF0F766E)]
            : const [Color(0xFF0F172A), Color(0xFF172554)],
      ),
      GameButtonVariant.subtle => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF0F172A).withValues(alpha: active ? 0.94 : 0.78),
          const Color(0xFF172554).withValues(alpha: active ? 0.9 : 0.66),
        ],
      ),
    };

    final foreground = isSubtle ? const Color(0xFFE0F2FE) : Colors.white;
    final borderColor = isPrimary
        ? const Color(0xFFF5C542).withValues(alpha: active ? 0.78 : 0.5)
        : const Color(0xFF7DD3FC).withValues(alpha: active ? 0.52 : 0.3);

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: Listener(
        onPointerDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onPointerUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onPointerCancel: enabled
            ? (_) => setState(() => _pressed = false)
            : null,
        child: AnimatedScale(
          scale: !enabled
              ? 1
              : _pressed
              ? 0.985
              : _hovered
              ? 1.014
              : 1,
          duration: const Duration(milliseconds: 135),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 190),
            height: height,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
              boxShadow: enabled
                  ? [
                      if (isPrimary)
                        BoxShadow(
                          color: const Color(
                            0xFF2563EB,
                          ).withValues(alpha: active ? 0.46 : 0.3),
                          blurRadius: active ? 28 : 18,
                          offset: const Offset(0, 12),
                        ),
                      if (isPrimary)
                        BoxShadow(
                          color: const Color(
                            0xFFF5C542,
                          ).withValues(alpha: active ? 0.24 : 0.12),
                          blurRadius: active ? 24 : 14,
                          spreadRadius: -2,
                        ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: widget.onPressed,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.icon,
                          color: foreground,
                          size: isPrimary ? 21 : 18,
                        ),
                        const SizedBox(width: 9),
                        Flexible(
                          child: Text(
                            widget.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: foreground,
                              fontSize: isPrimary ? 15 : 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
