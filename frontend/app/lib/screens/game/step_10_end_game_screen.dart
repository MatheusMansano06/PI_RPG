import 'package:flutter/material.dart';

import '../../data/step_01_roteiro_fases.dart';
import '../../services/step_04_game_progress_service.dart';
import '../../widgets/step_01_game_background.dart';
import '../../widgets/step_04_game_button.dart';
import '../../widgets/step_02_game_card.dart';
import '../../widgets/step_03_game_section_title.dart';

class EndGameScreen extends StatelessWidget {
  const EndGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 420;

    return Scaffold(
      body: GameBackground(
        imagePath: 'assets/images/backgrounds/phase_complete.png',
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
                      GameSectionTitle(
                        eyebrow: 'CAMPANHA FINALIZADA',
                        title: 'Jornada concluída',
                        subtitle:
                            'Você conectou mapa, narrativa, personagens e escolhas em uma experiência pelo Campus I.',
                        icon: Icons.emoji_events,
                        compact: compact,
                      ),
                      const SizedBox(height: 20),
                      ...roteiroFases.map(
                        (environment) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF0F172A,
                            ).withValues(alpha: 0.68),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(
                                0xFF22C55E,
                              ).withValues(alpha: 0.28),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF22C55E),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      environment.nome,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      environment.textoMissaoConcluida,
                                      style: const TextStyle(
                                        color: Color(0xFFCBD5E1),
                                        height: 1.25,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GameButton(
                        label: 'Reiniciar jornada',
                        icon: Icons.replay,
                        onPressed: () {
                          GameProgressService.instance.reiniciar();
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
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
