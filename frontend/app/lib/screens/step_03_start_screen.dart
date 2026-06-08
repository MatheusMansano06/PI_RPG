import 'package:flutter/material.dart';

import '../services/step_04_game_progress_service.dart';
import '../widgets/step_01_game_background.dart';
import '../widgets/step_04_game_button.dart';
import '../widgets/step_02_game_card.dart';
import '../widgets/step_06_game_hud_badge.dart';
import '../widgets/step_03_game_section_title.dart';
import 'game/step_05_map_game_screen.dart';
import 'step_11_progress_screen.dart';
import 'step_04_prologue_screen.dart';
import 'step_12_settings_screen.dart';

// Tela inicial depois do login.
// A partir daqui o jogador escolhe se vai iniciar, continuar, ver progresso ou configuracoes.
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = GameProgressService.instance;
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 680 || size.width < 420;

    return Scaffold(
      body: GameBackground(
        imagePath: 'assets/images/backgrounds/start_campus.png',
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: GameGlassCard(
                  padding: EdgeInsets.all(compact ? 18 : 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Esses badges sao apenas informacoes rapidas do jogador.
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: const [
                          GameHudBadge(
                            icon: Icons.school_outlined,
                            label: 'Campus I',
                          ),
                          GameHudBadge(
                            icon: Icons.bolt_outlined,
                            label: 'Nível',
                            value: '1',
                          ),
                          GameHudBadge(
                            icon: Icons.auto_graph,
                            label: 'XP',
                            value: '0/100',
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 16 : 22),
                      GameSectionTitle(
                        eyebrow: 'PRIMEIRO DIA',
                        title: 'Missão Sobrevivência',
                        subtitle:
                            'Escolha o próximo passo e avance por uma história inspirada no Campus I.',
                        icon: Icons.travel_explore,
                        compact: compact,
                      ),
                      SizedBox(height: compact ? 18 : 24),
                      GameButton(
                        label: 'Iniciar jornada',
                        icon: Icons.play_arrow,
                        compact: compact,
                        onPressed: () {
                          // Reinicia para garantir que a historia comece da fase 1.
                          progress.reiniciar();
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const PrologueScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      GameButton(
                        label: 'Continuar missão',
                        icon: Icons.map_outlined,
                        variant: GameButtonVariant.secondary,
                        compact: compact,
                        onPressed: () {
                          // Vai direto para o mapa, usando o progresso atual.
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const GameMapScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      GameButton(
                        label: 'Ver Progresso',
                        icon: Icons.timeline,
                        variant: GameButtonVariant.subtle,
                        compact: compact,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const ProgressScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      GameButton(
                        label: 'Configuracoes',
                        icon: Icons.tune,
                        variant: GameButtonVariant.subtle,
                        compact: compact,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const SettingsScreen(),
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
