import 'package:flutter/material.dart';

import '../services/game_progress_service.dart';
import '../widgets/game_background.dart';
import '../widgets/game_button.dart';
import '../widgets/game_card.dart';
import '../widgets/game_hud_badge.dart';
import '../widgets/game_section_title.dart';
import 'game/map_game_screen.dart';
import 'progress_screen.dart';
import 'prologue_screen.dart';
import 'settings_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = GameProgressService.instance;
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 680 || size.width < 420;
    final showHud = size.width >= 900;

    return Scaffold(
      body: GameBackground(
        imagePath: 'assets/images/backgrounds/start_campus.png',
        child: SafeArea(
          child: Stack(
            children: [
              if (showHud) ...const [
                Positioned(
                  left: 42,
                  top: 76,
                  child: _SideHud(
                    title: 'Perfil do Calouro',
                    lines: ['Nivel 1', 'XP 0/100', 'Campus I'],
                  ),
                ),
                Positioned(
                  right: 42,
                  bottom: 76,
                  child: _SideHud(
                    title: 'Missao Ativa',
                    lines: ['Primeiro Dia', 'Sobrevivencia', 'Mapa liberado'],
                    alignRight: true,
                  ),
                ),
              ],
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width < 420 ? 16 : 24,
                    vertical: compact ? 16 : 24,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: GameGlassCard(
                      padding: EdgeInsets.all(compact ? 18 : 28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                                label: 'Nivel',
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
                            title: 'Missao Sobrevivencia',
                            subtitle:
                                'Escolha seu proximo passo e avance pela aventura narrativa do Campus I.',
                            icon: Icons.travel_explore,
                            compact: compact,
                          ),
                          SizedBox(height: compact ? 18 : 24),
                          GameButton(
                            label: 'Iniciar Jornada',
                            icon: Icons.play_arrow,
                            compact: compact,
                            onPressed: () {
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
                            label: 'Continuar Missao',
                            icon: Icons.map_outlined,
                            variant: GameButtonVariant.secondary,
                            compact: compact,
                            onPressed: () {
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
            ],
          ),
        ),
      ),
    );
  }
}

class _SideHud extends StatelessWidget {
  const _SideHud({
    required this.title,
    required this.lines,
    this.alignRight = false,
  });

  final String title;
  final List<String> lines;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: Column(
        crossAxisAlignment: alignRight
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              color: Color(0xFFF5C542),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Text(
                line,
                textAlign: alignRight ? TextAlign.right : TextAlign.left,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
