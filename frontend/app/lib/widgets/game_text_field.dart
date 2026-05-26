import 'package:flutter/material.dart';

class GameTextField extends StatefulWidget {
  const GameTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.enabled,
    this.keyboardType,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool enabled;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  State<GameTextField> createState() => _GameTextFieldState();
}

class _GameTextFieldState extends State<GameTextField> {
  late final FocusNode _focusNode;

  bool _hovered = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _focused;
    final borderGradient = active
        ? const LinearGradient(colors: [Color(0xFFF5C542), Color(0xFF38BDF8)])
        : LinearGradient(
            colors: [
              const Color(0xFF334155).withValues(alpha: 0.9),
              const Color(0xFF1E293B).withValues(alpha: 0.9),
            ],
          );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 210),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(1.2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: borderGradient,
          boxShadow: [
            if (active)
              BoxShadow(
                color:
                    (_focused
                            ? const Color(0xFFF5C542)
                            : const Color(0xFF38BDF8))
                        .withValues(alpha: 0.18),
                blurRadius: _focused ? 24 : 16,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: TextField(
            focusNode: _focusNode,
            controller: widget.controller,
            enabled: widget.enabled,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            cursorColor: const Color(0xFFF5C542),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: _focused
                  ? const Color(0xFF0B1220).withValues(alpha: 0.96)
                  : const Color(0xFF0F172A).withValues(alpha: 0.9),
              labelText: widget.label,
              labelStyle: TextStyle(
                color: _focused
                    ? const Color(0xFFFDE68A)
                    : const Color(0xFFCBD5E1),
                fontWeight: FontWeight.w700,
              ),
              prefixIcon: Icon(
                widget.icon,
                color: _focused
                    ? const Color(0xFFF5C542)
                    : const Color(0xFFBAE6FD),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 17,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
