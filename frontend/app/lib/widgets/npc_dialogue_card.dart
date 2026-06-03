import 'package:flutter/material.dart';

import '../models/npc_model.dart';
import 'game_card.dart';
import 'game_hud_badge.dart';

class NpcDialogueCard extends StatelessWidget {
  const NpcDialogueCard({
    super.key,
    required this.npc,
    required this.locationName,
  });

  final NpcModel npc;
  final String locationName;

  @override
  Widget build(BuildContext context) {
    final persona = _npcPersona(npc.nome);
    return GameGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [persona.color, const Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFF5C542).withValues(alpha: 0.48),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    persona.avatar,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      npc.nome,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      npc.descricao,
                      style: const TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: persona.color.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: persona.color.withValues(alpha: 0.45),
                        ),
                      ),
                      child: Text(
                        persona.role,
                        style: TextStyle(
                          color: persona.color,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GameHudBadge(icon: Icons.location_on_outlined, label: locationName),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF020617).withValues(alpha: 0.58),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF7DD3FC).withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              npc.falaInicial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.38,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

({String avatar, String role, Color color}) _npcPersona(String npcName) {
  final lower = npcName.toLowerCase();
  if (lower.contains('professor')) {
    return (
      avatar: '🧠',
      role: 'MESTRE ESTRATEGA',
      color: const Color(0xFF60A5FA),
    );
  }
  if (lower.contains('bia') || lower.contains('helena')) {
    return (
      avatar: '🛰️',
      role: 'GUIA DO CAMPUS',
      color: const Color(0xFF34D399),
    );
  }
  if (lower.contains('ze')) {
    return (
      avatar: '🛡️',
      role: 'SENTINELA DA ENTRADA',
      color: const Color(0xFFF59E0B),
    );
  }
  return (
    avatar: '🎯',
    role: 'PERSONAGEM ALIADO',
    color: const Color(0xFFA78BFA),
  );
}
