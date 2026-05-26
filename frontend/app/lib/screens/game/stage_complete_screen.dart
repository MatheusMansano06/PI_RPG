import 'package:flutter/material.dart';

import '../../models/game_environment_model.dart';
import '../../services/game_progress_service.dart';
import '../../widgets/game_background.dart';
import '../../widgets/game_button.dart';
import '../../widgets/game_card.dart';
import '../../widgets/game_hud_badge.dart';
import '../../widgets/game_section_title.dart';
import 'end_game_screen.dart';

class StageCompleteScreen extends StatefulWidget {
  const StageCompleteScreen({super.key, required this.environment});

  final GameEnvironmentModel environment;

  @override
  State<StageCompleteScreen> createState() => _StageCompleteScreenState();
}

class _StageCompleteScreenState extends State<StageCompleteScreen> {
  bool _marked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_marked) {
      GameProgressService.instance.marcarComoConcluido(widget.environment.id);
      _marked = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = GameProgressService.instance;
    final next = service.obterProximoAmbiente();
    final isLast = next == null;
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 700 || size.width < 420;

    return Scaffold(
      body: GameBackground(
        imagePath: 'assets/images/backgrounds/phase_complete.png',
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(compact ? 16 : 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: GameGlassCard(
                  padding: EdgeInsets.all(compact ? 18 : 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.military_tech,
                        color: Color(0xFFF5C542),
                        size: 76,
                      ),
                      SizedBox(height: compact ? 12 : 16),
                      GameSectionTitle(
                        eyebrow: 'RECOMPENSA',
                        title: 'Missao concluida',
                        subtitle: widget.environment.completionText,
                        icon: Icons.emoji_events_outlined,
                        compact: compact,
                      ),
                      SizedBox(height: compact ? 16 : 22),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          GameHudBadge(
                            icon: Icons.flag_outlined,
                            label: 'Fase',
                            value: '${widget.environment.stageNumber}',
                          ),
                          GameHudBadge(
                            icon: Icons.bolt_outlined,
                            label: 'XP ganho',
                            value: '+${widget.environment.challenge.rewardXp}',
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 16 : 20),
                      _RewardTile(
                        icon: Icons.card_giftcard,
                        label: 'Recompensa',
                        value: widget.environment.challenge.rewardText,
                      ),
                      _RewardTile(
                        icon: isLast ? Icons.emoji_events : Icons.lock_open,
                        label: isLast
                            ? 'Jornada completa'
                            : 'Proximo ambiente desbloqueado',
                        value: isLast ? 'Todas as fases concluidas' : next.nome,
                      ),
                      SizedBox(height: compact ? 16 : 20),
                      GameButton(
                        label: isLast ? 'Ver encerramento' : 'Voltar ao mapa',
                        icon: isLast ? Icons.emoji_events : Icons.map_outlined,
                        compact: compact,
                        onPressed: () {
                          if (isLast) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (_) => const EndGameScreen(),
                              ),
                            );
                            return;
                          }
                          Navigator.of(context).pop(true);
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

class _RewardTile extends StatelessWidget {
  const _RewardTile({
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
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF5C542).withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFF5C542)),
          const SizedBox(width: 12),
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
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
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
