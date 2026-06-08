import 'package:flutter/material.dart';

import '../data/step_01_roteiro_fases.dart';
import '../services/step_04_game_progress_service.dart';
import '../widgets/step_01_game_background.dart';
import '../widgets/step_04_game_button.dart';
import '../widgets/step_02_game_card.dart';
import '../widgets/step_03_game_section_title.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = GameProgressService.instance;
    final size = MediaQuery.sizeOf(context);
    final compact = size.width < 420;

    return Scaffold(
      body: GameBackground(
        imagePath: 'assets/images/backgrounds/start_campus.png',
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(compact ? 16 : 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: GameGlassCard(
                  padding: EdgeInsets.all(compact ? 18 : 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GameSectionTitle(
                        eyebrow: 'DIÁRIO DE BORDO',
                        title: 'Progresso da jornada',
                        subtitle:
                            'Acompanhe ambientes desbloqueados, concluídos e a próxima missão do Campus I.',
                        icon: Icons.timeline,
                        compact: compact,
                      ),
                      const SizedBox(height: 20),
                      ...roteiroFases.map((environment) {
                        final done = progress.ambientesConcluidos.contains(
                          environment.id,
                        );
                        final current =
                            progress.ambienteAtualId == environment.id;
                        return _ProgressTile(
                          stage: environment.stageNumber,
                          title: environment.nome,
                          subtitle: environment.missionTitle,
                          icon: done
                              ? Icons.check_circle
                              : current
                              ? Icons.flag_circle
                              : Icons.lock,
                          color: done
                              ? const Color(0xFF22C55E)
                              : current
                              ? const Color(0xFFF5C542)
                              : const Color(0xFF94A3B8),
                        );
                      }),
                      const SizedBox(height: 14),
                      GameButton(
                        label: 'Voltar ao menu',
                        icon: Icons.arrow_back,
                        variant: GameButtonVariant.secondary,
                        onPressed: () => Navigator.of(context).pop(),
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

class _ProgressTile extends StatelessWidget {
  const _ProgressTile({
    required this.stage,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final int stage;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.36)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fase $stage - $title',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 12,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
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
