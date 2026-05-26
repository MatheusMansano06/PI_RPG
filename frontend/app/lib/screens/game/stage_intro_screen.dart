import 'package:flutter/material.dart';

import '../../models/game_environment_model.dart';
import '../../widgets/game_background.dart';
import '../../widgets/game_button.dart';
import '../../widgets/game_card.dart';
import '../../widgets/game_hud_badge.dart';
import '../../widgets/game_section_title.dart';
import 'npc_dialogue_screen.dart';

class StageIntroScreen extends StatelessWidget {
  const StageIntroScreen({super.key, required this.environment});

  final GameEnvironmentModel environment;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 700 || size.width < 420;

    return Scaffold(
      body: GameBackground(
        imagePath: 'assets/images/backgrounds/start_campus.png',
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(compact ? 16 : 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: GameGlassCard(
                  padding: EdgeInsets.all(compact ? 18 : 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          GameHudBadge(
                            icon: Icons.flag_outlined,
                            label: 'Fase',
                            value: '${environment.stageNumber}',
                          ),
                          GameHudBadge(
                            icon: Icons.bolt_outlined,
                            label: 'Recompensa',
                            value: '+${environment.challenge.rewardXp} XP',
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 14 : 20),
                      GameSectionTitle(
                        eyebrow: 'BRIEFING DA FASE',
                        title: environment.nome,
                        subtitle: environment.introText,
                        icon: Icons.assignment_outlined,
                        compact: compact,
                      ),
                      SizedBox(height: compact ? 16 : 22),
                      _InfoGrid(environment: environment),
                      SizedBox(height: compact ? 16 : 22),
                      GameButton(
                        label: 'Iniciar exploracao',
                        icon: Icons.theater_comedy_outlined,
                        compact: compact,
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  NpcDialogueScreen(environment: environment),
                            ),
                          );
                        },
                      ),
                    ],
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

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.environment});

  final GameEnvironmentModel environment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= 560;
        final width = twoColumns
            ? (constraints.maxWidth - 10) / 2
            : constraints.maxWidth;
        final tiles = [
          _InfoTile(
            icon: Icons.flag,
            label: 'Missao',
            value: environment.missionTitle,
          ),
          _InfoTile(
            icon: Icons.track_changes,
            label: 'Objetivo',
            value: environment.missionDescription,
          ),
          _InfoTile(
            icon: Icons.person_4_outlined,
            label: 'NPC',
            value: environment.npc.nome,
          ),
          _InfoTile(
            icon: Icons.card_giftcard,
            label: 'Recompensa',
            value: '+${environment.challenge.rewardXp} XP',
          ),
        ];

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: tiles
              .map((tile) => SizedBox(width: width, child: tile))
              .toList(),
        );
      },
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF38BDF8).withValues(alpha: 0.24),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFF5C542), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFBAE6FD),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    height: 1.28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
