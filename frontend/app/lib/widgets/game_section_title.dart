import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFFF5C542), size: compact ? 38 : 48),
        SizedBox(height: compact ? 10 : 12),
        Text(
          eyebrow,
          textAlign: textAlign,
          style: const TextStyle(
            color: Color(0xFFBAE6FD),
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: textAlign,
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 28 : 34,
            fontWeight: FontWeight.w900,
            height: 1.02,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: compact ? 10 : 12),
          Text(
            subtitle!,
            textAlign: textAlign,
            style: const TextStyle(
              color: Color(0xFFCBD5E1),
              fontSize: 15,
              height: 1.42,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
        SizedBox(height: compact ? 10 : 14),
        const _DecorativeRule(),
      ],
    );
  }
}

class _DecorativeRule extends StatelessWidget {
  const _DecorativeRule();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _RuleLine()),
        Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF5C542),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF5C542).withValues(alpha: 0.35),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        const Expanded(child: _RuleLine()),
      ],
    );
  }
}

class _RuleLine extends StatelessWidget {
  const _RuleLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            const Color(0xFF38BDF8).withValues(alpha: 0.65),
            const Color(0xFFF5C542).withValues(alpha: 0.5),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
