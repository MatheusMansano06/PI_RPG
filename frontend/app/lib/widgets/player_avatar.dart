import 'package:flutter/material.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1D4ED8),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.shield,
              color: Colors.white,
              size: 24,
            ),
          ),
          Container(
            width: 16,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0x66000000),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
